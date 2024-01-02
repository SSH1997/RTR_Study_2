// CUSTOM_UNITY_INPUT_INCLUDED 가 정의되어 있다면
// 아래의 코드를 실행하지 않습니다.
#ifndef CUSTOM_UNITY_INPUT_INCLUDED

// 정의되어있지 않기 때문에 정의를 합니다. 중복된 정의를 막기 위해 사용됩니다.
#define CUSTOM_UNITY_INPUT_INCLUDED     

// 상수 버퍼 정의 시작
CBUFFER_START(UnityPerDraw)
    // 라이브러리에서 사용되는 변수로 치환해야해서 매크로를 사용해야합니다.
    // Common.hlsl 에 매크로가 나와있습니다.
    float4x4 unity_ObjectToWorld;
    float4x4 unity_WorldToObject;
    float4 unity_LODFade;
    real4 unity_WorldTransformParams;
// 상수 버퍼 정의 끝
CBUFFER_END

// 마찬가지로 Common.hsls 에서 매크로를 확인할 수 있습니다.
// 변경할 수 있는 값이기 때문에 상수 버퍼로 넘기지 않습니다.
float4x4 unity_MatrixVP;
float4x4 unity_MatrixV;
float4x4 unity_MatrixInvV;
float4x4 unity_prev_MatrixM;
float4x4 unity_prev_MatrixIM;
float4x4 glstate_matrix_projection;

#endif