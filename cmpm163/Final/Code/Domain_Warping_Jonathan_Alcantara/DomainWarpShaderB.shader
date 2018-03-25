// source: http://www.shaderslab.com/demo-74---2d-perlin-noise.html
Shader "Custom/Noise/Perlin"
{
    Properties
    {
    	_Color ("Color", Color) = (1, 1, 1, 1)
    	_Transparency ("Transparency", Range(0.0,1.0)) = .25
        _GridSize ("GridSize", float) = 1.0
        _X ("Seed X", float) = 1.0
        _Y ("Seed Y", float) = 1.0
    }
 
    SubShader
    {
        // Tags { "RenderType"="Opaque" }
 		Tags { "Queue"="Transparent" "RenderType"="Transparent" }
 		ZWrite Off
 		Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #include "UnityCG.cginc"

         	float4 _Color;
         	float _Transparency;
            float _GridSize;
            float _X;
            float _Y;

            float4 permute(float4 x)
            {
                return fmod(34.0 * pow(x, 2) + x, 289.0);
            }
 
            float2 fade(float2 t) {
                return 6.0 * pow(t, 5.0) - 15.0 * pow(t, 4.0) + 10.0 * pow(t, 3.0);
            }
 
            float4 taylorInvSqrt(float4 r) {
                return 1.79284291400159 - 0.85373472095314 * r;
            }
 
            #define DIV_289 0.00346020761245674740484429065744f
 
            float mod289(float x) {
                return x - floor(x * DIV_289) * 289.0;
            }
 
            float PerlinNoise2D(float2 P)
            {
                  float4 Pi = floor(P.xyxy) + float4(0.0, 0.0, 1.0, 1.0);
                  float4 Pf = frac (P.xyxy) - float4(0.0, 0.0, 1.0, 1.0);
 
                  float4 ix = Pi.xzxz;
                  float4 iy = Pi.yyww;
                  float4 fx = Pf.xzxz;
                  float4 fy = Pf.yyww;
 
                  float4 i = permute(permute(ix) + iy);
 
                  float4 gx = frac(i / 41.0) * 2.0 - 1.0 ;
                  float4 gy = abs(gx) - 0.5 ;
                  float4 tx = floor(gx + 0.5);
                  gx = gx - tx;
 
                  float2 g00 = float2(gx.x,gy.x);
                  float2 g10 = float2(gx.y,gy.y);
                  float2 g01 = float2(gx.z,gy.z);
                  float2 g11 = float2(gx.w,gy.w);
 
                  float4 norm = taylorInvSqrt(float4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
                  g00 *= norm.x;
                  g01 *= norm.y;
                  g10 *= norm.z;
                  g11 *= norm.w;
 
                  float n00 = dot(g00, float2(fx.x, fy.x));
                  float n10 = dot(g10, float2(fx.y, fy.y));
                  float n01 = dot(g01, float2(fx.z, fy.z));
                  float n11 = dot(g11, float2(fx.w, fy.w));
 
                  float2 fade_xy = fade(Pf.xy);
                  float2 n_x = lerp(float2(n00, n01), float2(n10, n11), fade_xy.x);
                  float n_xy = lerp(n_x.x, n_x.y, fade_xy.y);
                  return 2 * n_xy;
            }

         	// source: https://thebookofshaders.com/13/
         	float fbm (float2 st) {
         		float value = 0.0;
         		float amplitude = 0.5;
         		float frequency = 0.0;

         		for (int i = 0; i < 6; i++) {
         			value += amplitude * PerlinNoise2D(st);
         			st = mul(st, 2.0);
         			amplitude *= .5;
         		}

         		return value;
         	}

         	// source: www.iquilezles.org/www/articles/warp/warp.htm
         	float pattern(float2 p) {

         		float2 q = float2(fbm(p + float2(0.0, 0.0)),
         					      fbm(p + float2(5.2, 1.3)));

         		float2 r = float2(fbm(p + 4.0 * q + float2(1.7, 9.2)),
         						  fbm(p + 4.0 * q + float2(8.3, 2.8)));

         		return fbm(p + 4.0 * r);

         	}

            fixed4 frag (v2f_img i) : SV_Target {
	
                i.uv *= _GridSize;
                i.uv += float2(_X, _Y);
                // float ns = PerlinNoise2D(i.uv) / 2 + 0.5f;
                // pulse: float ns = sin(_Time * 10) * pattern(i.uv) / 2 + 0.5f;
                float ns = pattern(i.uv * _Time.x ) * 2 + .35;
                return float4(ns * _Color.x, ns * _Color.y, ns * _Color.z, ns * _Transparency);

            }
            ENDCG
        }
    }
}