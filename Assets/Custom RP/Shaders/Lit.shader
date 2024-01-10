Shader "Custom RP/Lit" {
	// 프로퍼티 블록
	Properties {
		// 텍스쳐 속성을 나타내는 변수 정의
		_BaseMap("Texture", 2D) = "white" {}
		
		// 기본 컬러를 나타내는 변수 정의
		_BaseColor("Color", Color) = (0.5, 0.5, 0.5, 1.0)
		
		// 알파 CutOff 기능을 위한 변수 정의
		_Cutoff ("Alpha Cutoff", Range(0.0, 1.0)) = 0.5
		
		// 알파 클리핑을 할지 말지에 대한 변수 정의
		[Toggle(_CLIPPING)] _Clipping ("Alpha Clipping", Float) = 0
		
		// 블랜딩 모드 지원 속성 정의
		[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("Src Blend", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("Dst Blend", Float) = 0
		
		// z 버퍼에 쓸지 말지 결정하는 속성 정의
		[Enum(Off, 0, On, 1)] _ZWrite ("Z Write", Float) = 1
	}
	
	// 서브셰이더 블록
	SubShader {
		Pass
		{
			Tags {
				"LightMode" = "CustomLit"
			}
			
			// 블랜딩 모드
			Blend [_SrcBlend] [_DstBlend]
			
			// z 버퍼
			ZWrite [_ZWrite]
			
		    HLSLPROGRAM
		    #pragma target 3.5
		    
		    // _CLIPPING이 정의되면 해당 부분의 코드를 컴파일
		    #pragma shader_feature _CLIPPING

		    // 인스턴싱이 사용되면 해당 부분의 코드를 컴파일
		    #pragma multi_compile_instancing

		    // UnlitPassVertex / UnlitPassFragment 는 UnlitPass.hlsl 에 정의되어 있습니다. 
		    #include "LitPass.hlsl"
		    
		    // UnlitPassVertex 함수를 버텍스 셰이더로 사용
		    #pragma vertex LitPassVertex

		    // UnlitPassFragment 함수를 픽셀 셰이더로 사용
		    #pragma fragment LitPassFragment
		    ENDHLSL
		}
	}
}
