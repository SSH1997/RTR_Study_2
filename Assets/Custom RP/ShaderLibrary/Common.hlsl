// CUSTOM_COMMON_INCLUDED 가 정의되어 있다면
// 아래의 코드를 실행하지 않습니다.
#ifndef CUSTOM_COMMON_INCLUDED

// 정의되어있지 않기 때문에 정의를 합니다. 중복된 정의를 막기 위해 사용됩니다.
#define CUSTOM_COMMON_INCLUDED

// 기본적인 매크로를 얻어오기 위해 include 하는 core 라이브러리
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonMaterial.hlsl"

// 미리 정의한 유니폼 변수들을 include 하고,
#include "UnityInput.hlsl"

// 매크로를 통해서 알맞은 변수로 변경해줍니다.
#define UNITY_MATRIX_M unity_ObjectToWorld
#define UNITY_MATRIX_I_M unity_WorldToObject
#define UNITY_MATRIX_V unity_MatrixV
#define UNITY_MATRIX_I_V unity_MatrixInvV
#define UNITY_MATRIX_VP unity_MatrixVP
#define UNITY_PREV_MATRIX_M unity_prev_MatrixM
#define UNITY_PREV_MATRIX_I_M unity_prev_MatrixIM
#define UNITY_MATRIX_P glstate_matrix_projection

// GPU 인스턴싱을 위해 추가한 라이브러리
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"

// 미리 정의된 행렬 변환을 위해 추가한 라이브러리
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/SpaceTransforms.hlsl"

// 유니티 인스턴싱 버퍼 정의를 시작
UNITY_INSTANCING_BUFFER_START(UnityPerMaterial)
    UNITY_DEFINE_INSTANCED_PROP(float4, _BaseMap_ST)
    UNITY_DEFINE_INSTANCED_PROP(float4, _BaseColor)
    UNITY_DEFINE_INSTANCED_PROP(float, _Cutoff)
    UNITY_DEFINE_INSTANCED_PROP(float, _Metallic)
    UNITY_DEFINE_INSTANCED_PROP(float, _Smoothness)
// 유니티 인스턴싱 버퍼 정의 끝
UNITY_INSTANCING_BUFFER_END(UnityPerMaterial)

float Square (float v) {
    return v * v;
}

#endif