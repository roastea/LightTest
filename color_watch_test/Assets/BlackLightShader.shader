Shader "Unlit/BlackLight"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("Texture", 2D) = "white" {} //ベーステクスチャ
        _Center("Center",Vector) = (0,0,0,0) //中心座標
        _Radius("Radius",float) = 10 //球体部分の半径
        _Height("Height",float) = 100 //球体部分+円柱部分の高さ
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" } //レンダリングタイプ = 不透明(透明はTransparentでガラスとかに使う)

            Pass
            {
                CGPROGRAM

                #pragma vertex vert
                #pragma fragment frag

                #include "UnityCG.cginc" //ここまで宣言

                float _Radius; //プロパティから設定された情報を保持するために使用
                float4 _Center;
                float _Height;

                sampler2D _MainTex; //プロパティで定義されたメインテクスチャを格納する変数

            struct appdata //頂点情報を格納する構造体の宣言
            {
                float4 vertex : POSITION; //頂点の3D座標情報
                float2 uv : TEXCOORD0; //テクスチャのUV座標情報(テクスチャの座標変換に使用)
            };

            struct v2f //頂点シェーダーからフラグメントシェーダーへのデータ渡し
            {
                float4 pos : SV_POSITION; //頂点のスクリーン座標
                float3 worldPos : TEXCOORD1; //頂点の法線ベクトルをワールド空間に変換
                float2 uv : TEXCOORD0; //テクスチャのUV座標情報
            };

            v2f vert (appdata v) //頂点シェーダー関数の宣言(appdata構造体を受け取り、v2f構造体を返す)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex); //頂点位置をクリップ空間に変換(※クリップ空間:最終的にスクリーン上でどの位置に描画されるか決定される)
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz; //光の反射や陰影の計算に使用される(?)
                o.uv = v.uv; //テクスチャをオブジェクトに正しくマッピングさせる
                return o;
            }

            fixed4 frag (v2f i) : SV_Target //フラグメントシェーダー関数の宣言(v2f構造体を受け取り、fixed4型を返す)
            {
                fixed4 col = tex2D(_MainTex, i.uv); //メインテクスチャから色をサンプリング(_MainTexから指定したUV座標i.uvに対応する色情報を取得)
                float distSquared = pow(i.worldPos.x - _Center.x, 0) + pow(i.worldPos.y - _Center.y, 2) + pow(i.worldPos.z - _Center.z, 2) //pow()は直線を曲線に変換するときに使う
                float v = distSquared <= pow(_Radius, 2) ? 1 : -1;
                clip(v);

                return col;
            }
            ENDCG
        }
    }
}
