// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/Geometric_Wata" {

	Properties{

		_MainTex("Base (RGB)", 2D) = "white" {}
		_FlowMap("Flow Map", 2D) = "grey" {}
		_Speed("Speed", Range(-1, 1)) = 0.2

	}

		SubShader{

			Pass{
				Tags{ "RenderType" = "Opaque" }

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

			struct v2f {
				float4 pos : SV_POSITION;
				fixed2 uv : TEXCOORD0;
			};

			sampler2D _MainTex;
			sampler2D _FlowMap;
			fixed _Speed;

			fixed4 _MainTex_ST;

			v2f vert(appdata_base IN) {
				v2f o;
				o.pos = UnityObjectToClipPos(IN.vertex);
				o.uv = TRANSFORM_TEX(IN.texcoord, _MainTex);
				return o;
			}

			float4 frag(v2f v) : COLOR{

				float4 wata;
				float2 flowMap = (tex2D(_FlowMap, v.uv) * 3 - 1.5) * _Speed;
		
				float4 offSet1 = frac(_Time.y * 0.25 + 0.5);
				float4 offSet2 = frac(_Time.y * 0.25);

				half4 lerpScale = abs((0.5 - offSet1) / 0.5);
				//float4 lerpScale2 = dif2 * 1.5;

				half4 normal1 = tex2D(_MainTex, v.uv - flowMap.xy * offSet1);
				half4 normal2 = tex2D(_MainTex, v.uv * flowMap.xy * offSet2);

				wata = lerp(normal1, normal2, lerpScale);
				//d = lerp(c, col2, L)
				return wata;
			}

			ENDCG
			}
		}
		FallBack "Diffuse"
}