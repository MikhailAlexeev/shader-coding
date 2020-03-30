Shader "Custom/Standard"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _ScrollSpeedX ("Scroll Speed X", Range(0, 50)) = 0.0
        _ScrollSpeedY ("Scroll Speed Y", Range(0, 50)) = 0.0
        _NormalMap ("Normal Map", 2D) = "bump" {}
        _NormalIntensity ("Normal Map Intensity", Range(0, 10)) = 1.0 
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0
        #pragma shader_feature _NORMALMAP

        sampler2D _MainTex;
        sampler2D _NormalMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalMap;
        };

        float _ScrollSpeedX;
        float _ScrollSpeedY;
        float _NormalIntensity;
        
        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float2 uv = IN.uv_MainTex;
            uv.x +=  _Time.x *_ScrollSpeedX;
            uv.y +=  _Time.x *_ScrollSpeedY;
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, uv) * _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            float2 uvScrollNormal = IN.uv_NormalMap;
            uvScrollNormal += fixed2(_ScrollSpeedX * _Time.x, _ScrollSpeedY * _Time.x);
            float3 normalMap = UnpackNormal(tex2D(_NormalMap, uvScrollNormal));
            normalMap.x *= _NormalIntensity;
            normalMap.y *= _NormalIntensity;
            o.Normal = normalize(normalMap.rgb);
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
