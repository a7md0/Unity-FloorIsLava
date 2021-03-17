Shader "Custom/Lava/DiffuseLavaOpaque"
{
	Properties
	{
		_LavaColor ("Lava color", Color) = (1, 1, 1, 1)
		_LavaTex ("Lava texture", 2D) = "white" {}
		_Tiling ("Lava tiling", Vector) = (1, 1, 1, 1)
		_TextureVisibility("Texture visibility", Range(0, 1)) = 1

		[Space(20)]
		_DistTex ("Distortion", 2D) = "white" {}
		_DistTiling ("Distortion tiling", Vector) = (1, 1, 1, 1)

		[Space(20)]
		_LavaHeight ("Lava height", Float) = 0

		[Space(20)]
		_MoveDirection ("Direction", Vector) = (0, 0, 0, 0)
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#pragma multi_compile_fog
			#pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				fixed4 worldPos: TEXCOORD1;
				fixed camHeightOverLava : TEXCOORD2;
				UNITY_FOG_COORDS(3)
				float4 vertex : SV_POSITION;
			};

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;

			sampler2D _LavaTex;
			fixed2 _Tiling;
			fixed4 _LavaColor;

			sampler2D _DistTex;
			fixed2 _DistTiling;

			fixed _LavaHeight;
			fixed _TextureVisibility;

			fixed3 _MoveDirection;

			fixed2 LavaPlaneUV(fixed3 worldPos, fixed camHeightOverLava)
			{
				fixed3 camToWorldRay = worldPos - _WorldSpaceCameraPos;
				fixed3 rayToLavaPlane = (camHeightOverLava / camToWorldRay.y * camToWorldRay);
				return rayToLavaPlane.xz - _WorldSpaceCameraPos.xz;
			}

			v2f vert (appdata v)
			{
				v2f o;

				o.worldPos = mul(UNITY_MATRIX_M, v.vertex);
				o.vertex = mul(UNITY_MATRIX_VP, o.worldPos);
				
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.camHeightOverLava = _WorldSpaceCameraPos.y - _LavaHeight;

#if defined(FOG_LINEAR) || defined(FOG_EXP) || defined(FOG_EXP2)
				fixed3 camToWorldRay = o.worldPos - _WorldSpaceCameraPos;
				fixed3 rayToLavaPlane = (o.camHeightOverLava / camToWorldRay.y * camToWorldRay);

				fixed3 worldPosOnPlane = _WorldSpaceCameraPos - rayToLavaPlane;
				fixed3 positionForFog = lerp(worldPosOnPlane, o.worldPos.xyz, o.worldPos.y > _LavaHeight);
				fixed4 LavaVertex = mul(UNITY_MATRIX_VP, fixed4(positionForFog, 1));
				UNITY_TRANSFER_FOG(o, LavaVertex);
#endif

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed2 Lava_uv = LavaPlaneUV(i.worldPos, i.camHeightOverLava);
				fixed4 distortion = tex2D(_DistTex, Lava_uv * _DistTiling) * 2 - 1;
				fixed2 distorted_uv = ((Lava_uv + distortion.rg) - _Time.y * _MoveDirection.xz) * _Tiling;

				fixed4 LavaCol = tex2D(_LavaTex, distorted_uv);
				LavaCol = lerp(_LavaColor, fixed4(1, 1, 1, 1), LavaCol.r * _TextureVisibility);

				UNITY_APPLY_FOG(i.fogCoord, LavaCol);

				return LavaCol;
			}
			ENDCG
		}
	}
}
