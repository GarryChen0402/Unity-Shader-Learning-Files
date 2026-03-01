Shader "Unlit/FirstShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        // 为参数在Unity窗口中标记名称
        [Header(Color)]
        // _Red("Red", float) = 1
        _Red("Red", Range(0, 1)) = 1
        _Green("Greed", Range(0, 1)) = 1
        _Yellow("Yellow", Range(0, 1)) = 1
        _Alpha("Alpha", Range(0, 1)) = 1
        [Header(Offset)]
        _Offset("Offset", float) = 0
    }
    SubShader
    {
        // Tags { "RenderType"="Opaque" }
        Tags { 
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
        }
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            // 添加自己的cginc文件
            #include "MyInc.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            // 添加自己的struct
            struct MyAppdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            // 添加变量 Red
            float _Red;
            float _Green;
            float _Yellow;
            float _Alpha;
            float _Offset;

            v2f vert (MyAppdata v)
            {
                v2f o;
                // o.vertex = UnityObjectToClipPos(v.vertex);
                // o.vertex = UnityObjectToClipPos(v.vertex + float3(0, 1, 0));
                o.vertex = UnityObjectToClipPos(v.vertex + float3(0, _Offset, 0));
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                // fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 col = fixed4(_Red, _Green, _Yellow, _Alpha);
                col = OnlyRedAlpha(col);
                // 尝试将颜色与坐标进行联系， 
                col = col * sin(i.vertex.x);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                // return col;
                // return half4(1, 0, 0, 1); // 控制材质要显示的颜色 RGBA 
                // return half4(_Red, 0, 0, 1); // 控制材质要显示的颜色 RGBA , 通过修改参数
                // return half4(_Red, _Green, _Yellow, 1); // 控制材质要显示的颜色 RGBA , 通过修改参数 v2
                // return half4(_Red, _Green, _Yellow, _Alpha); // 控制材质要显示的颜色 RGBA , 通过修改参数 v3, 添加透明度
                return col; // 控制材质要显示的颜色 RGBA , 通过修改参数 v3, 添加透明度
            }
            ENDCG
        }
    }
}
