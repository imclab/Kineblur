Shader "Hidden/Cineblur/Postprocess"
{
    Properties
    {
        _MainTex        ("-", 2D) = ""{}
        _VelocityTex    ("-", 2D) = ""{}
    }

    CGINCLUDE

    #include "UnityCG.cginc"

    sampler2D _MainTex;
    float4 _MainTex_TexelSize;

    sampler2D _VelocityTex;
    float4 _VelocityTex_TexelSize;

    const int nSample = 8;

    half4 frag(v2f_img i) : SV_Target 
    {
        float2 v = tex2D(_VelocityTex, i.uv).xy;
        float4 s = tex2D(_MainTex, i.uv);
        for (int si = 1; si < nSample; si++)
        {
            s += tex2D(_MainTex, i.uv - v * (_MainTex_TexelSize.xy * 4 * (si - nSample / 2)));
        }
        return s / nSample;
    }

    ENDCG 

    Subshader
    {
        Pass
        {
            ZTest Always Cull Off ZWrite Off
            Fog { Mode off }      
            CGPROGRAM
            #pragma target 3.0
            #pragma glsl
            #pragma vertex vert_img
            #pragma fragment frag
            ENDCG
        }
    }
}