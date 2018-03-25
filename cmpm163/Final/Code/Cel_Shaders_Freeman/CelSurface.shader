Shader "Custom/CelSurface" {

	Properties {

		_Color ( "Color", Color ) = ( 1, 1, 1, 1 )
		_MainTex ( "Albedo (RGB)", 2D ) = "white" {}
		//_Glossiness ( "Smoothness", Range( 0, 1 ) ) = 0.5
		//_Metallic ( "Metallic", Range( 0, 1 ) ) = 0.0

		_Bands ( "Bands", Range( 0, 15 ) ) = 5

	}
	SubShader {

		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		
		#include "UnityCG.cginc"
		
		#pragma surface surf SimpleLambert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float3 viewDir;
		};

		float _Bands;

		//half _Glossiness;
		//half _Metallic;
		fixed4 _Color;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
		// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutput o) {

			//fixed4 texColor = tex2D ( _MainTex, IN.uv_MainTex );
			o.Albedo = _Color;

			// Metallic and smoothness come from slider variables
			//o.Metallic = _Metallic;
			//o.Smoothness = _Glossiness;
			//o.Alpha = 1;

		}

		half4 LightingSimpleLambert( SurfaceOutput s, half3 lightDir, half atten ) {

			half dotNL = dot( s.Normal, lightDir );

			//half lightIntensity = 0;
			//if ( dotNL < 0.5 ) {
			//	lightIntensity = 0.5;
			//}
			//else {
			//	lightIntensity = 1;
			//}

			// Sequential codes are much faster than branch codes in GPU.

			//half cel = floor( dotNL * dotNL * _Bands ) / ( _Bands - 0.5 ); // I need a way to reduce this multiplicand.

			//half cel = ( step( 0.2, dotNL ) + step( 0.4, dotNL ) + step( 0.6, dotNL ) + step( 0.8, dotNL ) ) / 5;
			
			half cel = ( step( 0.2, dotNL ) + step( 0.5, dotNL ) + step( 0.8, dotNL ) ) / 3.0;

			half4 c;

			c.rgb = s.Albedo * _LightColor0.rgb * cel * atten * 1;
			c.a = s.Alpha;

			return c;

		}

		ENDCG

	}

	FallBack "Diffuse"

}
