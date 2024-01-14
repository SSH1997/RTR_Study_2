// CUSTOM_LIT_PASS_INCLUDED 가 정의되어 있다면
// 아래의 코드를 실행하지 않습니다.
#ifndef CUSTOM_LIT_PASS_INCLUDED

// 정의되어있지 않기 때문에 정의를 합니다. 중복된 정의를 막기 위해 사용됩니다.
#define CUSTOM_LIT_PASS_INCLUDED

// Common.hlsl 에 include 된 라이브러리(Common, UnityInstancing, UnityInstancing) 및
// 인스턴싱 버퍼를 사용하기 위해 include 합니다.
#include "../ShaderLibrary/Common.hlsl"
#include "../ShaderLibrary/Surface.hlsl"
#include "../ShaderLibrary/Light.hlsl"
#include "../ShaderLibrary/BRDF.hlsl"
#include "../ShaderLibrary/Lighting.hlsl"

// _BaseMap 이라는 이름의 텍스처를 정의합니다.
// sampler_BaseMap 이라는 이름의 샘플러를 정의합니다.
TEXTURE2D(_BaseMap);
SAMPLER(sampler_BaseMap);

// 버텍스 셰이더에서 사용되는 입력 구조체로, 정점의 속성을 나타냅니다.
struct Attributes
{
	// 정점의 위치
	float3 positionOS : POSITION;

	float3 normalOS : NORMAL;
	
	// 기본 UV 좌표
	float2 baseUV : TEXCOORD0;

	// 인스턴스 ID 메크로
	UNITY_VERTEX_INPUT_INSTANCE_ID
};

// 픽셀 셰이더로 전달되는 변수들을 나타내는 구조체입니다.
struct Varyings {
	// 클립 공간 위치
	float4 positionCS : SV_POSITION;
	float3 positionWS : VAR_POSITION;

	float3 normalWS : VAR_NORMAL;
	
	// 기본 UV 좌표
	float2 baseUV : VAR_BASE_UV;

	// 인스턴스 ID 매크로
	UNITY_VERTEX_INPUT_INSTANCE_ID
};


// 버텍스 셰이더 함수로, 정점의 변환 및 인스턴싱 관련 작업을 수행합니다.
// 클립 공간으로의 변환과 기본 UV 좌표의 인스턴스 속성을 계산합니다.
Varyings LitPassVertex (Attributes input) {
	Varyings output;
	UNITY_SETUP_INSTANCE_ID(input);
	UNITY_TRANSFER_INSTANCE_ID(input, output);
	output.positionWS = TransformObjectToWorld(input.positionOS);
	output.positionCS = TransformWorldToHClip(output.positionWS);
	float4 baseST = UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _BaseMap_ST);
	output.baseUV = input.baseUV * baseST.xy + baseST.zw;
	output.normalWS = TransformObjectToWorldNormal(input.normalOS);
	return output;
}

// 픽셀 셰이더 함수로, 텍스처를 샘플링하여 기본 색상을 계산하고 반환합니다.
// 필요에 따라 클리핑을 수행하여 _Cutoff 속성에 따라 픽셀을 제거할 수 있습니다.
float4 LitPassFragment(Varyings input) : SV_TARGET
{
	UNITY_SETUP_INSTANCE_ID(input);
	float4 baseMap = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, input.baseUV);
	float4 baseColor = UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _BaseColor);
	float4 base = baseMap * baseColor;
	#if defined(_CLIPPING)
		clip(base.a - UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _Cutoff));
	#endif
	Surface surface;
	surface.normal = normalize(input.normalWS);
	surface.viewDirection = normalize(_WorldSpaceCameraPos - input.positionWS);
	surface.color = base.rgb;
	surface.alpha = base.a;
	surface.metallic = UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _Metallic);
	surface.smoothness =
		UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _Smoothness);

	#if defined(_PREMULTIPLY_ALPHA)
	BRDF brdf = GetBRDF(surface, true);
	#else
	BRDF brdf = GetBRDF(surface);
	#endif
	float3 color = GetLighting(surface, brdf);
	return float4(color, surface.alpha);
}

#endif
