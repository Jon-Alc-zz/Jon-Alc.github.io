Shader "Hidden/OutlineImageEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;

			float4 frag( v2f_img i ) : COLOR {

				float4 oldColor = tex2D( _MainTex, i.uv );
				float4 newColor = float4( 0.0, 0.0, 0.0, 1.0 );

				// Edge detection kernel //

				// Get neighbors' colors.
				
				float4  upperLeftColor = tex2D( _MainTex, float2( i.uv.x - 1.0 / _ScreenParams.x, i.uv.y + 1.0 / _ScreenParams.y ) );
				float4      upperColor = tex2D( _MainTex, float2( i.uv.x                        , i.uv.y + 1.0 / _ScreenParams.y ) );
				float4 upperRightColor = tex2D( _MainTex, float2( i.uv.x + 1.0 / _ScreenParams.x, i.uv.y + 1.0 / _ScreenParams.y ) );
				float4       leftColor = tex2D( _MainTex, float2( i.uv.x - 1.0 / _ScreenParams.x, i.uv.y                         ) );
				float4      rightColor = tex2D( _MainTex, float2( i.uv.x + 1.0 / _ScreenParams.x, i.uv.y                         ) );
				float4  lowerLeftColor = tex2D( _MainTex, float2( i.uv.x - 1.0 / _ScreenParams.x, i.uv.y - 1.0 / _ScreenParams.y ) );
				float4      lowerColor = tex2D( _MainTex, float2( i.uv.x                        , i.uv.y - 1.0 / _ScreenParams.y ) );
				float4 lowerRightColor = tex2D( _MainTex, float2( i.uv.x + 1.0 / _ScreenParams.x, i.uv.y - 1.0 / _ScreenParams.y ) );
				
				if ( i.uv.x <= 1.0 / _ScreenParams.x ) { leftColor = oldColor; }
				if ( i.uv.x >= _ScreenParams.x - 1.0 / _ScreenParams.x ) { rightColor = oldColor; }
				if ( i.uv.y <= 1.0 / _ScreenParams.y ) { lowerColor = oldColor; }
				if ( i.uv.y >= _ScreenParams.y - 1.0 / _ScreenParams.y ) { upperColor = oldColor; }

				// Edge detection kernel
				newColor = - upperLeftColor - upperColor - upperRightColor - leftColor - rightColor - lowerLeftColor - lowerColor - lowerRightColor;
				newColor += oldColor * 8.0;
				
				//newColor = upperLeftColor + lowerRightColor - upperRightColor - lowerLeftColor;

				// Box blur kernel
				//newColor = upperLeftColor + upperColor + upperRightColor + leftColor + rightColor + lowerLeftColor + lowerColor + lowerRightColor;
				//newColor += oldColor;
				//newColor /= 9.0;

				return oldColor + newColor;

			}

			ENDCG
		}
	}
}
