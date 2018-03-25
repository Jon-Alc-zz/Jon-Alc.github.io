// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/Paper_Wata" {

	Properties {

		_MainTex("Base (RGB)", 2D) = "white" {}
		_FlowMap("Flow Map", 2D) = "grey" {}
		_Speed("Speed", Range(-1, 1)) = 0.5

	}

		SubShader {

			Pass {

				Tags { 

					"RenderType" = "Opaque" 
				}

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

			struct v2f {

				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;

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

			fixed4 frag(v2f v) : COLOR{

				float4 wata, wata_2;

				half3 flowVal = (tex2D(_FlowMap, v.uv) * 2 - 1) * _Speed;

				float offset1 = frac(_Time.y * 0.25 + 0.5);
				float offset2 = frac(_Time.y * 0.05);

				float lerpScale = abs((0.5 - offset1)/0.5);
				float lerpScale2 = abs((3.5 - offset2)/0.5);

				half4 normal1 = tex2D(_MainTex, v.uv - flowVal.x * offset1);
				half4 normal2 = tex2D(_MainTex, v.uv - flowVal.y * offset2);

				wata = lerp(normal1, normal2, lerpScale);
				wata_2 = lerp(normal1, normal2, lerpScale2);
				return wata;

			}

			ENDCG

			}
		}
		FallBack "Diffuse"
}