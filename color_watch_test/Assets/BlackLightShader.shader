Shader "Unlit/BlackLight"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("Texture", 2D) = "white" {} //�x�[�X�e�N�X�`��
        _Center("Center",Vector) = (0,0,0,0) //���S���W
        _Radius("Radius",float) = 10 //���̕����̔��a
        _Height("Height",float) = 100 //���̕���+�~�������̍���
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" } //�����_�����O�^�C�v = �s����(������Transparent�ŃK���X�Ƃ��Ɏg��)

            Pass
            {
                CGPROGRAM

                #pragma vertex vert
                #pragma fragment frag

                #include "UnityCG.cginc" //�����܂Ő錾

                float _Radius; //�v���p�e�B����ݒ肳�ꂽ����ێ����邽�߂Ɏg�p
                float4 _Center;
                float _Height;

                sampler2D _MainTex; //�v���p�e�B�Œ�`���ꂽ���C���e�N�X�`�����i�[����ϐ�

            struct appdata //���_�����i�[����\���̂̐錾
            {
                float4 vertex : POSITION; //���_��3D���W���
                float2 uv : TEXCOORD0; //�e�N�X�`����UV���W���(�e�N�X�`���̍��W�ϊ��Ɏg�p)
            };

            struct v2f //���_�V�F�[�_�[����t���O�����g�V�F�[�_�[�ւ̃f�[�^�n��
            {
                float4 pos : SV_POSITION; //���_�̃X�N���[�����W
                float3 worldPos : TEXCOORD1; //���_�̖@���x�N�g�������[���h��Ԃɕϊ�
                float2 uv : TEXCOORD0; //�e�N�X�`����UV���W���
            };

            v2f vert (appdata v) //���_�V�F�[�_�[�֐��̐錾(appdata�\���̂��󂯎��Av2f�\���̂�Ԃ�)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex); //���_�ʒu���N���b�v��Ԃɕϊ�(���N���b�v���:�ŏI�I�ɃX�N���[����łǂ̈ʒu�ɕ`�悳��邩���肳���)
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz; //���̔��˂�A�e�̌v�Z�Ɏg�p�����(?)
                o.uv = v.uv; //�e�N�X�`�����I�u�W�F�N�g�ɐ������}�b�s���O������
                return o;
            }

            fixed4 frag (v2f i) : SV_Target //�t���O�����g�V�F�[�_�[�֐��̐錾(v2f�\���̂��󂯎��Afixed4�^��Ԃ�)
            {
                fixed4 col = tex2D(_MainTex, i.uv); //���C���e�N�X�`������F���T���v�����O(_MainTex����w�肵��UV���Wi.uv�ɑΉ�����F�����擾)
                float distSquared = pow(i.worldPos.x - _Center.x, 0) + pow(i.worldPos.y - _Center.y, 2) + pow(i.worldPos.z - _Center.z, 2) //pow()�͒������Ȑ��ɕϊ�����Ƃ��Ɏg��
                float v = distSquared <= pow(_Radius, 2) ? 1 : -1;
                clip(v);

                return col;
            }
            ENDCG
        }
    }
}
