using UnityEngine;
using UnityEngine.Rendering;

public partial class CameraRenderer
{
    ScriptableRenderContext context;

    Camera camera;
    
    const string bufferName = "Render Camera";

    CommandBuffer buffer = new CommandBuffer
    {
        name = bufferName
    };
    
    CullingResults cullingResults;
    
    static ShaderTagId unlitShaderTagId = new ShaderTagId("SRPDefaultUnlit");

    void Setup () {
        context.SetupCameraProperties(camera);
        CameraClearFlags flags = camera.clearFlags;
        buffer.ClearRenderTarget(
            flags <= CameraClearFlags.Depth,
            flags == CameraClearFlags.Color,
            flags == CameraClearFlags.Color ?
                camera.backgroundColor.linear : Color.clear);
        buffer.BeginSample(SampleName);
        ExecuteBuffer();        
    }

    public void Render (ScriptableRenderContext context, Camera camera, bool useDynamicBatching, bool useGPUInstancing)
    {
        this.context = context;
        this.camera = camera;

        PrepareBuffer();
        PrepareForSceneWindow();
        
        if (!Cull()) { return; }
        
        Setup();
        DrawVisibleGeometry(useDynamicBatching, useGPUInstancing);
#if UNITY_EDITOR
        DrawUnsupportedShaders();
        DrawGizmos();
#endif
        Submit();
    }
    
    bool Cull ()
    {
        if (camera.TryGetCullingParameters(out ScriptableCullingParameters p))
        {
            cullingResults = context.Cull(ref p);
            return true;
        }
        
        return false;
    }

    void DrawVisibleGeometry (bool useDynamicBatching, bool useGPUInstancing)
    {
        var sortingSettings = new SortingSettings(camera);
        var drawingSettings = new DrawingSettings(unlitShaderTagId, sortingSettings)
        {
            enableDynamicBatching = useDynamicBatching,
            enableInstancing = useGPUInstancing
        };
        var filteringSettings = new FilteringSettings(RenderQueueRange.opaque);

        context.DrawRenderers(cullingResults, ref drawingSettings, ref filteringSettings);
        
        context.DrawSkybox(camera);

        sortingSettings.criteria = SortingCriteria.CommonTransparent;
        drawingSettings.sortingSettings = sortingSettings;
        filteringSettings.renderQueueRange = RenderQueueRange.transparent;

        context.DrawRenderers(cullingResults, ref drawingSettings, ref filteringSettings);
    }
    
    void Submit ()
    {
        buffer.EndSample(SampleName);
        ExecuteBuffer();
        context.Submit();
    }
    
    void ExecuteBuffer ()
    {
        context.ExecuteCommandBuffer(buffer);
        buffer.Clear();
    }
}