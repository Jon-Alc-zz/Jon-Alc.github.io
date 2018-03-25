Shader "Custom/CombinedUnlit"
{

	Properties {

		_Color ( "Color", Color ) = ( 1.0, 1.0, 1.0, 1.0 )
		
		_MainTex ( "Texture", 2D ) = "white" {}
		
		_OutlineThickness ( "Outline Thickness", float ) = 0.0
		_OutlineColor ( "Outline Color", Vector ) = ( 0.0, 0.0, 0.0, 0.0 )

		_Light1_Pos ( "Light1 Position", Vector ) = ( 0.0, 0.0, 0.0 )

	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass {
			
			Tags {
				
				//"LightMode" = "ForwardBase" // Allow shadow rec/cast.
				
			}
			
			// Write to stencil buffer, so the outline pass can read.
			Stencil {
				
				Ref 4
				Comp always
				Pass replace
				ZFail keep
				
			}
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#pragma multi_compile_fog // make fog work
			
			//#pragma multi_compile_fwdbase // Shadow
			
			#include "AutoLight.cginc"
			#include "UnityCG.cginc"

			struct appdata {

				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;

				float3 normal: NORMAL;

			};

			struct v2f {

				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;

				float3 normal : NORMAL;
				float3 lightDir: TEXCOORD1;

			};

			float4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;

			uniform float3 _Light1_Pos;
			
			v2f vert (appdata v) {

				// Default codes.
				v2f o;

				o.vertex = UnityObjectToClipPos( v.vertex );
				o.uv = TRANSFORM_TEX( v.uv, _MainTex );
				UNITY_TRANSFER_FOG( o, o.vertex );

				o.normal = v.normal;
				o.lightDir = normalize( ObjSpaceLightDir( v.vertex ) );

				return o;

			}
			
			float4 frag (v2f i) : SV_Target {

				float4 texColor = tex2D( _MainTex, i.uv );

				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);

				// Lighting

				float dotNL = dot( i.normal, i.lightDir );

				float4 lightColor = float4( 1.0, 1.0, 1.0, 1.0 );

				float cel = ( step( 0.2, dotNL ) + step( 0.5, dotNL ) + step( 0.8, dotNL ) ) / 3.0;

				// CONTINUE HERE: How to deal with the face away from the light, and why multiply?

				float4 color = _Color * lightColor * cel;

				return color;

			}

			ENDCG
		}
		
		Pass {
			
			// Don't draw where it's ref 4.
			Cull OFF
			ZWrite OFF
			ZTest ON
			Stencil {
				
				Ref 4
				Comp notequal
				Fail keep
				Pass replace
				
			}
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			uniform float _OutlineThickness;
			uniform float4 _OutlineColor;
			
			struct vertexInput {
				
				float4 vertex: POSITION;
				float3 normal: NORMAL;
				
			};
			
			struct vertexOutput {
				
				float4 pos: SV_POSITION;
				float4 color: COLOR;
				
			};
			
			
			vertexOutput vert( vertexInput input ) {
				
				vertexOutput output;
				
				float4 newPos = input.vertex + float4( input.normal, 0.0 ) * _OutlineThickness;
				
				output.pos = UnityObjectToClipPos( newPos );
				
				output.color = _OutlineColor;
				
				return output;
				
			}
			
			float4 frag( vertexOutput input ) : COLOR {
				
				return input.color;
				
			}
			
			ENDCG
			
		}

	}

}
