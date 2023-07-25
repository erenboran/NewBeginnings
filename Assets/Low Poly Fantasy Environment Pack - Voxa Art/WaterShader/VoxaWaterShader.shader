Shader "Voxa Water Shader"
{
    Properties
    {
        _Depth("Depth", Float) = 0
        _Strength("Strength", Range(0, 2)) = 0
        _Deep_Water_Color("Deep Water Color", Color) = (0, 0.3905807, 1, 0.1960784)
        _Shadow_Water_Color("Shadow Water Color", Color) = (0, 0.9802122, 1, 0.1960784)
        _Highlight_Color("Highlight Color", Color) = (1, 1, 1, 0)
        _Highlight_Strength("Highlight Strength", Range(-1, 1)) = 0
        [Normal][NoScaleOffset]_Main_Normal("Main Normal", 2D) = "bump" {}
        _Main_Normal_Tile("Main Normal Tile", Vector) = (10, 10, 0, 0)
        _Main_Normal_Speed("Main Normal Speed", Range(0, 1)) = 0.01
        [Normal][NoScaleOffset]_Second_Normal("Second Normal", 2D) = "bump" {}
        _Second_Normal_Tile("Second Normal Tile", Vector) = (10, 10, 0, 0)
        _Second_Normal_Speed("Second Normal Speed", Range(0, 1)) = 0.01
        _Normal_Strength("Normal Strength", Range(0, 1)) = 0
        [NoScaleOffset]_Ripple_Texture_Ambient_Occlusion("Ripple Texture (Ambient Occlusion)", 2D) = "white" {}
        _Ripple_Tile("Ripple Tile", Vector) = (10, 10, 0, 0)
        _Ripple_Opacity("Ripple Opacity", Range(0, 1)) = 0
        _Ripple_Speed("Ripple Speed", Range(0, 5)) = 1
        _Wave_Strength("Wave Strength", Float) = 2
        _Smoothness("Smoothness", Range(0, 1)) = 0.5
        _Displacement("Displacement", Float) = 0.5
        _Metalic("Metalic", Range(0, 1)) = 0
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
        [HideInInspector]_BUILTIN_QueueOffset("Float", Float) = 0
        [HideInInspector]_BUILTIN_QueueControl("Float", Float) = -1
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Lit"
            "Queue"="Transparent"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalLitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile _ _LIGHT_LAYERS
        #pragma multi_compile _ DEBUG_DISPLAY
        #pragma multi_compile _ _LIGHT_COOKIES
        #pragma multi_compile _ _CLUSTERED_RENDERING
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float3 viewDirectionWS;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float3 interp4 : INTERP4;
             float2 interp5 : INTERP5;
             float2 interp6 : INTERP6;
             float3 interp7 : INTERP7;
             float4 interp8 : INTERP8;
             float4 interp9 : INTERP9;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.interp6.xy =  input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp7.xyz =  input.sh;
            #endif
            output.interp8.xyzw =  input.fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.interp9.xyzw =  input.shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.interp5.xy;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.interp6.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp7.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp8.xyzw;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.interp9.xyzw;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Depth;
        float _Strength;
        float4 _Deep_Water_Color;
        float4 _Shadow_Water_Color;
        float4 _Main_Normal_TexelSize;
        float4 _Second_Normal_TexelSize;
        float _Normal_Strength;
        float _Smoothness;
        float _Displacement;
        float _Wave_Strength;
        float2 _Main_Normal_Tile;
        float2 _Second_Normal_Tile;
        float4 _Highlight_Color;
        float _Highlight_Strength;
        float _Metalic;
        float _Ripple_Speed;
        float4 _Ripple_Texture_Ambient_Occlusion_TexelSize;
        float2 _Ripple_Tile;
        float _Ripple_Opacity;
        float _Main_Normal_Speed;
        float _Second_Normal_Speed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Normal);
        SAMPLER(sampler_Main_Normal);
        TEXTURE2D(_Second_Normal);
        SAMPLER(sampler_Second_Normal);
        TEXTURE2D(_Ripple_Texture_Ambient_Occlusion);
        SAMPLER(sampler_Ripple_Texture_Ambient_Occlusion);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1 = IN.ObjectSpacePosition[0];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_G_2 = IN.ObjectSpacePosition[1];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3 = IN.ObjectSpacePosition[2];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_A_4 = 0;
            float _Property_0357d5684c5741b98876c08275c12954_Out_0 = _Displacement;
            float _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 100, _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2);
            float2 _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2.xx), _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3);
            float _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0 = _Wave_Strength;
            float _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3, _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2);
            float _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2;
            Unity_Multiply_float_float(_Property_0357d5684c5741b98876c08275c12954_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2);
            float4 _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4;
            float3 _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            float2 _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6;
            Unity_Combine_float(_Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2, _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3, 0, _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4, _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5, _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6);
            description.Position = _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0 = _Shadow_Water_Color;
            float4 _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0 = _Deep_Water_Color;
            float _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1);
            float _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2;
            Unity_Multiply_float_float(_SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1, _ProjectionParams.z, _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2);
            float4 _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0 = IN.ScreenPosition;
            float _Split_64cd857bd1d64117a2a108ff88c0779c_R_1 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[0];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_G_2 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[1];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_B_3 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[2];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_A_4 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[3];
            float _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0 = _Depth;
            float _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2;
            Unity_Add_float(_Split_64cd857bd1d64117a2a108ff88c0779c_A_4, _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2);
            float _Subtract_1476eb191c244932ad0606241d596d33_Out_2;
            Unity_Subtract_float(_Multiply_983da0bb704c49f88acdd897af4e2942_Out_2, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2, _Subtract_1476eb191c244932ad0606241d596d33_Out_2);
            float _Property_b8a1367319b64842bc06551f0b38404a_Out_0 = _Strength;
            float _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2;
            Unity_Multiply_float_float(_Subtract_1476eb191c244932ad0606241d596d33_Out_2, _Property_b8a1367319b64842bc06551f0b38404a_Out_0, _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2);
            float _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3;
            Unity_Clamp_float(_Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2, 0, 1, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3);
            float4 _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3;
            Unity_Lerp_float4(_Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0, _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0, (_Clamp_b1c08e0420874f2387bc1673d1678257_Out_3.xxxx), _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3);
            UnityTexture2D _Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0 = UnityBuildTexture2DStructNoScale(_Main_Normal);
            float2 _Property_d1e6d170425c4c18856710c0538aa517_Out_0 = _Main_Normal_Tile;
            float _Divide_2732be57b2a549159a4dabc5f8f137c6_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 50, _Divide_2732be57b2a549159a4dabc5f8f137c6_Out_2);
            float2 _TilingAndOffset_a27ba90f79b3460abf165145741ba6c0_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_d1e6d170425c4c18856710c0538aa517_Out_0, (_Divide_2732be57b2a549159a4dabc5f8f137c6_Out_2.xx), _TilingAndOffset_a27ba90f79b3460abf165145741ba6c0_Out_3);
            float _Property_5c1fb20a3d6b4d3eaafd354baadf9609_Out_0 = _Main_Normal_Speed;
            float _Multiply_b74cc2e778c145c3a7401ac4cd2a4b0b_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_5c1fb20a3d6b4d3eaafd354baadf9609_Out_0, _Multiply_b74cc2e778c145c3a7401ac4cd2a4b0b_Out_2);
            float _Voronoi_467777a2abfd4ce1967536f9e44c2276_Out_3;
            float _Voronoi_467777a2abfd4ce1967536f9e44c2276_Cells_4;
            Unity_Voronoi_float((_Multiply_b74cc2e778c145c3a7401ac4cd2a4b0b_Out_2.xx), 0.1, 0.01, _Voronoi_467777a2abfd4ce1967536f9e44c2276_Out_3, _Voronoi_467777a2abfd4ce1967536f9e44c2276_Cells_4);
            float2 _Multiply_fa06a662967144269ae74ba3b4b6825c_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_a27ba90f79b3460abf165145741ba6c0_Out_3, (_Voronoi_467777a2abfd4ce1967536f9e44c2276_Out_3.xx), _Multiply_fa06a662967144269ae74ba3b4b6825c_Out_2);
            float4 _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0 = SAMPLE_TEXTURE2D(_Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0.tex, _Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0.samplerstate, _Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0.GetTransformedUV(_Multiply_fa06a662967144269ae74ba3b4b6825c_Out_2));
            _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0);
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_R_4 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.r;
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_G_5 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.g;
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_B_6 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.b;
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_A_7 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.a;
            UnityTexture2D _Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0 = UnityBuildTexture2DStructNoScale(_Second_Normal);
            float2 _Property_f994634ef25f46e0bbb7777c3dadb5a6_Out_0 = _Second_Normal_Tile;
            float _Divide_2024d2b7d7094075bb3feaa67982fcb2_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, -25, _Divide_2024d2b7d7094075bb3feaa67982fcb2_Out_2);
            float2 _TilingAndOffset_75a104fa5a5149a5b946df7fd1f3f8b6_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_f994634ef25f46e0bbb7777c3dadb5a6_Out_0, (_Divide_2024d2b7d7094075bb3feaa67982fcb2_Out_2.xx), _TilingAndOffset_75a104fa5a5149a5b946df7fd1f3f8b6_Out_3);
            float _Property_9b1f2a6be1a34f95bcb01a67c24c7fd7_Out_0 = _Second_Normal_Speed;
            float _Multiply_0f59000213ec4c6683ebe88920280f10_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9b1f2a6be1a34f95bcb01a67c24c7fd7_Out_0, _Multiply_0f59000213ec4c6683ebe88920280f10_Out_2);
            float _Voronoi_3738394378e24709a5873a6606cc6f3e_Out_3;
            float _Voronoi_3738394378e24709a5873a6606cc6f3e_Cells_4;
            Unity_Voronoi_float((_Multiply_0f59000213ec4c6683ebe88920280f10_Out_2.xx), 0.1, 0.01, _Voronoi_3738394378e24709a5873a6606cc6f3e_Out_3, _Voronoi_3738394378e24709a5873a6606cc6f3e_Cells_4);
            float2 _Multiply_5653e08b7cdb40dfa0fd755420c69c82_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_75a104fa5a5149a5b946df7fd1f3f8b6_Out_3, (_Voronoi_3738394378e24709a5873a6606cc6f3e_Out_3.xx), _Multiply_5653e08b7cdb40dfa0fd755420c69c82_Out_2);
            float4 _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0 = SAMPLE_TEXTURE2D(_Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0.tex, _Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0.samplerstate, _Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0.GetTransformedUV(_Multiply_5653e08b7cdb40dfa0fd755420c69c82_Out_2));
            _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0);
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_R_4 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.r;
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_G_5 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.g;
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_B_6 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.b;
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_A_7 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.a;
            float4 _Add_1167af1105f042b29ed2f1c382322709_Out_2;
            Unity_Add_float4(_SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0, _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0, _Add_1167af1105f042b29ed2f1c382322709_Out_2);
            float _Property_faf0138af8284ee18af730107ac28d91_Out_0 = _Normal_Strength;
            float _Lerp_e9f5f2254c63485bbf60161c27089f6c_Out_3;
            Unity_Lerp_float(0, _Property_faf0138af8284ee18af730107ac28d91_Out_0, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3, _Lerp_e9f5f2254c63485bbf60161c27089f6c_Out_3);
            float3 _NormalStrength_35691fd6222d4f3797055369fd967340_Out_2;
            Unity_NormalStrength_float((_Add_1167af1105f042b29ed2f1c382322709_Out_2.xyz), _Lerp_e9f5f2254c63485bbf60161c27089f6c_Out_3, _NormalStrength_35691fd6222d4f3797055369fd967340_Out_2);
            float4 _Property_b89a6f497f904ecebcb204224f6204a3_Out_0 = _Highlight_Color;
            float _Property_1e0453f5ed0946b291991855928ab8c9_Out_0 = _Highlight_Strength;
            float4 _Multiply_4464f97133ef419683675ba4b5d96ce2_Out_2;
            Unity_Multiply_float4_float4(_Property_b89a6f497f904ecebcb204224f6204a3_Out_0, (_Property_1e0453f5ed0946b291991855928ab8c9_Out_0.xxxx), _Multiply_4464f97133ef419683675ba4b5d96ce2_Out_2);
            float _Property_de94933959de451bbb82517c41b560cb_Out_0 = _Metalic;
            float _Property_8a2c01afc51445358940fa27b5c1c89e_Out_0 = _Smoothness;
            UnityTexture2D _Property_dec3e33ded004516a5ad056133c1b58e_Out_0 = UnityBuildTexture2DStructNoScale(_Ripple_Texture_Ambient_Occlusion);
            float2 _Property_530b0cba26934bd18c92b77aa80c6286_Out_0 = _Ripple_Tile;
            float2 _TilingAndOffset_4fda776a90e24c17bc0209d30c2c0b3e_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_530b0cba26934bd18c92b77aa80c6286_Out_0, float2 (0, 0), _TilingAndOffset_4fda776a90e24c17bc0209d30c2c0b3e_Out_3);
            float _Property_8fc20fcbc2d949d8b175eecee5d0746a_Out_0 = _Ripple_Speed;
            float _Multiply_25046a0a489442a0bf3026055fa09c56_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_8fc20fcbc2d949d8b175eecee5d0746a_Out_0, _Multiply_25046a0a489442a0bf3026055fa09c56_Out_2);
            float _Voronoi_b7697bc2164a48b9a16ec45afa015839_Out_3;
            float _Voronoi_b7697bc2164a48b9a16ec45afa015839_Cells_4;
            Unity_Voronoi_float((_Multiply_25046a0a489442a0bf3026055fa09c56_Out_2.xx), 0.1, 0.01, _Voronoi_b7697bc2164a48b9a16ec45afa015839_Out_3, _Voronoi_b7697bc2164a48b9a16ec45afa015839_Cells_4);
            float2 _Multiply_076b83e253344a7386496a7cd0de2587_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_4fda776a90e24c17bc0209d30c2c0b3e_Out_3, (_Voronoi_b7697bc2164a48b9a16ec45afa015839_Out_3.xx), _Multiply_076b83e253344a7386496a7cd0de2587_Out_2);
            float4 _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0 = SAMPLE_TEXTURE2D(_Property_dec3e33ded004516a5ad056133c1b58e_Out_0.tex, _Property_dec3e33ded004516a5ad056133c1b58e_Out_0.samplerstate, _Property_dec3e33ded004516a5ad056133c1b58e_Out_0.GetTransformedUV(_Multiply_076b83e253344a7386496a7cd0de2587_Out_2));
            float _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_R_4 = _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0.r;
            float _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_G_5 = _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0.g;
            float _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_B_6 = _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0.b;
            float _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_A_7 = _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0.a;
            float _Property_ff001ec7d20c49c79f2f4b2d70794ef7_Out_0 = _Ripple_Opacity;
            float4 _Add_f8c7532823d74818bc903a41930674af_Out_2;
            Unity_Add_float4(_SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0, (_Property_ff001ec7d20c49c79f2f4b2d70794ef7_Out_0.xxxx), _Add_f8c7532823d74818bc903a41930674af_Out_2);
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_R_1 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[0];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_G_2 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[1];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_B_3 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[2];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[3];
            surface.BaseColor = (_Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3.xyz);
            surface.NormalTS = _NormalStrength_35691fd6222d4f3797055369fd967340_Out_2;
            surface.Emission = (_Multiply_4464f97133ef419683675ba4b5d96ce2_Out_2.xyz);
            surface.Metallic = _Property_de94933959de451bbb82517c41b560cb_Out_0;
            surface.Smoothness = _Property_8a2c01afc51445358940fa27b5c1c89e_Out_0;
            surface.Occlusion = (_Add_f8c7532823d74818bc903a41930674af_Out_2).x;
            surface.Alpha = _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile _ _GBUFFER_NORMALS_OCT
        #pragma multi_compile _ _LIGHT_LAYERS
        #pragma multi_compile _ _RENDER_PASS_ENABLED
        #pragma multi_compile _ DEBUG_DISPLAY
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_GBUFFER
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float3 viewDirectionWS;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float3 interp4 : INTERP4;
             float2 interp5 : INTERP5;
             float2 interp6 : INTERP6;
             float3 interp7 : INTERP7;
             float4 interp8 : INTERP8;
             float4 interp9 : INTERP9;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.interp6.xy =  input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp7.xyz =  input.sh;
            #endif
            output.interp8.xyzw =  input.fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.interp9.xyzw =  input.shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.interp5.xy;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.interp6.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp7.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp8.xyzw;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.interp9.xyzw;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Depth;
        float _Strength;
        float4 _Deep_Water_Color;
        float4 _Shadow_Water_Color;
        float4 _Main_Normal_TexelSize;
        float4 _Second_Normal_TexelSize;
        float _Normal_Strength;
        float _Smoothness;
        float _Displacement;
        float _Wave_Strength;
        float2 _Main_Normal_Tile;
        float2 _Second_Normal_Tile;
        float4 _Highlight_Color;
        float _Highlight_Strength;
        float _Metalic;
        float _Ripple_Speed;
        float4 _Ripple_Texture_Ambient_Occlusion_TexelSize;
        float2 _Ripple_Tile;
        float _Ripple_Opacity;
        float _Main_Normal_Speed;
        float _Second_Normal_Speed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Normal);
        SAMPLER(sampler_Main_Normal);
        TEXTURE2D(_Second_Normal);
        SAMPLER(sampler_Second_Normal);
        TEXTURE2D(_Ripple_Texture_Ambient_Occlusion);
        SAMPLER(sampler_Ripple_Texture_Ambient_Occlusion);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1 = IN.ObjectSpacePosition[0];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_G_2 = IN.ObjectSpacePosition[1];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3 = IN.ObjectSpacePosition[2];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_A_4 = 0;
            float _Property_0357d5684c5741b98876c08275c12954_Out_0 = _Displacement;
            float _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 100, _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2);
            float2 _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2.xx), _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3);
            float _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0 = _Wave_Strength;
            float _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3, _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2);
            float _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2;
            Unity_Multiply_float_float(_Property_0357d5684c5741b98876c08275c12954_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2);
            float4 _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4;
            float3 _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            float2 _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6;
            Unity_Combine_float(_Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2, _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3, 0, _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4, _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5, _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6);
            description.Position = _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0 = _Shadow_Water_Color;
            float4 _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0 = _Deep_Water_Color;
            float _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1);
            float _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2;
            Unity_Multiply_float_float(_SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1, _ProjectionParams.z, _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2);
            float4 _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0 = IN.ScreenPosition;
            float _Split_64cd857bd1d64117a2a108ff88c0779c_R_1 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[0];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_G_2 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[1];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_B_3 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[2];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_A_4 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[3];
            float _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0 = _Depth;
            float _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2;
            Unity_Add_float(_Split_64cd857bd1d64117a2a108ff88c0779c_A_4, _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2);
            float _Subtract_1476eb191c244932ad0606241d596d33_Out_2;
            Unity_Subtract_float(_Multiply_983da0bb704c49f88acdd897af4e2942_Out_2, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2, _Subtract_1476eb191c244932ad0606241d596d33_Out_2);
            float _Property_b8a1367319b64842bc06551f0b38404a_Out_0 = _Strength;
            float _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2;
            Unity_Multiply_float_float(_Subtract_1476eb191c244932ad0606241d596d33_Out_2, _Property_b8a1367319b64842bc06551f0b38404a_Out_0, _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2);
            float _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3;
            Unity_Clamp_float(_Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2, 0, 1, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3);
            float4 _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3;
            Unity_Lerp_float4(_Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0, _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0, (_Clamp_b1c08e0420874f2387bc1673d1678257_Out_3.xxxx), _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3);
            UnityTexture2D _Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0 = UnityBuildTexture2DStructNoScale(_Main_Normal);
            float2 _Property_d1e6d170425c4c18856710c0538aa517_Out_0 = _Main_Normal_Tile;
            float _Divide_2732be57b2a549159a4dabc5f8f137c6_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 50, _Divide_2732be57b2a549159a4dabc5f8f137c6_Out_2);
            float2 _TilingAndOffset_a27ba90f79b3460abf165145741ba6c0_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_d1e6d170425c4c18856710c0538aa517_Out_0, (_Divide_2732be57b2a549159a4dabc5f8f137c6_Out_2.xx), _TilingAndOffset_a27ba90f79b3460abf165145741ba6c0_Out_3);
            float _Property_5c1fb20a3d6b4d3eaafd354baadf9609_Out_0 = _Main_Normal_Speed;
            float _Multiply_b74cc2e778c145c3a7401ac4cd2a4b0b_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_5c1fb20a3d6b4d3eaafd354baadf9609_Out_0, _Multiply_b74cc2e778c145c3a7401ac4cd2a4b0b_Out_2);
            float _Voronoi_467777a2abfd4ce1967536f9e44c2276_Out_3;
            float _Voronoi_467777a2abfd4ce1967536f9e44c2276_Cells_4;
            Unity_Voronoi_float((_Multiply_b74cc2e778c145c3a7401ac4cd2a4b0b_Out_2.xx), 0.1, 0.01, _Voronoi_467777a2abfd4ce1967536f9e44c2276_Out_3, _Voronoi_467777a2abfd4ce1967536f9e44c2276_Cells_4);
            float2 _Multiply_fa06a662967144269ae74ba3b4b6825c_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_a27ba90f79b3460abf165145741ba6c0_Out_3, (_Voronoi_467777a2abfd4ce1967536f9e44c2276_Out_3.xx), _Multiply_fa06a662967144269ae74ba3b4b6825c_Out_2);
            float4 _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0 = SAMPLE_TEXTURE2D(_Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0.tex, _Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0.samplerstate, _Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0.GetTransformedUV(_Multiply_fa06a662967144269ae74ba3b4b6825c_Out_2));
            _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0);
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_R_4 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.r;
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_G_5 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.g;
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_B_6 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.b;
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_A_7 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.a;
            UnityTexture2D _Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0 = UnityBuildTexture2DStructNoScale(_Second_Normal);
            float2 _Property_f994634ef25f46e0bbb7777c3dadb5a6_Out_0 = _Second_Normal_Tile;
            float _Divide_2024d2b7d7094075bb3feaa67982fcb2_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, -25, _Divide_2024d2b7d7094075bb3feaa67982fcb2_Out_2);
            float2 _TilingAndOffset_75a104fa5a5149a5b946df7fd1f3f8b6_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_f994634ef25f46e0bbb7777c3dadb5a6_Out_0, (_Divide_2024d2b7d7094075bb3feaa67982fcb2_Out_2.xx), _TilingAndOffset_75a104fa5a5149a5b946df7fd1f3f8b6_Out_3);
            float _Property_9b1f2a6be1a34f95bcb01a67c24c7fd7_Out_0 = _Second_Normal_Speed;
            float _Multiply_0f59000213ec4c6683ebe88920280f10_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9b1f2a6be1a34f95bcb01a67c24c7fd7_Out_0, _Multiply_0f59000213ec4c6683ebe88920280f10_Out_2);
            float _Voronoi_3738394378e24709a5873a6606cc6f3e_Out_3;
            float _Voronoi_3738394378e24709a5873a6606cc6f3e_Cells_4;
            Unity_Voronoi_float((_Multiply_0f59000213ec4c6683ebe88920280f10_Out_2.xx), 0.1, 0.01, _Voronoi_3738394378e24709a5873a6606cc6f3e_Out_3, _Voronoi_3738394378e24709a5873a6606cc6f3e_Cells_4);
            float2 _Multiply_5653e08b7cdb40dfa0fd755420c69c82_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_75a104fa5a5149a5b946df7fd1f3f8b6_Out_3, (_Voronoi_3738394378e24709a5873a6606cc6f3e_Out_3.xx), _Multiply_5653e08b7cdb40dfa0fd755420c69c82_Out_2);
            float4 _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0 = SAMPLE_TEXTURE2D(_Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0.tex, _Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0.samplerstate, _Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0.GetTransformedUV(_Multiply_5653e08b7cdb40dfa0fd755420c69c82_Out_2));
            _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0);
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_R_4 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.r;
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_G_5 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.g;
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_B_6 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.b;
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_A_7 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.a;
            float4 _Add_1167af1105f042b29ed2f1c382322709_Out_2;
            Unity_Add_float4(_SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0, _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0, _Add_1167af1105f042b29ed2f1c382322709_Out_2);
            float _Property_faf0138af8284ee18af730107ac28d91_Out_0 = _Normal_Strength;
            float _Lerp_e9f5f2254c63485bbf60161c27089f6c_Out_3;
            Unity_Lerp_float(0, _Property_faf0138af8284ee18af730107ac28d91_Out_0, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3, _Lerp_e9f5f2254c63485bbf60161c27089f6c_Out_3);
            float3 _NormalStrength_35691fd6222d4f3797055369fd967340_Out_2;
            Unity_NormalStrength_float((_Add_1167af1105f042b29ed2f1c382322709_Out_2.xyz), _Lerp_e9f5f2254c63485bbf60161c27089f6c_Out_3, _NormalStrength_35691fd6222d4f3797055369fd967340_Out_2);
            float4 _Property_b89a6f497f904ecebcb204224f6204a3_Out_0 = _Highlight_Color;
            float _Property_1e0453f5ed0946b291991855928ab8c9_Out_0 = _Highlight_Strength;
            float4 _Multiply_4464f97133ef419683675ba4b5d96ce2_Out_2;
            Unity_Multiply_float4_float4(_Property_b89a6f497f904ecebcb204224f6204a3_Out_0, (_Property_1e0453f5ed0946b291991855928ab8c9_Out_0.xxxx), _Multiply_4464f97133ef419683675ba4b5d96ce2_Out_2);
            float _Property_de94933959de451bbb82517c41b560cb_Out_0 = _Metalic;
            float _Property_8a2c01afc51445358940fa27b5c1c89e_Out_0 = _Smoothness;
            UnityTexture2D _Property_dec3e33ded004516a5ad056133c1b58e_Out_0 = UnityBuildTexture2DStructNoScale(_Ripple_Texture_Ambient_Occlusion);
            float2 _Property_530b0cba26934bd18c92b77aa80c6286_Out_0 = _Ripple_Tile;
            float2 _TilingAndOffset_4fda776a90e24c17bc0209d30c2c0b3e_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_530b0cba26934bd18c92b77aa80c6286_Out_0, float2 (0, 0), _TilingAndOffset_4fda776a90e24c17bc0209d30c2c0b3e_Out_3);
            float _Property_8fc20fcbc2d949d8b175eecee5d0746a_Out_0 = _Ripple_Speed;
            float _Multiply_25046a0a489442a0bf3026055fa09c56_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_8fc20fcbc2d949d8b175eecee5d0746a_Out_0, _Multiply_25046a0a489442a0bf3026055fa09c56_Out_2);
            float _Voronoi_b7697bc2164a48b9a16ec45afa015839_Out_3;
            float _Voronoi_b7697bc2164a48b9a16ec45afa015839_Cells_4;
            Unity_Voronoi_float((_Multiply_25046a0a489442a0bf3026055fa09c56_Out_2.xx), 0.1, 0.01, _Voronoi_b7697bc2164a48b9a16ec45afa015839_Out_3, _Voronoi_b7697bc2164a48b9a16ec45afa015839_Cells_4);
            float2 _Multiply_076b83e253344a7386496a7cd0de2587_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_4fda776a90e24c17bc0209d30c2c0b3e_Out_3, (_Voronoi_b7697bc2164a48b9a16ec45afa015839_Out_3.xx), _Multiply_076b83e253344a7386496a7cd0de2587_Out_2);
            float4 _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0 = SAMPLE_TEXTURE2D(_Property_dec3e33ded004516a5ad056133c1b58e_Out_0.tex, _Property_dec3e33ded004516a5ad056133c1b58e_Out_0.samplerstate, _Property_dec3e33ded004516a5ad056133c1b58e_Out_0.GetTransformedUV(_Multiply_076b83e253344a7386496a7cd0de2587_Out_2));
            float _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_R_4 = _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0.r;
            float _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_G_5 = _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0.g;
            float _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_B_6 = _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0.b;
            float _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_A_7 = _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0.a;
            float _Property_ff001ec7d20c49c79f2f4b2d70794ef7_Out_0 = _Ripple_Opacity;
            float4 _Add_f8c7532823d74818bc903a41930674af_Out_2;
            Unity_Add_float4(_SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0, (_Property_ff001ec7d20c49c79f2f4b2d70794ef7_Out_0.xxxx), _Add_f8c7532823d74818bc903a41930674af_Out_2);
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_R_1 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[0];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_G_2 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[1];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_B_3 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[2];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[3];
            surface.BaseColor = (_Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3.xyz);
            surface.NormalTS = _NormalStrength_35691fd6222d4f3797055369fd967340_Out_2;
            surface.Emission = (_Multiply_4464f97133ef419683675ba4b5d96ce2_Out_2.xyz);
            surface.Metallic = _Property_de94933959de451bbb82517c41b560cb_Out_0;
            surface.Smoothness = _Property_8a2c01afc51445358940fa27b5c1c89e_Out_0;
            surface.Occlusion = (_Add_f8c7532823d74818bc903a41930674af_Out_2).x;
            surface.Alpha = _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Depth;
        float _Strength;
        float4 _Deep_Water_Color;
        float4 _Shadow_Water_Color;
        float4 _Main_Normal_TexelSize;
        float4 _Second_Normal_TexelSize;
        float _Normal_Strength;
        float _Smoothness;
        float _Displacement;
        float _Wave_Strength;
        float2 _Main_Normal_Tile;
        float2 _Second_Normal_Tile;
        float4 _Highlight_Color;
        float _Highlight_Strength;
        float _Metalic;
        float _Ripple_Speed;
        float4 _Ripple_Texture_Ambient_Occlusion_TexelSize;
        float2 _Ripple_Tile;
        float _Ripple_Opacity;
        float _Main_Normal_Speed;
        float _Second_Normal_Speed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Normal);
        SAMPLER(sampler_Main_Normal);
        TEXTURE2D(_Second_Normal);
        SAMPLER(sampler_Second_Normal);
        TEXTURE2D(_Ripple_Texture_Ambient_Occlusion);
        SAMPLER(sampler_Ripple_Texture_Ambient_Occlusion);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1 = IN.ObjectSpacePosition[0];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_G_2 = IN.ObjectSpacePosition[1];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3 = IN.ObjectSpacePosition[2];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_A_4 = 0;
            float _Property_0357d5684c5741b98876c08275c12954_Out_0 = _Displacement;
            float _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 100, _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2);
            float2 _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2.xx), _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3);
            float _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0 = _Wave_Strength;
            float _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3, _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2);
            float _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2;
            Unity_Multiply_float_float(_Property_0357d5684c5741b98876c08275c12954_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2);
            float4 _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4;
            float3 _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            float2 _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6;
            Unity_Combine_float(_Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2, _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3, 0, _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4, _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5, _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6);
            description.Position = _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0 = _Shadow_Water_Color;
            float4 _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0 = _Deep_Water_Color;
            float _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1);
            float _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2;
            Unity_Multiply_float_float(_SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1, _ProjectionParams.z, _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2);
            float4 _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0 = IN.ScreenPosition;
            float _Split_64cd857bd1d64117a2a108ff88c0779c_R_1 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[0];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_G_2 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[1];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_B_3 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[2];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_A_4 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[3];
            float _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0 = _Depth;
            float _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2;
            Unity_Add_float(_Split_64cd857bd1d64117a2a108ff88c0779c_A_4, _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2);
            float _Subtract_1476eb191c244932ad0606241d596d33_Out_2;
            Unity_Subtract_float(_Multiply_983da0bb704c49f88acdd897af4e2942_Out_2, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2, _Subtract_1476eb191c244932ad0606241d596d33_Out_2);
            float _Property_b8a1367319b64842bc06551f0b38404a_Out_0 = _Strength;
            float _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2;
            Unity_Multiply_float_float(_Subtract_1476eb191c244932ad0606241d596d33_Out_2, _Property_b8a1367319b64842bc06551f0b38404a_Out_0, _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2);
            float _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3;
            Unity_Clamp_float(_Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2, 0, 1, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3);
            float4 _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3;
            Unity_Lerp_float4(_Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0, _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0, (_Clamp_b1c08e0420874f2387bc1673d1678257_Out_3.xxxx), _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3);
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_R_1 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[0];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_G_2 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[1];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_B_3 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[2];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[3];
            surface.Alpha = _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALS
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Depth;
        float _Strength;
        float4 _Deep_Water_Color;
        float4 _Shadow_Water_Color;
        float4 _Main_Normal_TexelSize;
        float4 _Second_Normal_TexelSize;
        float _Normal_Strength;
        float _Smoothness;
        float _Displacement;
        float _Wave_Strength;
        float2 _Main_Normal_Tile;
        float2 _Second_Normal_Tile;
        float4 _Highlight_Color;
        float _Highlight_Strength;
        float _Metalic;
        float _Ripple_Speed;
        float4 _Ripple_Texture_Ambient_Occlusion_TexelSize;
        float2 _Ripple_Tile;
        float _Ripple_Opacity;
        float _Main_Normal_Speed;
        float _Second_Normal_Speed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Normal);
        SAMPLER(sampler_Main_Normal);
        TEXTURE2D(_Second_Normal);
        SAMPLER(sampler_Second_Normal);
        TEXTURE2D(_Ripple_Texture_Ambient_Occlusion);
        SAMPLER(sampler_Ripple_Texture_Ambient_Occlusion);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1 = IN.ObjectSpacePosition[0];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_G_2 = IN.ObjectSpacePosition[1];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3 = IN.ObjectSpacePosition[2];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_A_4 = 0;
            float _Property_0357d5684c5741b98876c08275c12954_Out_0 = _Displacement;
            float _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 100, _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2);
            float2 _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2.xx), _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3);
            float _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0 = _Wave_Strength;
            float _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3, _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2);
            float _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2;
            Unity_Multiply_float_float(_Property_0357d5684c5741b98876c08275c12954_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2);
            float4 _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4;
            float3 _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            float2 _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6;
            Unity_Combine_float(_Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2, _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3, 0, _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4, _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5, _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6);
            description.Position = _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 NormalTS;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0 = UnityBuildTexture2DStructNoScale(_Main_Normal);
            float2 _Property_d1e6d170425c4c18856710c0538aa517_Out_0 = _Main_Normal_Tile;
            float _Divide_2732be57b2a549159a4dabc5f8f137c6_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 50, _Divide_2732be57b2a549159a4dabc5f8f137c6_Out_2);
            float2 _TilingAndOffset_a27ba90f79b3460abf165145741ba6c0_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_d1e6d170425c4c18856710c0538aa517_Out_0, (_Divide_2732be57b2a549159a4dabc5f8f137c6_Out_2.xx), _TilingAndOffset_a27ba90f79b3460abf165145741ba6c0_Out_3);
            float _Property_5c1fb20a3d6b4d3eaafd354baadf9609_Out_0 = _Main_Normal_Speed;
            float _Multiply_b74cc2e778c145c3a7401ac4cd2a4b0b_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_5c1fb20a3d6b4d3eaafd354baadf9609_Out_0, _Multiply_b74cc2e778c145c3a7401ac4cd2a4b0b_Out_2);
            float _Voronoi_467777a2abfd4ce1967536f9e44c2276_Out_3;
            float _Voronoi_467777a2abfd4ce1967536f9e44c2276_Cells_4;
            Unity_Voronoi_float((_Multiply_b74cc2e778c145c3a7401ac4cd2a4b0b_Out_2.xx), 0.1, 0.01, _Voronoi_467777a2abfd4ce1967536f9e44c2276_Out_3, _Voronoi_467777a2abfd4ce1967536f9e44c2276_Cells_4);
            float2 _Multiply_fa06a662967144269ae74ba3b4b6825c_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_a27ba90f79b3460abf165145741ba6c0_Out_3, (_Voronoi_467777a2abfd4ce1967536f9e44c2276_Out_3.xx), _Multiply_fa06a662967144269ae74ba3b4b6825c_Out_2);
            float4 _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0 = SAMPLE_TEXTURE2D(_Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0.tex, _Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0.samplerstate, _Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0.GetTransformedUV(_Multiply_fa06a662967144269ae74ba3b4b6825c_Out_2));
            _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0);
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_R_4 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.r;
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_G_5 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.g;
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_B_6 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.b;
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_A_7 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.a;
            UnityTexture2D _Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0 = UnityBuildTexture2DStructNoScale(_Second_Normal);
            float2 _Property_f994634ef25f46e0bbb7777c3dadb5a6_Out_0 = _Second_Normal_Tile;
            float _Divide_2024d2b7d7094075bb3feaa67982fcb2_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, -25, _Divide_2024d2b7d7094075bb3feaa67982fcb2_Out_2);
            float2 _TilingAndOffset_75a104fa5a5149a5b946df7fd1f3f8b6_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_f994634ef25f46e0bbb7777c3dadb5a6_Out_0, (_Divide_2024d2b7d7094075bb3feaa67982fcb2_Out_2.xx), _TilingAndOffset_75a104fa5a5149a5b946df7fd1f3f8b6_Out_3);
            float _Property_9b1f2a6be1a34f95bcb01a67c24c7fd7_Out_0 = _Second_Normal_Speed;
            float _Multiply_0f59000213ec4c6683ebe88920280f10_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9b1f2a6be1a34f95bcb01a67c24c7fd7_Out_0, _Multiply_0f59000213ec4c6683ebe88920280f10_Out_2);
            float _Voronoi_3738394378e24709a5873a6606cc6f3e_Out_3;
            float _Voronoi_3738394378e24709a5873a6606cc6f3e_Cells_4;
            Unity_Voronoi_float((_Multiply_0f59000213ec4c6683ebe88920280f10_Out_2.xx), 0.1, 0.01, _Voronoi_3738394378e24709a5873a6606cc6f3e_Out_3, _Voronoi_3738394378e24709a5873a6606cc6f3e_Cells_4);
            float2 _Multiply_5653e08b7cdb40dfa0fd755420c69c82_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_75a104fa5a5149a5b946df7fd1f3f8b6_Out_3, (_Voronoi_3738394378e24709a5873a6606cc6f3e_Out_3.xx), _Multiply_5653e08b7cdb40dfa0fd755420c69c82_Out_2);
            float4 _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0 = SAMPLE_TEXTURE2D(_Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0.tex, _Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0.samplerstate, _Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0.GetTransformedUV(_Multiply_5653e08b7cdb40dfa0fd755420c69c82_Out_2));
            _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0);
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_R_4 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.r;
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_G_5 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.g;
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_B_6 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.b;
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_A_7 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.a;
            float4 _Add_1167af1105f042b29ed2f1c382322709_Out_2;
            Unity_Add_float4(_SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0, _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0, _Add_1167af1105f042b29ed2f1c382322709_Out_2);
            float _Property_faf0138af8284ee18af730107ac28d91_Out_0 = _Normal_Strength;
            float _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1);
            float _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2;
            Unity_Multiply_float_float(_SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1, _ProjectionParams.z, _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2);
            float4 _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0 = IN.ScreenPosition;
            float _Split_64cd857bd1d64117a2a108ff88c0779c_R_1 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[0];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_G_2 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[1];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_B_3 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[2];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_A_4 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[3];
            float _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0 = _Depth;
            float _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2;
            Unity_Add_float(_Split_64cd857bd1d64117a2a108ff88c0779c_A_4, _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2);
            float _Subtract_1476eb191c244932ad0606241d596d33_Out_2;
            Unity_Subtract_float(_Multiply_983da0bb704c49f88acdd897af4e2942_Out_2, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2, _Subtract_1476eb191c244932ad0606241d596d33_Out_2);
            float _Property_b8a1367319b64842bc06551f0b38404a_Out_0 = _Strength;
            float _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2;
            Unity_Multiply_float_float(_Subtract_1476eb191c244932ad0606241d596d33_Out_2, _Property_b8a1367319b64842bc06551f0b38404a_Out_0, _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2);
            float _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3;
            Unity_Clamp_float(_Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2, 0, 1, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3);
            float _Lerp_e9f5f2254c63485bbf60161c27089f6c_Out_3;
            Unity_Lerp_float(0, _Property_faf0138af8284ee18af730107ac28d91_Out_0, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3, _Lerp_e9f5f2254c63485bbf60161c27089f6c_Out_3);
            float3 _NormalStrength_35691fd6222d4f3797055369fd967340_Out_2;
            Unity_NormalStrength_float((_Add_1167af1105f042b29ed2f1c382322709_Out_2.xyz), _Lerp_e9f5f2254c63485bbf60161c27089f6c_Out_3, _NormalStrength_35691fd6222d4f3797055369fd967340_Out_2);
            float4 _Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0 = _Shadow_Water_Color;
            float4 _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0 = _Deep_Water_Color;
            float4 _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3;
            Unity_Lerp_float4(_Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0, _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0, (_Clamp_b1c08e0420874f2387bc1673d1678257_Out_3.xxxx), _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3);
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_R_1 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[0];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_G_2 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[1];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_B_3 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[2];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[3];
            surface.NormalTS = _NormalStrength_35691fd6222d4f3797055369fd967340_Out_2;
            surface.Alpha = _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma shader_feature _ EDITOR_VISUALIZATION
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        #define VARYINGS_NEED_TEXCOORD2
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define _FOG_FRAGMENT 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            output.interp2.xyzw =  input.texCoord1;
            output.interp3.xyzw =  input.texCoord2;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            output.texCoord1 = input.interp2.xyzw;
            output.texCoord2 = input.interp3.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Depth;
        float _Strength;
        float4 _Deep_Water_Color;
        float4 _Shadow_Water_Color;
        float4 _Main_Normal_TexelSize;
        float4 _Second_Normal_TexelSize;
        float _Normal_Strength;
        float _Smoothness;
        float _Displacement;
        float _Wave_Strength;
        float2 _Main_Normal_Tile;
        float2 _Second_Normal_Tile;
        float4 _Highlight_Color;
        float _Highlight_Strength;
        float _Metalic;
        float _Ripple_Speed;
        float4 _Ripple_Texture_Ambient_Occlusion_TexelSize;
        float2 _Ripple_Tile;
        float _Ripple_Opacity;
        float _Main_Normal_Speed;
        float _Second_Normal_Speed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Normal);
        SAMPLER(sampler_Main_Normal);
        TEXTURE2D(_Second_Normal);
        SAMPLER(sampler_Second_Normal);
        TEXTURE2D(_Ripple_Texture_Ambient_Occlusion);
        SAMPLER(sampler_Ripple_Texture_Ambient_Occlusion);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1 = IN.ObjectSpacePosition[0];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_G_2 = IN.ObjectSpacePosition[1];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3 = IN.ObjectSpacePosition[2];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_A_4 = 0;
            float _Property_0357d5684c5741b98876c08275c12954_Out_0 = _Displacement;
            float _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 100, _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2);
            float2 _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2.xx), _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3);
            float _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0 = _Wave_Strength;
            float _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3, _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2);
            float _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2;
            Unity_Multiply_float_float(_Property_0357d5684c5741b98876c08275c12954_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2);
            float4 _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4;
            float3 _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            float2 _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6;
            Unity_Combine_float(_Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2, _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3, 0, _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4, _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5, _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6);
            description.Position = _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0 = _Shadow_Water_Color;
            float4 _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0 = _Deep_Water_Color;
            float _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1);
            float _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2;
            Unity_Multiply_float_float(_SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1, _ProjectionParams.z, _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2);
            float4 _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0 = IN.ScreenPosition;
            float _Split_64cd857bd1d64117a2a108ff88c0779c_R_1 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[0];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_G_2 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[1];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_B_3 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[2];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_A_4 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[3];
            float _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0 = _Depth;
            float _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2;
            Unity_Add_float(_Split_64cd857bd1d64117a2a108ff88c0779c_A_4, _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2);
            float _Subtract_1476eb191c244932ad0606241d596d33_Out_2;
            Unity_Subtract_float(_Multiply_983da0bb704c49f88acdd897af4e2942_Out_2, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2, _Subtract_1476eb191c244932ad0606241d596d33_Out_2);
            float _Property_b8a1367319b64842bc06551f0b38404a_Out_0 = _Strength;
            float _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2;
            Unity_Multiply_float_float(_Subtract_1476eb191c244932ad0606241d596d33_Out_2, _Property_b8a1367319b64842bc06551f0b38404a_Out_0, _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2);
            float _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3;
            Unity_Clamp_float(_Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2, 0, 1, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3);
            float4 _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3;
            Unity_Lerp_float4(_Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0, _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0, (_Clamp_b1c08e0420874f2387bc1673d1678257_Out_3.xxxx), _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3);
            float4 _Property_b89a6f497f904ecebcb204224f6204a3_Out_0 = _Highlight_Color;
            float _Property_1e0453f5ed0946b291991855928ab8c9_Out_0 = _Highlight_Strength;
            float4 _Multiply_4464f97133ef419683675ba4b5d96ce2_Out_2;
            Unity_Multiply_float4_float4(_Property_b89a6f497f904ecebcb204224f6204a3_Out_0, (_Property_1e0453f5ed0946b291991855928ab8c9_Out_0.xxxx), _Multiply_4464f97133ef419683675ba4b5d96ce2_Out_2);
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_R_1 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[0];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_G_2 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[1];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_B_3 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[2];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[3];
            surface.BaseColor = (_Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3.xyz);
            surface.Emission = (_Multiply_4464f97133ef419683675ba4b5d96ce2_Out_2.xyz);
            surface.Alpha = _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Depth;
        float _Strength;
        float4 _Deep_Water_Color;
        float4 _Shadow_Water_Color;
        float4 _Main_Normal_TexelSize;
        float4 _Second_Normal_TexelSize;
        float _Normal_Strength;
        float _Smoothness;
        float _Displacement;
        float _Wave_Strength;
        float2 _Main_Normal_Tile;
        float2 _Second_Normal_Tile;
        float4 _Highlight_Color;
        float _Highlight_Strength;
        float _Metalic;
        float _Ripple_Speed;
        float4 _Ripple_Texture_Ambient_Occlusion_TexelSize;
        float2 _Ripple_Tile;
        float _Ripple_Opacity;
        float _Main_Normal_Speed;
        float _Second_Normal_Speed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Normal);
        SAMPLER(sampler_Main_Normal);
        TEXTURE2D(_Second_Normal);
        SAMPLER(sampler_Second_Normal);
        TEXTURE2D(_Ripple_Texture_Ambient_Occlusion);
        SAMPLER(sampler_Ripple_Texture_Ambient_Occlusion);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1 = IN.ObjectSpacePosition[0];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_G_2 = IN.ObjectSpacePosition[1];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3 = IN.ObjectSpacePosition[2];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_A_4 = 0;
            float _Property_0357d5684c5741b98876c08275c12954_Out_0 = _Displacement;
            float _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 100, _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2);
            float2 _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2.xx), _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3);
            float _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0 = _Wave_Strength;
            float _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3, _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2);
            float _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2;
            Unity_Multiply_float_float(_Property_0357d5684c5741b98876c08275c12954_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2);
            float4 _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4;
            float3 _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            float2 _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6;
            Unity_Combine_float(_Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2, _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3, 0, _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4, _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5, _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6);
            description.Position = _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0 = _Shadow_Water_Color;
            float4 _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0 = _Deep_Water_Color;
            float _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1);
            float _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2;
            Unity_Multiply_float_float(_SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1, _ProjectionParams.z, _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2);
            float4 _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0 = IN.ScreenPosition;
            float _Split_64cd857bd1d64117a2a108ff88c0779c_R_1 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[0];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_G_2 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[1];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_B_3 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[2];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_A_4 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[3];
            float _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0 = _Depth;
            float _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2;
            Unity_Add_float(_Split_64cd857bd1d64117a2a108ff88c0779c_A_4, _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2);
            float _Subtract_1476eb191c244932ad0606241d596d33_Out_2;
            Unity_Subtract_float(_Multiply_983da0bb704c49f88acdd897af4e2942_Out_2, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2, _Subtract_1476eb191c244932ad0606241d596d33_Out_2);
            float _Property_b8a1367319b64842bc06551f0b38404a_Out_0 = _Strength;
            float _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2;
            Unity_Multiply_float_float(_Subtract_1476eb191c244932ad0606241d596d33_Out_2, _Property_b8a1367319b64842bc06551f0b38404a_Out_0, _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2);
            float _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3;
            Unity_Clamp_float(_Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2, 0, 1, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3);
            float4 _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3;
            Unity_Lerp_float4(_Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0, _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0, (_Clamp_b1c08e0420874f2387bc1673d1678257_Out_3.xxxx), _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3);
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_R_1 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[0];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_G_2 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[1];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_B_3 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[2];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[3];
            surface.Alpha = _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Back
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Depth;
        float _Strength;
        float4 _Deep_Water_Color;
        float4 _Shadow_Water_Color;
        float4 _Main_Normal_TexelSize;
        float4 _Second_Normal_TexelSize;
        float _Normal_Strength;
        float _Smoothness;
        float _Displacement;
        float _Wave_Strength;
        float2 _Main_Normal_Tile;
        float2 _Second_Normal_Tile;
        float4 _Highlight_Color;
        float _Highlight_Strength;
        float _Metalic;
        float _Ripple_Speed;
        float4 _Ripple_Texture_Ambient_Occlusion_TexelSize;
        float2 _Ripple_Tile;
        float _Ripple_Opacity;
        float _Main_Normal_Speed;
        float _Second_Normal_Speed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Normal);
        SAMPLER(sampler_Main_Normal);
        TEXTURE2D(_Second_Normal);
        SAMPLER(sampler_Second_Normal);
        TEXTURE2D(_Ripple_Texture_Ambient_Occlusion);
        SAMPLER(sampler_Ripple_Texture_Ambient_Occlusion);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1 = IN.ObjectSpacePosition[0];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_G_2 = IN.ObjectSpacePosition[1];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3 = IN.ObjectSpacePosition[2];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_A_4 = 0;
            float _Property_0357d5684c5741b98876c08275c12954_Out_0 = _Displacement;
            float _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 100, _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2);
            float2 _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2.xx), _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3);
            float _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0 = _Wave_Strength;
            float _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3, _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2);
            float _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2;
            Unity_Multiply_float_float(_Property_0357d5684c5741b98876c08275c12954_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2);
            float4 _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4;
            float3 _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            float2 _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6;
            Unity_Combine_float(_Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2, _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3, 0, _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4, _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5, _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6);
            description.Position = _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0 = _Shadow_Water_Color;
            float4 _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0 = _Deep_Water_Color;
            float _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1);
            float _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2;
            Unity_Multiply_float_float(_SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1, _ProjectionParams.z, _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2);
            float4 _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0 = IN.ScreenPosition;
            float _Split_64cd857bd1d64117a2a108ff88c0779c_R_1 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[0];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_G_2 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[1];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_B_3 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[2];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_A_4 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[3];
            float _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0 = _Depth;
            float _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2;
            Unity_Add_float(_Split_64cd857bd1d64117a2a108ff88c0779c_A_4, _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2);
            float _Subtract_1476eb191c244932ad0606241d596d33_Out_2;
            Unity_Subtract_float(_Multiply_983da0bb704c49f88acdd897af4e2942_Out_2, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2, _Subtract_1476eb191c244932ad0606241d596d33_Out_2);
            float _Property_b8a1367319b64842bc06551f0b38404a_Out_0 = _Strength;
            float _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2;
            Unity_Multiply_float_float(_Subtract_1476eb191c244932ad0606241d596d33_Out_2, _Property_b8a1367319b64842bc06551f0b38404a_Out_0, _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2);
            float _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3;
            Unity_Clamp_float(_Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2, 0, 1, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3);
            float4 _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3;
            Unity_Lerp_float4(_Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0, _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0, (_Clamp_b1c08e0420874f2387bc1673d1678257_Out_3.xxxx), _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3);
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_R_1 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[0];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_G_2 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[1];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_B_3 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[2];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[3];
            surface.Alpha = _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            // Name: <None>
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Depth;
        float _Strength;
        float4 _Deep_Water_Color;
        float4 _Shadow_Water_Color;
        float4 _Main_Normal_TexelSize;
        float4 _Second_Normal_TexelSize;
        float _Normal_Strength;
        float _Smoothness;
        float _Displacement;
        float _Wave_Strength;
        float2 _Main_Normal_Tile;
        float2 _Second_Normal_Tile;
        float4 _Highlight_Color;
        float _Highlight_Strength;
        float _Metalic;
        float _Ripple_Speed;
        float4 _Ripple_Texture_Ambient_Occlusion_TexelSize;
        float2 _Ripple_Tile;
        float _Ripple_Opacity;
        float _Main_Normal_Speed;
        float _Second_Normal_Speed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Normal);
        SAMPLER(sampler_Main_Normal);
        TEXTURE2D(_Second_Normal);
        SAMPLER(sampler_Second_Normal);
        TEXTURE2D(_Ripple_Texture_Ambient_Occlusion);
        SAMPLER(sampler_Ripple_Texture_Ambient_Occlusion);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1 = IN.ObjectSpacePosition[0];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_G_2 = IN.ObjectSpacePosition[1];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3 = IN.ObjectSpacePosition[2];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_A_4 = 0;
            float _Property_0357d5684c5741b98876c08275c12954_Out_0 = _Displacement;
            float _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 100, _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2);
            float2 _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2.xx), _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3);
            float _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0 = _Wave_Strength;
            float _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3, _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2);
            float _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2;
            Unity_Multiply_float_float(_Property_0357d5684c5741b98876c08275c12954_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2);
            float4 _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4;
            float3 _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            float2 _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6;
            Unity_Combine_float(_Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2, _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3, 0, _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4, _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5, _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6);
            description.Position = _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0 = _Shadow_Water_Color;
            float4 _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0 = _Deep_Water_Color;
            float _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1);
            float _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2;
            Unity_Multiply_float_float(_SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1, _ProjectionParams.z, _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2);
            float4 _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0 = IN.ScreenPosition;
            float _Split_64cd857bd1d64117a2a108ff88c0779c_R_1 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[0];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_G_2 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[1];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_B_3 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[2];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_A_4 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[3];
            float _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0 = _Depth;
            float _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2;
            Unity_Add_float(_Split_64cd857bd1d64117a2a108ff88c0779c_A_4, _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2);
            float _Subtract_1476eb191c244932ad0606241d596d33_Out_2;
            Unity_Subtract_float(_Multiply_983da0bb704c49f88acdd897af4e2942_Out_2, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2, _Subtract_1476eb191c244932ad0606241d596d33_Out_2);
            float _Property_b8a1367319b64842bc06551f0b38404a_Out_0 = _Strength;
            float _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2;
            Unity_Multiply_float_float(_Subtract_1476eb191c244932ad0606241d596d33_Out_2, _Property_b8a1367319b64842bc06551f0b38404a_Out_0, _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2);
            float _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3;
            Unity_Clamp_float(_Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2, 0, 1, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3);
            float4 _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3;
            Unity_Lerp_float4(_Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0, _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0, (_Clamp_b1c08e0420874f2387bc1673d1678257_Out_3.xxxx), _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3);
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_R_1 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[0];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_G_2 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[1];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_B_3 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[2];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[3];
            surface.BaseColor = (_Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3.xyz);
            surface.Alpha = _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Lit"
            "Queue"="Transparent"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalLitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile _ _LIGHT_LAYERS
        #pragma multi_compile _ DEBUG_DISPLAY
        #pragma multi_compile _ _LIGHT_COOKIES
        #pragma multi_compile _ _CLUSTERED_RENDERING
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float3 viewDirectionWS;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float3 interp4 : INTERP4;
             float2 interp5 : INTERP5;
             float2 interp6 : INTERP6;
             float3 interp7 : INTERP7;
             float4 interp8 : INTERP8;
             float4 interp9 : INTERP9;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.interp6.xy =  input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp7.xyz =  input.sh;
            #endif
            output.interp8.xyzw =  input.fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.interp9.xyzw =  input.shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.interp5.xy;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.interp6.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp7.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp8.xyzw;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.interp9.xyzw;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Depth;
        float _Strength;
        float4 _Deep_Water_Color;
        float4 _Shadow_Water_Color;
        float4 _Main_Normal_TexelSize;
        float4 _Second_Normal_TexelSize;
        float _Normal_Strength;
        float _Smoothness;
        float _Displacement;
        float _Wave_Strength;
        float2 _Main_Normal_Tile;
        float2 _Second_Normal_Tile;
        float4 _Highlight_Color;
        float _Highlight_Strength;
        float _Metalic;
        float _Ripple_Speed;
        float4 _Ripple_Texture_Ambient_Occlusion_TexelSize;
        float2 _Ripple_Tile;
        float _Ripple_Opacity;
        float _Main_Normal_Speed;
        float _Second_Normal_Speed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Normal);
        SAMPLER(sampler_Main_Normal);
        TEXTURE2D(_Second_Normal);
        SAMPLER(sampler_Second_Normal);
        TEXTURE2D(_Ripple_Texture_Ambient_Occlusion);
        SAMPLER(sampler_Ripple_Texture_Ambient_Occlusion);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1 = IN.ObjectSpacePosition[0];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_G_2 = IN.ObjectSpacePosition[1];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3 = IN.ObjectSpacePosition[2];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_A_4 = 0;
            float _Property_0357d5684c5741b98876c08275c12954_Out_0 = _Displacement;
            float _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 100, _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2);
            float2 _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2.xx), _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3);
            float _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0 = _Wave_Strength;
            float _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3, _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2);
            float _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2;
            Unity_Multiply_float_float(_Property_0357d5684c5741b98876c08275c12954_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2);
            float4 _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4;
            float3 _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            float2 _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6;
            Unity_Combine_float(_Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2, _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3, 0, _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4, _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5, _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6);
            description.Position = _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0 = _Shadow_Water_Color;
            float4 _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0 = _Deep_Water_Color;
            float _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1);
            float _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2;
            Unity_Multiply_float_float(_SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1, _ProjectionParams.z, _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2);
            float4 _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0 = IN.ScreenPosition;
            float _Split_64cd857bd1d64117a2a108ff88c0779c_R_1 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[0];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_G_2 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[1];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_B_3 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[2];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_A_4 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[3];
            float _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0 = _Depth;
            float _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2;
            Unity_Add_float(_Split_64cd857bd1d64117a2a108ff88c0779c_A_4, _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2);
            float _Subtract_1476eb191c244932ad0606241d596d33_Out_2;
            Unity_Subtract_float(_Multiply_983da0bb704c49f88acdd897af4e2942_Out_2, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2, _Subtract_1476eb191c244932ad0606241d596d33_Out_2);
            float _Property_b8a1367319b64842bc06551f0b38404a_Out_0 = _Strength;
            float _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2;
            Unity_Multiply_float_float(_Subtract_1476eb191c244932ad0606241d596d33_Out_2, _Property_b8a1367319b64842bc06551f0b38404a_Out_0, _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2);
            float _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3;
            Unity_Clamp_float(_Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2, 0, 1, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3);
            float4 _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3;
            Unity_Lerp_float4(_Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0, _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0, (_Clamp_b1c08e0420874f2387bc1673d1678257_Out_3.xxxx), _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3);
            UnityTexture2D _Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0 = UnityBuildTexture2DStructNoScale(_Main_Normal);
            float2 _Property_d1e6d170425c4c18856710c0538aa517_Out_0 = _Main_Normal_Tile;
            float _Divide_2732be57b2a549159a4dabc5f8f137c6_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 50, _Divide_2732be57b2a549159a4dabc5f8f137c6_Out_2);
            float2 _TilingAndOffset_a27ba90f79b3460abf165145741ba6c0_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_d1e6d170425c4c18856710c0538aa517_Out_0, (_Divide_2732be57b2a549159a4dabc5f8f137c6_Out_2.xx), _TilingAndOffset_a27ba90f79b3460abf165145741ba6c0_Out_3);
            float _Property_5c1fb20a3d6b4d3eaafd354baadf9609_Out_0 = _Main_Normal_Speed;
            float _Multiply_b74cc2e778c145c3a7401ac4cd2a4b0b_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_5c1fb20a3d6b4d3eaafd354baadf9609_Out_0, _Multiply_b74cc2e778c145c3a7401ac4cd2a4b0b_Out_2);
            float _Voronoi_467777a2abfd4ce1967536f9e44c2276_Out_3;
            float _Voronoi_467777a2abfd4ce1967536f9e44c2276_Cells_4;
            Unity_Voronoi_float((_Multiply_b74cc2e778c145c3a7401ac4cd2a4b0b_Out_2.xx), 0.1, 0.01, _Voronoi_467777a2abfd4ce1967536f9e44c2276_Out_3, _Voronoi_467777a2abfd4ce1967536f9e44c2276_Cells_4);
            float2 _Multiply_fa06a662967144269ae74ba3b4b6825c_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_a27ba90f79b3460abf165145741ba6c0_Out_3, (_Voronoi_467777a2abfd4ce1967536f9e44c2276_Out_3.xx), _Multiply_fa06a662967144269ae74ba3b4b6825c_Out_2);
            float4 _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0 = SAMPLE_TEXTURE2D(_Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0.tex, _Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0.samplerstate, _Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0.GetTransformedUV(_Multiply_fa06a662967144269ae74ba3b4b6825c_Out_2));
            _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0);
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_R_4 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.r;
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_G_5 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.g;
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_B_6 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.b;
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_A_7 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.a;
            UnityTexture2D _Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0 = UnityBuildTexture2DStructNoScale(_Second_Normal);
            float2 _Property_f994634ef25f46e0bbb7777c3dadb5a6_Out_0 = _Second_Normal_Tile;
            float _Divide_2024d2b7d7094075bb3feaa67982fcb2_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, -25, _Divide_2024d2b7d7094075bb3feaa67982fcb2_Out_2);
            float2 _TilingAndOffset_75a104fa5a5149a5b946df7fd1f3f8b6_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_f994634ef25f46e0bbb7777c3dadb5a6_Out_0, (_Divide_2024d2b7d7094075bb3feaa67982fcb2_Out_2.xx), _TilingAndOffset_75a104fa5a5149a5b946df7fd1f3f8b6_Out_3);
            float _Property_9b1f2a6be1a34f95bcb01a67c24c7fd7_Out_0 = _Second_Normal_Speed;
            float _Multiply_0f59000213ec4c6683ebe88920280f10_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9b1f2a6be1a34f95bcb01a67c24c7fd7_Out_0, _Multiply_0f59000213ec4c6683ebe88920280f10_Out_2);
            float _Voronoi_3738394378e24709a5873a6606cc6f3e_Out_3;
            float _Voronoi_3738394378e24709a5873a6606cc6f3e_Cells_4;
            Unity_Voronoi_float((_Multiply_0f59000213ec4c6683ebe88920280f10_Out_2.xx), 0.1, 0.01, _Voronoi_3738394378e24709a5873a6606cc6f3e_Out_3, _Voronoi_3738394378e24709a5873a6606cc6f3e_Cells_4);
            float2 _Multiply_5653e08b7cdb40dfa0fd755420c69c82_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_75a104fa5a5149a5b946df7fd1f3f8b6_Out_3, (_Voronoi_3738394378e24709a5873a6606cc6f3e_Out_3.xx), _Multiply_5653e08b7cdb40dfa0fd755420c69c82_Out_2);
            float4 _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0 = SAMPLE_TEXTURE2D(_Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0.tex, _Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0.samplerstate, _Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0.GetTransformedUV(_Multiply_5653e08b7cdb40dfa0fd755420c69c82_Out_2));
            _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0);
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_R_4 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.r;
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_G_5 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.g;
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_B_6 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.b;
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_A_7 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.a;
            float4 _Add_1167af1105f042b29ed2f1c382322709_Out_2;
            Unity_Add_float4(_SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0, _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0, _Add_1167af1105f042b29ed2f1c382322709_Out_2);
            float _Property_faf0138af8284ee18af730107ac28d91_Out_0 = _Normal_Strength;
            float _Lerp_e9f5f2254c63485bbf60161c27089f6c_Out_3;
            Unity_Lerp_float(0, _Property_faf0138af8284ee18af730107ac28d91_Out_0, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3, _Lerp_e9f5f2254c63485bbf60161c27089f6c_Out_3);
            float3 _NormalStrength_35691fd6222d4f3797055369fd967340_Out_2;
            Unity_NormalStrength_float((_Add_1167af1105f042b29ed2f1c382322709_Out_2.xyz), _Lerp_e9f5f2254c63485bbf60161c27089f6c_Out_3, _NormalStrength_35691fd6222d4f3797055369fd967340_Out_2);
            float4 _Property_b89a6f497f904ecebcb204224f6204a3_Out_0 = _Highlight_Color;
            float _Property_1e0453f5ed0946b291991855928ab8c9_Out_0 = _Highlight_Strength;
            float4 _Multiply_4464f97133ef419683675ba4b5d96ce2_Out_2;
            Unity_Multiply_float4_float4(_Property_b89a6f497f904ecebcb204224f6204a3_Out_0, (_Property_1e0453f5ed0946b291991855928ab8c9_Out_0.xxxx), _Multiply_4464f97133ef419683675ba4b5d96ce2_Out_2);
            float _Property_de94933959de451bbb82517c41b560cb_Out_0 = _Metalic;
            float _Property_8a2c01afc51445358940fa27b5c1c89e_Out_0 = _Smoothness;
            UnityTexture2D _Property_dec3e33ded004516a5ad056133c1b58e_Out_0 = UnityBuildTexture2DStructNoScale(_Ripple_Texture_Ambient_Occlusion);
            float2 _Property_530b0cba26934bd18c92b77aa80c6286_Out_0 = _Ripple_Tile;
            float2 _TilingAndOffset_4fda776a90e24c17bc0209d30c2c0b3e_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_530b0cba26934bd18c92b77aa80c6286_Out_0, float2 (0, 0), _TilingAndOffset_4fda776a90e24c17bc0209d30c2c0b3e_Out_3);
            float _Property_8fc20fcbc2d949d8b175eecee5d0746a_Out_0 = _Ripple_Speed;
            float _Multiply_25046a0a489442a0bf3026055fa09c56_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_8fc20fcbc2d949d8b175eecee5d0746a_Out_0, _Multiply_25046a0a489442a0bf3026055fa09c56_Out_2);
            float _Voronoi_b7697bc2164a48b9a16ec45afa015839_Out_3;
            float _Voronoi_b7697bc2164a48b9a16ec45afa015839_Cells_4;
            Unity_Voronoi_float((_Multiply_25046a0a489442a0bf3026055fa09c56_Out_2.xx), 0.1, 0.01, _Voronoi_b7697bc2164a48b9a16ec45afa015839_Out_3, _Voronoi_b7697bc2164a48b9a16ec45afa015839_Cells_4);
            float2 _Multiply_076b83e253344a7386496a7cd0de2587_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_4fda776a90e24c17bc0209d30c2c0b3e_Out_3, (_Voronoi_b7697bc2164a48b9a16ec45afa015839_Out_3.xx), _Multiply_076b83e253344a7386496a7cd0de2587_Out_2);
            float4 _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0 = SAMPLE_TEXTURE2D(_Property_dec3e33ded004516a5ad056133c1b58e_Out_0.tex, _Property_dec3e33ded004516a5ad056133c1b58e_Out_0.samplerstate, _Property_dec3e33ded004516a5ad056133c1b58e_Out_0.GetTransformedUV(_Multiply_076b83e253344a7386496a7cd0de2587_Out_2));
            float _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_R_4 = _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0.r;
            float _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_G_5 = _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0.g;
            float _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_B_6 = _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0.b;
            float _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_A_7 = _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0.a;
            float _Property_ff001ec7d20c49c79f2f4b2d70794ef7_Out_0 = _Ripple_Opacity;
            float4 _Add_f8c7532823d74818bc903a41930674af_Out_2;
            Unity_Add_float4(_SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0, (_Property_ff001ec7d20c49c79f2f4b2d70794ef7_Out_0.xxxx), _Add_f8c7532823d74818bc903a41930674af_Out_2);
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_R_1 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[0];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_G_2 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[1];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_B_3 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[2];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[3];
            surface.BaseColor = (_Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3.xyz);
            surface.NormalTS = _NormalStrength_35691fd6222d4f3797055369fd967340_Out_2;
            surface.Emission = (_Multiply_4464f97133ef419683675ba4b5d96ce2_Out_2.xyz);
            surface.Metallic = _Property_de94933959de451bbb82517c41b560cb_Out_0;
            surface.Smoothness = _Property_8a2c01afc51445358940fa27b5c1c89e_Out_0;
            surface.Occlusion = (_Add_f8c7532823d74818bc903a41930674af_Out_2).x;
            surface.Alpha = _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Depth;
        float _Strength;
        float4 _Deep_Water_Color;
        float4 _Shadow_Water_Color;
        float4 _Main_Normal_TexelSize;
        float4 _Second_Normal_TexelSize;
        float _Normal_Strength;
        float _Smoothness;
        float _Displacement;
        float _Wave_Strength;
        float2 _Main_Normal_Tile;
        float2 _Second_Normal_Tile;
        float4 _Highlight_Color;
        float _Highlight_Strength;
        float _Metalic;
        float _Ripple_Speed;
        float4 _Ripple_Texture_Ambient_Occlusion_TexelSize;
        float2 _Ripple_Tile;
        float _Ripple_Opacity;
        float _Main_Normal_Speed;
        float _Second_Normal_Speed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Normal);
        SAMPLER(sampler_Main_Normal);
        TEXTURE2D(_Second_Normal);
        SAMPLER(sampler_Second_Normal);
        TEXTURE2D(_Ripple_Texture_Ambient_Occlusion);
        SAMPLER(sampler_Ripple_Texture_Ambient_Occlusion);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1 = IN.ObjectSpacePosition[0];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_G_2 = IN.ObjectSpacePosition[1];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3 = IN.ObjectSpacePosition[2];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_A_4 = 0;
            float _Property_0357d5684c5741b98876c08275c12954_Out_0 = _Displacement;
            float _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 100, _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2);
            float2 _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2.xx), _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3);
            float _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0 = _Wave_Strength;
            float _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3, _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2);
            float _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2;
            Unity_Multiply_float_float(_Property_0357d5684c5741b98876c08275c12954_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2);
            float4 _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4;
            float3 _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            float2 _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6;
            Unity_Combine_float(_Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2, _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3, 0, _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4, _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5, _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6);
            description.Position = _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0 = _Shadow_Water_Color;
            float4 _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0 = _Deep_Water_Color;
            float _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1);
            float _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2;
            Unity_Multiply_float_float(_SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1, _ProjectionParams.z, _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2);
            float4 _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0 = IN.ScreenPosition;
            float _Split_64cd857bd1d64117a2a108ff88c0779c_R_1 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[0];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_G_2 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[1];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_B_3 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[2];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_A_4 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[3];
            float _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0 = _Depth;
            float _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2;
            Unity_Add_float(_Split_64cd857bd1d64117a2a108ff88c0779c_A_4, _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2);
            float _Subtract_1476eb191c244932ad0606241d596d33_Out_2;
            Unity_Subtract_float(_Multiply_983da0bb704c49f88acdd897af4e2942_Out_2, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2, _Subtract_1476eb191c244932ad0606241d596d33_Out_2);
            float _Property_b8a1367319b64842bc06551f0b38404a_Out_0 = _Strength;
            float _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2;
            Unity_Multiply_float_float(_Subtract_1476eb191c244932ad0606241d596d33_Out_2, _Property_b8a1367319b64842bc06551f0b38404a_Out_0, _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2);
            float _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3;
            Unity_Clamp_float(_Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2, 0, 1, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3);
            float4 _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3;
            Unity_Lerp_float4(_Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0, _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0, (_Clamp_b1c08e0420874f2387bc1673d1678257_Out_3.xxxx), _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3);
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_R_1 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[0];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_G_2 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[1];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_B_3 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[2];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[3];
            surface.Alpha = _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALS
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Depth;
        float _Strength;
        float4 _Deep_Water_Color;
        float4 _Shadow_Water_Color;
        float4 _Main_Normal_TexelSize;
        float4 _Second_Normal_TexelSize;
        float _Normal_Strength;
        float _Smoothness;
        float _Displacement;
        float _Wave_Strength;
        float2 _Main_Normal_Tile;
        float2 _Second_Normal_Tile;
        float4 _Highlight_Color;
        float _Highlight_Strength;
        float _Metalic;
        float _Ripple_Speed;
        float4 _Ripple_Texture_Ambient_Occlusion_TexelSize;
        float2 _Ripple_Tile;
        float _Ripple_Opacity;
        float _Main_Normal_Speed;
        float _Second_Normal_Speed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Normal);
        SAMPLER(sampler_Main_Normal);
        TEXTURE2D(_Second_Normal);
        SAMPLER(sampler_Second_Normal);
        TEXTURE2D(_Ripple_Texture_Ambient_Occlusion);
        SAMPLER(sampler_Ripple_Texture_Ambient_Occlusion);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1 = IN.ObjectSpacePosition[0];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_G_2 = IN.ObjectSpacePosition[1];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3 = IN.ObjectSpacePosition[2];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_A_4 = 0;
            float _Property_0357d5684c5741b98876c08275c12954_Out_0 = _Displacement;
            float _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 100, _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2);
            float2 _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2.xx), _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3);
            float _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0 = _Wave_Strength;
            float _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3, _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2);
            float _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2;
            Unity_Multiply_float_float(_Property_0357d5684c5741b98876c08275c12954_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2);
            float4 _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4;
            float3 _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            float2 _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6;
            Unity_Combine_float(_Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2, _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3, 0, _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4, _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5, _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6);
            description.Position = _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 NormalTS;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0 = UnityBuildTexture2DStructNoScale(_Main_Normal);
            float2 _Property_d1e6d170425c4c18856710c0538aa517_Out_0 = _Main_Normal_Tile;
            float _Divide_2732be57b2a549159a4dabc5f8f137c6_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 50, _Divide_2732be57b2a549159a4dabc5f8f137c6_Out_2);
            float2 _TilingAndOffset_a27ba90f79b3460abf165145741ba6c0_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_d1e6d170425c4c18856710c0538aa517_Out_0, (_Divide_2732be57b2a549159a4dabc5f8f137c6_Out_2.xx), _TilingAndOffset_a27ba90f79b3460abf165145741ba6c0_Out_3);
            float _Property_5c1fb20a3d6b4d3eaafd354baadf9609_Out_0 = _Main_Normal_Speed;
            float _Multiply_b74cc2e778c145c3a7401ac4cd2a4b0b_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_5c1fb20a3d6b4d3eaafd354baadf9609_Out_0, _Multiply_b74cc2e778c145c3a7401ac4cd2a4b0b_Out_2);
            float _Voronoi_467777a2abfd4ce1967536f9e44c2276_Out_3;
            float _Voronoi_467777a2abfd4ce1967536f9e44c2276_Cells_4;
            Unity_Voronoi_float((_Multiply_b74cc2e778c145c3a7401ac4cd2a4b0b_Out_2.xx), 0.1, 0.01, _Voronoi_467777a2abfd4ce1967536f9e44c2276_Out_3, _Voronoi_467777a2abfd4ce1967536f9e44c2276_Cells_4);
            float2 _Multiply_fa06a662967144269ae74ba3b4b6825c_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_a27ba90f79b3460abf165145741ba6c0_Out_3, (_Voronoi_467777a2abfd4ce1967536f9e44c2276_Out_3.xx), _Multiply_fa06a662967144269ae74ba3b4b6825c_Out_2);
            float4 _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0 = SAMPLE_TEXTURE2D(_Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0.tex, _Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0.samplerstate, _Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0.GetTransformedUV(_Multiply_fa06a662967144269ae74ba3b4b6825c_Out_2));
            _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0);
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_R_4 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.r;
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_G_5 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.g;
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_B_6 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.b;
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_A_7 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.a;
            UnityTexture2D _Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0 = UnityBuildTexture2DStructNoScale(_Second_Normal);
            float2 _Property_f994634ef25f46e0bbb7777c3dadb5a6_Out_0 = _Second_Normal_Tile;
            float _Divide_2024d2b7d7094075bb3feaa67982fcb2_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, -25, _Divide_2024d2b7d7094075bb3feaa67982fcb2_Out_2);
            float2 _TilingAndOffset_75a104fa5a5149a5b946df7fd1f3f8b6_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_f994634ef25f46e0bbb7777c3dadb5a6_Out_0, (_Divide_2024d2b7d7094075bb3feaa67982fcb2_Out_2.xx), _TilingAndOffset_75a104fa5a5149a5b946df7fd1f3f8b6_Out_3);
            float _Property_9b1f2a6be1a34f95bcb01a67c24c7fd7_Out_0 = _Second_Normal_Speed;
            float _Multiply_0f59000213ec4c6683ebe88920280f10_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9b1f2a6be1a34f95bcb01a67c24c7fd7_Out_0, _Multiply_0f59000213ec4c6683ebe88920280f10_Out_2);
            float _Voronoi_3738394378e24709a5873a6606cc6f3e_Out_3;
            float _Voronoi_3738394378e24709a5873a6606cc6f3e_Cells_4;
            Unity_Voronoi_float((_Multiply_0f59000213ec4c6683ebe88920280f10_Out_2.xx), 0.1, 0.01, _Voronoi_3738394378e24709a5873a6606cc6f3e_Out_3, _Voronoi_3738394378e24709a5873a6606cc6f3e_Cells_4);
            float2 _Multiply_5653e08b7cdb40dfa0fd755420c69c82_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_75a104fa5a5149a5b946df7fd1f3f8b6_Out_3, (_Voronoi_3738394378e24709a5873a6606cc6f3e_Out_3.xx), _Multiply_5653e08b7cdb40dfa0fd755420c69c82_Out_2);
            float4 _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0 = SAMPLE_TEXTURE2D(_Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0.tex, _Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0.samplerstate, _Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0.GetTransformedUV(_Multiply_5653e08b7cdb40dfa0fd755420c69c82_Out_2));
            _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0);
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_R_4 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.r;
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_G_5 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.g;
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_B_6 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.b;
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_A_7 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.a;
            float4 _Add_1167af1105f042b29ed2f1c382322709_Out_2;
            Unity_Add_float4(_SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0, _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0, _Add_1167af1105f042b29ed2f1c382322709_Out_2);
            float _Property_faf0138af8284ee18af730107ac28d91_Out_0 = _Normal_Strength;
            float _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1);
            float _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2;
            Unity_Multiply_float_float(_SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1, _ProjectionParams.z, _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2);
            float4 _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0 = IN.ScreenPosition;
            float _Split_64cd857bd1d64117a2a108ff88c0779c_R_1 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[0];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_G_2 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[1];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_B_3 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[2];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_A_4 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[3];
            float _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0 = _Depth;
            float _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2;
            Unity_Add_float(_Split_64cd857bd1d64117a2a108ff88c0779c_A_4, _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2);
            float _Subtract_1476eb191c244932ad0606241d596d33_Out_2;
            Unity_Subtract_float(_Multiply_983da0bb704c49f88acdd897af4e2942_Out_2, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2, _Subtract_1476eb191c244932ad0606241d596d33_Out_2);
            float _Property_b8a1367319b64842bc06551f0b38404a_Out_0 = _Strength;
            float _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2;
            Unity_Multiply_float_float(_Subtract_1476eb191c244932ad0606241d596d33_Out_2, _Property_b8a1367319b64842bc06551f0b38404a_Out_0, _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2);
            float _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3;
            Unity_Clamp_float(_Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2, 0, 1, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3);
            float _Lerp_e9f5f2254c63485bbf60161c27089f6c_Out_3;
            Unity_Lerp_float(0, _Property_faf0138af8284ee18af730107ac28d91_Out_0, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3, _Lerp_e9f5f2254c63485bbf60161c27089f6c_Out_3);
            float3 _NormalStrength_35691fd6222d4f3797055369fd967340_Out_2;
            Unity_NormalStrength_float((_Add_1167af1105f042b29ed2f1c382322709_Out_2.xyz), _Lerp_e9f5f2254c63485bbf60161c27089f6c_Out_3, _NormalStrength_35691fd6222d4f3797055369fd967340_Out_2);
            float4 _Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0 = _Shadow_Water_Color;
            float4 _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0 = _Deep_Water_Color;
            float4 _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3;
            Unity_Lerp_float4(_Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0, _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0, (_Clamp_b1c08e0420874f2387bc1673d1678257_Out_3.xxxx), _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3);
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_R_1 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[0];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_G_2 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[1];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_B_3 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[2];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[3];
            surface.NormalTS = _NormalStrength_35691fd6222d4f3797055369fd967340_Out_2;
            surface.Alpha = _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma shader_feature _ EDITOR_VISUALIZATION
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        #define VARYINGS_NEED_TEXCOORD2
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define _FOG_FRAGMENT 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            output.interp2.xyzw =  input.texCoord1;
            output.interp3.xyzw =  input.texCoord2;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            output.texCoord1 = input.interp2.xyzw;
            output.texCoord2 = input.interp3.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Depth;
        float _Strength;
        float4 _Deep_Water_Color;
        float4 _Shadow_Water_Color;
        float4 _Main_Normal_TexelSize;
        float4 _Second_Normal_TexelSize;
        float _Normal_Strength;
        float _Smoothness;
        float _Displacement;
        float _Wave_Strength;
        float2 _Main_Normal_Tile;
        float2 _Second_Normal_Tile;
        float4 _Highlight_Color;
        float _Highlight_Strength;
        float _Metalic;
        float _Ripple_Speed;
        float4 _Ripple_Texture_Ambient_Occlusion_TexelSize;
        float2 _Ripple_Tile;
        float _Ripple_Opacity;
        float _Main_Normal_Speed;
        float _Second_Normal_Speed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Normal);
        SAMPLER(sampler_Main_Normal);
        TEXTURE2D(_Second_Normal);
        SAMPLER(sampler_Second_Normal);
        TEXTURE2D(_Ripple_Texture_Ambient_Occlusion);
        SAMPLER(sampler_Ripple_Texture_Ambient_Occlusion);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1 = IN.ObjectSpacePosition[0];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_G_2 = IN.ObjectSpacePosition[1];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3 = IN.ObjectSpacePosition[2];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_A_4 = 0;
            float _Property_0357d5684c5741b98876c08275c12954_Out_0 = _Displacement;
            float _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 100, _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2);
            float2 _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2.xx), _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3);
            float _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0 = _Wave_Strength;
            float _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3, _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2);
            float _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2;
            Unity_Multiply_float_float(_Property_0357d5684c5741b98876c08275c12954_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2);
            float4 _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4;
            float3 _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            float2 _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6;
            Unity_Combine_float(_Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2, _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3, 0, _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4, _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5, _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6);
            description.Position = _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0 = _Shadow_Water_Color;
            float4 _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0 = _Deep_Water_Color;
            float _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1);
            float _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2;
            Unity_Multiply_float_float(_SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1, _ProjectionParams.z, _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2);
            float4 _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0 = IN.ScreenPosition;
            float _Split_64cd857bd1d64117a2a108ff88c0779c_R_1 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[0];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_G_2 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[1];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_B_3 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[2];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_A_4 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[3];
            float _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0 = _Depth;
            float _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2;
            Unity_Add_float(_Split_64cd857bd1d64117a2a108ff88c0779c_A_4, _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2);
            float _Subtract_1476eb191c244932ad0606241d596d33_Out_2;
            Unity_Subtract_float(_Multiply_983da0bb704c49f88acdd897af4e2942_Out_2, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2, _Subtract_1476eb191c244932ad0606241d596d33_Out_2);
            float _Property_b8a1367319b64842bc06551f0b38404a_Out_0 = _Strength;
            float _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2;
            Unity_Multiply_float_float(_Subtract_1476eb191c244932ad0606241d596d33_Out_2, _Property_b8a1367319b64842bc06551f0b38404a_Out_0, _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2);
            float _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3;
            Unity_Clamp_float(_Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2, 0, 1, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3);
            float4 _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3;
            Unity_Lerp_float4(_Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0, _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0, (_Clamp_b1c08e0420874f2387bc1673d1678257_Out_3.xxxx), _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3);
            float4 _Property_b89a6f497f904ecebcb204224f6204a3_Out_0 = _Highlight_Color;
            float _Property_1e0453f5ed0946b291991855928ab8c9_Out_0 = _Highlight_Strength;
            float4 _Multiply_4464f97133ef419683675ba4b5d96ce2_Out_2;
            Unity_Multiply_float4_float4(_Property_b89a6f497f904ecebcb204224f6204a3_Out_0, (_Property_1e0453f5ed0946b291991855928ab8c9_Out_0.xxxx), _Multiply_4464f97133ef419683675ba4b5d96ce2_Out_2);
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_R_1 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[0];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_G_2 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[1];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_B_3 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[2];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[3];
            surface.BaseColor = (_Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3.xyz);
            surface.Emission = (_Multiply_4464f97133ef419683675ba4b5d96ce2_Out_2.xyz);
            surface.Alpha = _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Depth;
        float _Strength;
        float4 _Deep_Water_Color;
        float4 _Shadow_Water_Color;
        float4 _Main_Normal_TexelSize;
        float4 _Second_Normal_TexelSize;
        float _Normal_Strength;
        float _Smoothness;
        float _Displacement;
        float _Wave_Strength;
        float2 _Main_Normal_Tile;
        float2 _Second_Normal_Tile;
        float4 _Highlight_Color;
        float _Highlight_Strength;
        float _Metalic;
        float _Ripple_Speed;
        float4 _Ripple_Texture_Ambient_Occlusion_TexelSize;
        float2 _Ripple_Tile;
        float _Ripple_Opacity;
        float _Main_Normal_Speed;
        float _Second_Normal_Speed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Normal);
        SAMPLER(sampler_Main_Normal);
        TEXTURE2D(_Second_Normal);
        SAMPLER(sampler_Second_Normal);
        TEXTURE2D(_Ripple_Texture_Ambient_Occlusion);
        SAMPLER(sampler_Ripple_Texture_Ambient_Occlusion);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1 = IN.ObjectSpacePosition[0];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_G_2 = IN.ObjectSpacePosition[1];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3 = IN.ObjectSpacePosition[2];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_A_4 = 0;
            float _Property_0357d5684c5741b98876c08275c12954_Out_0 = _Displacement;
            float _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 100, _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2);
            float2 _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2.xx), _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3);
            float _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0 = _Wave_Strength;
            float _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3, _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2);
            float _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2;
            Unity_Multiply_float_float(_Property_0357d5684c5741b98876c08275c12954_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2);
            float4 _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4;
            float3 _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            float2 _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6;
            Unity_Combine_float(_Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2, _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3, 0, _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4, _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5, _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6);
            description.Position = _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0 = _Shadow_Water_Color;
            float4 _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0 = _Deep_Water_Color;
            float _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1);
            float _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2;
            Unity_Multiply_float_float(_SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1, _ProjectionParams.z, _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2);
            float4 _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0 = IN.ScreenPosition;
            float _Split_64cd857bd1d64117a2a108ff88c0779c_R_1 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[0];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_G_2 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[1];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_B_3 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[2];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_A_4 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[3];
            float _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0 = _Depth;
            float _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2;
            Unity_Add_float(_Split_64cd857bd1d64117a2a108ff88c0779c_A_4, _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2);
            float _Subtract_1476eb191c244932ad0606241d596d33_Out_2;
            Unity_Subtract_float(_Multiply_983da0bb704c49f88acdd897af4e2942_Out_2, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2, _Subtract_1476eb191c244932ad0606241d596d33_Out_2);
            float _Property_b8a1367319b64842bc06551f0b38404a_Out_0 = _Strength;
            float _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2;
            Unity_Multiply_float_float(_Subtract_1476eb191c244932ad0606241d596d33_Out_2, _Property_b8a1367319b64842bc06551f0b38404a_Out_0, _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2);
            float _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3;
            Unity_Clamp_float(_Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2, 0, 1, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3);
            float4 _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3;
            Unity_Lerp_float4(_Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0, _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0, (_Clamp_b1c08e0420874f2387bc1673d1678257_Out_3.xxxx), _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3);
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_R_1 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[0];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_G_2 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[1];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_B_3 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[2];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[3];
            surface.Alpha = _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Back
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Depth;
        float _Strength;
        float4 _Deep_Water_Color;
        float4 _Shadow_Water_Color;
        float4 _Main_Normal_TexelSize;
        float4 _Second_Normal_TexelSize;
        float _Normal_Strength;
        float _Smoothness;
        float _Displacement;
        float _Wave_Strength;
        float2 _Main_Normal_Tile;
        float2 _Second_Normal_Tile;
        float4 _Highlight_Color;
        float _Highlight_Strength;
        float _Metalic;
        float _Ripple_Speed;
        float4 _Ripple_Texture_Ambient_Occlusion_TexelSize;
        float2 _Ripple_Tile;
        float _Ripple_Opacity;
        float _Main_Normal_Speed;
        float _Second_Normal_Speed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Normal);
        SAMPLER(sampler_Main_Normal);
        TEXTURE2D(_Second_Normal);
        SAMPLER(sampler_Second_Normal);
        TEXTURE2D(_Ripple_Texture_Ambient_Occlusion);
        SAMPLER(sampler_Ripple_Texture_Ambient_Occlusion);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1 = IN.ObjectSpacePosition[0];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_G_2 = IN.ObjectSpacePosition[1];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3 = IN.ObjectSpacePosition[2];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_A_4 = 0;
            float _Property_0357d5684c5741b98876c08275c12954_Out_0 = _Displacement;
            float _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 100, _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2);
            float2 _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2.xx), _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3);
            float _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0 = _Wave_Strength;
            float _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3, _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2);
            float _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2;
            Unity_Multiply_float_float(_Property_0357d5684c5741b98876c08275c12954_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2);
            float4 _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4;
            float3 _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            float2 _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6;
            Unity_Combine_float(_Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2, _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3, 0, _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4, _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5, _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6);
            description.Position = _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0 = _Shadow_Water_Color;
            float4 _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0 = _Deep_Water_Color;
            float _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1);
            float _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2;
            Unity_Multiply_float_float(_SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1, _ProjectionParams.z, _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2);
            float4 _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0 = IN.ScreenPosition;
            float _Split_64cd857bd1d64117a2a108ff88c0779c_R_1 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[0];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_G_2 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[1];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_B_3 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[2];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_A_4 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[3];
            float _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0 = _Depth;
            float _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2;
            Unity_Add_float(_Split_64cd857bd1d64117a2a108ff88c0779c_A_4, _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2);
            float _Subtract_1476eb191c244932ad0606241d596d33_Out_2;
            Unity_Subtract_float(_Multiply_983da0bb704c49f88acdd897af4e2942_Out_2, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2, _Subtract_1476eb191c244932ad0606241d596d33_Out_2);
            float _Property_b8a1367319b64842bc06551f0b38404a_Out_0 = _Strength;
            float _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2;
            Unity_Multiply_float_float(_Subtract_1476eb191c244932ad0606241d596d33_Out_2, _Property_b8a1367319b64842bc06551f0b38404a_Out_0, _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2);
            float _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3;
            Unity_Clamp_float(_Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2, 0, 1, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3);
            float4 _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3;
            Unity_Lerp_float4(_Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0, _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0, (_Clamp_b1c08e0420874f2387bc1673d1678257_Out_3.xxxx), _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3);
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_R_1 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[0];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_G_2 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[1];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_B_3 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[2];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[3];
            surface.Alpha = _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            // Name: <None>
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Depth;
        float _Strength;
        float4 _Deep_Water_Color;
        float4 _Shadow_Water_Color;
        float4 _Main_Normal_TexelSize;
        float4 _Second_Normal_TexelSize;
        float _Normal_Strength;
        float _Smoothness;
        float _Displacement;
        float _Wave_Strength;
        float2 _Main_Normal_Tile;
        float2 _Second_Normal_Tile;
        float4 _Highlight_Color;
        float _Highlight_Strength;
        float _Metalic;
        float _Ripple_Speed;
        float4 _Ripple_Texture_Ambient_Occlusion_TexelSize;
        float2 _Ripple_Tile;
        float _Ripple_Opacity;
        float _Main_Normal_Speed;
        float _Second_Normal_Speed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Normal);
        SAMPLER(sampler_Main_Normal);
        TEXTURE2D(_Second_Normal);
        SAMPLER(sampler_Second_Normal);
        TEXTURE2D(_Ripple_Texture_Ambient_Occlusion);
        SAMPLER(sampler_Ripple_Texture_Ambient_Occlusion);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1 = IN.ObjectSpacePosition[0];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_G_2 = IN.ObjectSpacePosition[1];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3 = IN.ObjectSpacePosition[2];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_A_4 = 0;
            float _Property_0357d5684c5741b98876c08275c12954_Out_0 = _Displacement;
            float _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 100, _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2);
            float2 _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2.xx), _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3);
            float _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0 = _Wave_Strength;
            float _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3, _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2);
            float _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2;
            Unity_Multiply_float_float(_Property_0357d5684c5741b98876c08275c12954_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2);
            float4 _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4;
            float3 _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            float2 _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6;
            Unity_Combine_float(_Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2, _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3, 0, _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4, _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5, _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6);
            description.Position = _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0 = _Shadow_Water_Color;
            float4 _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0 = _Deep_Water_Color;
            float _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1);
            float _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2;
            Unity_Multiply_float_float(_SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1, _ProjectionParams.z, _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2);
            float4 _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0 = IN.ScreenPosition;
            float _Split_64cd857bd1d64117a2a108ff88c0779c_R_1 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[0];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_G_2 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[1];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_B_3 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[2];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_A_4 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[3];
            float _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0 = _Depth;
            float _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2;
            Unity_Add_float(_Split_64cd857bd1d64117a2a108ff88c0779c_A_4, _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2);
            float _Subtract_1476eb191c244932ad0606241d596d33_Out_2;
            Unity_Subtract_float(_Multiply_983da0bb704c49f88acdd897af4e2942_Out_2, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2, _Subtract_1476eb191c244932ad0606241d596d33_Out_2);
            float _Property_b8a1367319b64842bc06551f0b38404a_Out_0 = _Strength;
            float _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2;
            Unity_Multiply_float_float(_Subtract_1476eb191c244932ad0606241d596d33_Out_2, _Property_b8a1367319b64842bc06551f0b38404a_Out_0, _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2);
            float _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3;
            Unity_Clamp_float(_Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2, 0, 1, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3);
            float4 _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3;
            Unity_Lerp_float4(_Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0, _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0, (_Clamp_b1c08e0420874f2387bc1673d1678257_Out_3.xxxx), _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3);
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_R_1 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[0];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_G_2 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[1];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_B_3 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[2];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[3];
            surface.BaseColor = (_Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3.xyz);
            surface.Alpha = _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditorForRenderPipeline "UnityEditor.ShaderGraphLitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    SubShader
    {
        Tags
        {
            // RenderPipeline: <None>
            "RenderType"="Transparent"
            "BuiltInMaterialType" = "Lit"
            "Queue"="Transparent"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="BuiltInLitSubTarget"
        }
        Pass
        {
            Name "BuiltIn Forward"
            Tags
            {
                "LightMode" = "ForwardBase"
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        ColorMask RGB
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.0
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma multi_compile_fwdbase
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
        #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        // GraphKeywords: <None>
        
        // Defines
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define BUILTIN_TARGET_API 1
        #define _BUILTIN_SURFACE_TYPE_TRANSPARENT 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #endif
        #ifdef _BUILTIN_ALPHATEST_ON
        #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
        #endif
        #ifdef _BUILTIN_AlphaClip
        #define _AlphaClip _BUILTIN_AlphaClip
        #endif
        #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
        #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
        #endif
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float3 viewDirectionWS;
            #if defined(LIGHTMAP_ON)
             float2 lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
             float4 shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float3 interp4 : INTERP4;
             float2 interp5 : INTERP5;
             float3 interp6 : INTERP6;
             float4 interp7 : INTERP7;
             float4 interp8 : INTERP8;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp6.xyz =  input.sh;
            #endif
            output.interp7.xyzw =  input.fogFactorAndVertexLight;
            output.interp8.xyzw =  input.shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if defined(LIGHTMAP_ON)
            output.lightmapUV = input.interp5.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp6.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp7.xyzw;
            output.shadowCoord = input.interp8.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Depth;
        float _Strength;
        float4 _Deep_Water_Color;
        float4 _Shadow_Water_Color;
        float4 _Main_Normal_TexelSize;
        float4 _Second_Normal_TexelSize;
        float _Normal_Strength;
        float _Smoothness;
        float _Displacement;
        float _Wave_Strength;
        float2 _Main_Normal_Tile;
        float2 _Second_Normal_Tile;
        float4 _Highlight_Color;
        float _Highlight_Strength;
        float _Metalic;
        float _Ripple_Speed;
        float4 _Ripple_Texture_Ambient_Occlusion_TexelSize;
        float2 _Ripple_Tile;
        float _Ripple_Opacity;
        float _Main_Normal_Speed;
        float _Second_Normal_Speed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Normal);
        SAMPLER(sampler_Main_Normal);
        TEXTURE2D(_Second_Normal);
        SAMPLER(sampler_Second_Normal);
        TEXTURE2D(_Ripple_Texture_Ambient_Occlusion);
        SAMPLER(sampler_Ripple_Texture_Ambient_Occlusion);
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1 = IN.ObjectSpacePosition[0];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_G_2 = IN.ObjectSpacePosition[1];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3 = IN.ObjectSpacePosition[2];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_A_4 = 0;
            float _Property_0357d5684c5741b98876c08275c12954_Out_0 = _Displacement;
            float _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 100, _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2);
            float2 _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2.xx), _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3);
            float _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0 = _Wave_Strength;
            float _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3, _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2);
            float _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2;
            Unity_Multiply_float_float(_Property_0357d5684c5741b98876c08275c12954_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2);
            float4 _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4;
            float3 _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            float2 _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6;
            Unity_Combine_float(_Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2, _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3, 0, _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4, _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5, _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6);
            description.Position = _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0 = _Shadow_Water_Color;
            float4 _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0 = _Deep_Water_Color;
            float _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1);
            float _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2;
            Unity_Multiply_float_float(_SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1, _ProjectionParams.z, _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2);
            float4 _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0 = IN.ScreenPosition;
            float _Split_64cd857bd1d64117a2a108ff88c0779c_R_1 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[0];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_G_2 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[1];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_B_3 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[2];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_A_4 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[3];
            float _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0 = _Depth;
            float _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2;
            Unity_Add_float(_Split_64cd857bd1d64117a2a108ff88c0779c_A_4, _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2);
            float _Subtract_1476eb191c244932ad0606241d596d33_Out_2;
            Unity_Subtract_float(_Multiply_983da0bb704c49f88acdd897af4e2942_Out_2, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2, _Subtract_1476eb191c244932ad0606241d596d33_Out_2);
            float _Property_b8a1367319b64842bc06551f0b38404a_Out_0 = _Strength;
            float _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2;
            Unity_Multiply_float_float(_Subtract_1476eb191c244932ad0606241d596d33_Out_2, _Property_b8a1367319b64842bc06551f0b38404a_Out_0, _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2);
            float _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3;
            Unity_Clamp_float(_Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2, 0, 1, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3);
            float4 _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3;
            Unity_Lerp_float4(_Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0, _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0, (_Clamp_b1c08e0420874f2387bc1673d1678257_Out_3.xxxx), _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3);
            UnityTexture2D _Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0 = UnityBuildTexture2DStructNoScale(_Main_Normal);
            float2 _Property_d1e6d170425c4c18856710c0538aa517_Out_0 = _Main_Normal_Tile;
            float _Divide_2732be57b2a549159a4dabc5f8f137c6_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 50, _Divide_2732be57b2a549159a4dabc5f8f137c6_Out_2);
            float2 _TilingAndOffset_a27ba90f79b3460abf165145741ba6c0_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_d1e6d170425c4c18856710c0538aa517_Out_0, (_Divide_2732be57b2a549159a4dabc5f8f137c6_Out_2.xx), _TilingAndOffset_a27ba90f79b3460abf165145741ba6c0_Out_3);
            float _Property_5c1fb20a3d6b4d3eaafd354baadf9609_Out_0 = _Main_Normal_Speed;
            float _Multiply_b74cc2e778c145c3a7401ac4cd2a4b0b_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_5c1fb20a3d6b4d3eaafd354baadf9609_Out_0, _Multiply_b74cc2e778c145c3a7401ac4cd2a4b0b_Out_2);
            float _Voronoi_467777a2abfd4ce1967536f9e44c2276_Out_3;
            float _Voronoi_467777a2abfd4ce1967536f9e44c2276_Cells_4;
            Unity_Voronoi_float((_Multiply_b74cc2e778c145c3a7401ac4cd2a4b0b_Out_2.xx), 0.1, 0.01, _Voronoi_467777a2abfd4ce1967536f9e44c2276_Out_3, _Voronoi_467777a2abfd4ce1967536f9e44c2276_Cells_4);
            float2 _Multiply_fa06a662967144269ae74ba3b4b6825c_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_a27ba90f79b3460abf165145741ba6c0_Out_3, (_Voronoi_467777a2abfd4ce1967536f9e44c2276_Out_3.xx), _Multiply_fa06a662967144269ae74ba3b4b6825c_Out_2);
            float4 _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0 = SAMPLE_TEXTURE2D(_Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0.tex, _Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0.samplerstate, _Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0.GetTransformedUV(_Multiply_fa06a662967144269ae74ba3b4b6825c_Out_2));
            _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0);
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_R_4 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.r;
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_G_5 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.g;
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_B_6 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.b;
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_A_7 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.a;
            UnityTexture2D _Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0 = UnityBuildTexture2DStructNoScale(_Second_Normal);
            float2 _Property_f994634ef25f46e0bbb7777c3dadb5a6_Out_0 = _Second_Normal_Tile;
            float _Divide_2024d2b7d7094075bb3feaa67982fcb2_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, -25, _Divide_2024d2b7d7094075bb3feaa67982fcb2_Out_2);
            float2 _TilingAndOffset_75a104fa5a5149a5b946df7fd1f3f8b6_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_f994634ef25f46e0bbb7777c3dadb5a6_Out_0, (_Divide_2024d2b7d7094075bb3feaa67982fcb2_Out_2.xx), _TilingAndOffset_75a104fa5a5149a5b946df7fd1f3f8b6_Out_3);
            float _Property_9b1f2a6be1a34f95bcb01a67c24c7fd7_Out_0 = _Second_Normal_Speed;
            float _Multiply_0f59000213ec4c6683ebe88920280f10_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9b1f2a6be1a34f95bcb01a67c24c7fd7_Out_0, _Multiply_0f59000213ec4c6683ebe88920280f10_Out_2);
            float _Voronoi_3738394378e24709a5873a6606cc6f3e_Out_3;
            float _Voronoi_3738394378e24709a5873a6606cc6f3e_Cells_4;
            Unity_Voronoi_float((_Multiply_0f59000213ec4c6683ebe88920280f10_Out_2.xx), 0.1, 0.01, _Voronoi_3738394378e24709a5873a6606cc6f3e_Out_3, _Voronoi_3738394378e24709a5873a6606cc6f3e_Cells_4);
            float2 _Multiply_5653e08b7cdb40dfa0fd755420c69c82_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_75a104fa5a5149a5b946df7fd1f3f8b6_Out_3, (_Voronoi_3738394378e24709a5873a6606cc6f3e_Out_3.xx), _Multiply_5653e08b7cdb40dfa0fd755420c69c82_Out_2);
            float4 _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0 = SAMPLE_TEXTURE2D(_Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0.tex, _Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0.samplerstate, _Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0.GetTransformedUV(_Multiply_5653e08b7cdb40dfa0fd755420c69c82_Out_2));
            _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0);
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_R_4 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.r;
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_G_5 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.g;
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_B_6 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.b;
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_A_7 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.a;
            float4 _Add_1167af1105f042b29ed2f1c382322709_Out_2;
            Unity_Add_float4(_SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0, _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0, _Add_1167af1105f042b29ed2f1c382322709_Out_2);
            float _Property_faf0138af8284ee18af730107ac28d91_Out_0 = _Normal_Strength;
            float _Lerp_e9f5f2254c63485bbf60161c27089f6c_Out_3;
            Unity_Lerp_float(0, _Property_faf0138af8284ee18af730107ac28d91_Out_0, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3, _Lerp_e9f5f2254c63485bbf60161c27089f6c_Out_3);
            float3 _NormalStrength_35691fd6222d4f3797055369fd967340_Out_2;
            Unity_NormalStrength_float((_Add_1167af1105f042b29ed2f1c382322709_Out_2.xyz), _Lerp_e9f5f2254c63485bbf60161c27089f6c_Out_3, _NormalStrength_35691fd6222d4f3797055369fd967340_Out_2);
            float4 _Property_b89a6f497f904ecebcb204224f6204a3_Out_0 = _Highlight_Color;
            float _Property_1e0453f5ed0946b291991855928ab8c9_Out_0 = _Highlight_Strength;
            float4 _Multiply_4464f97133ef419683675ba4b5d96ce2_Out_2;
            Unity_Multiply_float4_float4(_Property_b89a6f497f904ecebcb204224f6204a3_Out_0, (_Property_1e0453f5ed0946b291991855928ab8c9_Out_0.xxxx), _Multiply_4464f97133ef419683675ba4b5d96ce2_Out_2);
            float _Property_de94933959de451bbb82517c41b560cb_Out_0 = _Metalic;
            float _Property_8a2c01afc51445358940fa27b5c1c89e_Out_0 = _Smoothness;
            UnityTexture2D _Property_dec3e33ded004516a5ad056133c1b58e_Out_0 = UnityBuildTexture2DStructNoScale(_Ripple_Texture_Ambient_Occlusion);
            float2 _Property_530b0cba26934bd18c92b77aa80c6286_Out_0 = _Ripple_Tile;
            float2 _TilingAndOffset_4fda776a90e24c17bc0209d30c2c0b3e_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_530b0cba26934bd18c92b77aa80c6286_Out_0, float2 (0, 0), _TilingAndOffset_4fda776a90e24c17bc0209d30c2c0b3e_Out_3);
            float _Property_8fc20fcbc2d949d8b175eecee5d0746a_Out_0 = _Ripple_Speed;
            float _Multiply_25046a0a489442a0bf3026055fa09c56_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_8fc20fcbc2d949d8b175eecee5d0746a_Out_0, _Multiply_25046a0a489442a0bf3026055fa09c56_Out_2);
            float _Voronoi_b7697bc2164a48b9a16ec45afa015839_Out_3;
            float _Voronoi_b7697bc2164a48b9a16ec45afa015839_Cells_4;
            Unity_Voronoi_float((_Multiply_25046a0a489442a0bf3026055fa09c56_Out_2.xx), 0.1, 0.01, _Voronoi_b7697bc2164a48b9a16ec45afa015839_Out_3, _Voronoi_b7697bc2164a48b9a16ec45afa015839_Cells_4);
            float2 _Multiply_076b83e253344a7386496a7cd0de2587_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_4fda776a90e24c17bc0209d30c2c0b3e_Out_3, (_Voronoi_b7697bc2164a48b9a16ec45afa015839_Out_3.xx), _Multiply_076b83e253344a7386496a7cd0de2587_Out_2);
            float4 _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0 = SAMPLE_TEXTURE2D(_Property_dec3e33ded004516a5ad056133c1b58e_Out_0.tex, _Property_dec3e33ded004516a5ad056133c1b58e_Out_0.samplerstate, _Property_dec3e33ded004516a5ad056133c1b58e_Out_0.GetTransformedUV(_Multiply_076b83e253344a7386496a7cd0de2587_Out_2));
            float _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_R_4 = _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0.r;
            float _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_G_5 = _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0.g;
            float _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_B_6 = _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0.b;
            float _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_A_7 = _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0.a;
            float _Property_ff001ec7d20c49c79f2f4b2d70794ef7_Out_0 = _Ripple_Opacity;
            float4 _Add_f8c7532823d74818bc903a41930674af_Out_2;
            Unity_Add_float4(_SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0, (_Property_ff001ec7d20c49c79f2f4b2d70794ef7_Out_0.xxxx), _Add_f8c7532823d74818bc903a41930674af_Out_2);
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_R_1 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[0];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_G_2 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[1];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_B_3 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[2];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[3];
            surface.BaseColor = (_Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3.xyz);
            surface.NormalTS = _NormalStrength_35691fd6222d4f3797055369fd967340_Out_2;
            surface.Emission = (_Multiply_4464f97133ef419683675ba4b5d96ce2_Out_2.xyz);
            surface.Metallic = _Property_de94933959de451bbb82517c41b560cb_Out_0;
            surface.Smoothness = _Property_8a2c01afc51445358940fa27b5c1c89e_Out_0;
            surface.Occlusion = (_Add_f8c7532823d74818bc903a41930674af_Out_2).x;
            surface.Alpha = _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
        {
            result.vertex     = float4(attributes.positionOS, 1);
            result.tangent    = attributes.tangentOS;
            result.normal     = attributes.normalOS;
            result.texcoord   = attributes.uv0;
            result.texcoord1  = attributes.uv1;
            result.vertex     = float4(vertexDescription.Position, 1);
            result.normal     = vertexDescription.Normal;
            result.tangent    = float4(vertexDescription.Tangent, 0);
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
        }
        
        void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
        {
            result.pos = varyings.positionCS;
            result.worldPos = varyings.positionWS;
            result.worldNormal = varyings.normalWS;
            result.viewDir = varyings.viewDirectionWS;
            // World Tangent isn't an available input on v2f_surf
        
            result._ShadowCoord = varyings.shadowCoord;
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            result.sh = varyings.sh;
            #endif
            #if defined(LIGHTMAP_ON)
            result.lmap.xy = varyings.lightmapUV;
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogCoord = varyings.fogFactorAndVertexLight.x;
                COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
        }
        
        void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
        {
            result.positionCS = surfVertex.pos;
            result.positionWS = surfVertex.worldPos;
            result.normalWS = surfVertex.worldNormal;
            // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
            // World Tangent isn't an available input on v2f_surf
            result.shadowCoord = surfVertex._ShadowCoord;
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            result.sh = surfVertex.sh;
            #endif
            #if defined(LIGHTMAP_ON)
            result.lightmapUV = surfVertex.lmap.xy;
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
        ENDHLSL
        }
        Pass
        {
            Name "BuiltIn ForwardAdd"
            Tags
            {
                "LightMode" = "ForwardAdd"
            }
        
        // Render State
        Blend SrcAlpha One
        ZWrite Off
        ColorMask RGB
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.0
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma multi_compile_fwdadd_fullshadows
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
        #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        // GraphKeywords: <None>
        
        // Defines
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD_ADD
        #define BUILTIN_TARGET_API 1
        #define _BUILTIN_SURFACE_TYPE_TRANSPARENT 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #endif
        #ifdef _BUILTIN_ALPHATEST_ON
        #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
        #endif
        #ifdef _BUILTIN_AlphaClip
        #define _AlphaClip _BUILTIN_AlphaClip
        #endif
        #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
        #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
        #endif
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float3 viewDirectionWS;
            #if defined(LIGHTMAP_ON)
             float2 lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
             float4 shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float3 interp4 : INTERP4;
             float2 interp5 : INTERP5;
             float3 interp6 : INTERP6;
             float4 interp7 : INTERP7;
             float4 interp8 : INTERP8;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp6.xyz =  input.sh;
            #endif
            output.interp7.xyzw =  input.fogFactorAndVertexLight;
            output.interp8.xyzw =  input.shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if defined(LIGHTMAP_ON)
            output.lightmapUV = input.interp5.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp6.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp7.xyzw;
            output.shadowCoord = input.interp8.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Depth;
        float _Strength;
        float4 _Deep_Water_Color;
        float4 _Shadow_Water_Color;
        float4 _Main_Normal_TexelSize;
        float4 _Second_Normal_TexelSize;
        float _Normal_Strength;
        float _Smoothness;
        float _Displacement;
        float _Wave_Strength;
        float2 _Main_Normal_Tile;
        float2 _Second_Normal_Tile;
        float4 _Highlight_Color;
        float _Highlight_Strength;
        float _Metalic;
        float _Ripple_Speed;
        float4 _Ripple_Texture_Ambient_Occlusion_TexelSize;
        float2 _Ripple_Tile;
        float _Ripple_Opacity;
        float _Main_Normal_Speed;
        float _Second_Normal_Speed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Normal);
        SAMPLER(sampler_Main_Normal);
        TEXTURE2D(_Second_Normal);
        SAMPLER(sampler_Second_Normal);
        TEXTURE2D(_Ripple_Texture_Ambient_Occlusion);
        SAMPLER(sampler_Ripple_Texture_Ambient_Occlusion);
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1 = IN.ObjectSpacePosition[0];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_G_2 = IN.ObjectSpacePosition[1];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3 = IN.ObjectSpacePosition[2];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_A_4 = 0;
            float _Property_0357d5684c5741b98876c08275c12954_Out_0 = _Displacement;
            float _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 100, _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2);
            float2 _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2.xx), _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3);
            float _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0 = _Wave_Strength;
            float _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3, _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2);
            float _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2;
            Unity_Multiply_float_float(_Property_0357d5684c5741b98876c08275c12954_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2);
            float4 _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4;
            float3 _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            float2 _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6;
            Unity_Combine_float(_Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2, _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3, 0, _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4, _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5, _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6);
            description.Position = _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0 = _Shadow_Water_Color;
            float4 _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0 = _Deep_Water_Color;
            float _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1);
            float _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2;
            Unity_Multiply_float_float(_SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1, _ProjectionParams.z, _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2);
            float4 _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0 = IN.ScreenPosition;
            float _Split_64cd857bd1d64117a2a108ff88c0779c_R_1 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[0];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_G_2 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[1];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_B_3 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[2];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_A_4 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[3];
            float _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0 = _Depth;
            float _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2;
            Unity_Add_float(_Split_64cd857bd1d64117a2a108ff88c0779c_A_4, _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2);
            float _Subtract_1476eb191c244932ad0606241d596d33_Out_2;
            Unity_Subtract_float(_Multiply_983da0bb704c49f88acdd897af4e2942_Out_2, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2, _Subtract_1476eb191c244932ad0606241d596d33_Out_2);
            float _Property_b8a1367319b64842bc06551f0b38404a_Out_0 = _Strength;
            float _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2;
            Unity_Multiply_float_float(_Subtract_1476eb191c244932ad0606241d596d33_Out_2, _Property_b8a1367319b64842bc06551f0b38404a_Out_0, _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2);
            float _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3;
            Unity_Clamp_float(_Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2, 0, 1, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3);
            float4 _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3;
            Unity_Lerp_float4(_Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0, _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0, (_Clamp_b1c08e0420874f2387bc1673d1678257_Out_3.xxxx), _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3);
            UnityTexture2D _Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0 = UnityBuildTexture2DStructNoScale(_Main_Normal);
            float2 _Property_d1e6d170425c4c18856710c0538aa517_Out_0 = _Main_Normal_Tile;
            float _Divide_2732be57b2a549159a4dabc5f8f137c6_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 50, _Divide_2732be57b2a549159a4dabc5f8f137c6_Out_2);
            float2 _TilingAndOffset_a27ba90f79b3460abf165145741ba6c0_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_d1e6d170425c4c18856710c0538aa517_Out_0, (_Divide_2732be57b2a549159a4dabc5f8f137c6_Out_2.xx), _TilingAndOffset_a27ba90f79b3460abf165145741ba6c0_Out_3);
            float _Property_5c1fb20a3d6b4d3eaafd354baadf9609_Out_0 = _Main_Normal_Speed;
            float _Multiply_b74cc2e778c145c3a7401ac4cd2a4b0b_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_5c1fb20a3d6b4d3eaafd354baadf9609_Out_0, _Multiply_b74cc2e778c145c3a7401ac4cd2a4b0b_Out_2);
            float _Voronoi_467777a2abfd4ce1967536f9e44c2276_Out_3;
            float _Voronoi_467777a2abfd4ce1967536f9e44c2276_Cells_4;
            Unity_Voronoi_float((_Multiply_b74cc2e778c145c3a7401ac4cd2a4b0b_Out_2.xx), 0.1, 0.01, _Voronoi_467777a2abfd4ce1967536f9e44c2276_Out_3, _Voronoi_467777a2abfd4ce1967536f9e44c2276_Cells_4);
            float2 _Multiply_fa06a662967144269ae74ba3b4b6825c_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_a27ba90f79b3460abf165145741ba6c0_Out_3, (_Voronoi_467777a2abfd4ce1967536f9e44c2276_Out_3.xx), _Multiply_fa06a662967144269ae74ba3b4b6825c_Out_2);
            float4 _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0 = SAMPLE_TEXTURE2D(_Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0.tex, _Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0.samplerstate, _Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0.GetTransformedUV(_Multiply_fa06a662967144269ae74ba3b4b6825c_Out_2));
            _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0);
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_R_4 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.r;
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_G_5 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.g;
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_B_6 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.b;
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_A_7 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.a;
            UnityTexture2D _Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0 = UnityBuildTexture2DStructNoScale(_Second_Normal);
            float2 _Property_f994634ef25f46e0bbb7777c3dadb5a6_Out_0 = _Second_Normal_Tile;
            float _Divide_2024d2b7d7094075bb3feaa67982fcb2_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, -25, _Divide_2024d2b7d7094075bb3feaa67982fcb2_Out_2);
            float2 _TilingAndOffset_75a104fa5a5149a5b946df7fd1f3f8b6_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_f994634ef25f46e0bbb7777c3dadb5a6_Out_0, (_Divide_2024d2b7d7094075bb3feaa67982fcb2_Out_2.xx), _TilingAndOffset_75a104fa5a5149a5b946df7fd1f3f8b6_Out_3);
            float _Property_9b1f2a6be1a34f95bcb01a67c24c7fd7_Out_0 = _Second_Normal_Speed;
            float _Multiply_0f59000213ec4c6683ebe88920280f10_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9b1f2a6be1a34f95bcb01a67c24c7fd7_Out_0, _Multiply_0f59000213ec4c6683ebe88920280f10_Out_2);
            float _Voronoi_3738394378e24709a5873a6606cc6f3e_Out_3;
            float _Voronoi_3738394378e24709a5873a6606cc6f3e_Cells_4;
            Unity_Voronoi_float((_Multiply_0f59000213ec4c6683ebe88920280f10_Out_2.xx), 0.1, 0.01, _Voronoi_3738394378e24709a5873a6606cc6f3e_Out_3, _Voronoi_3738394378e24709a5873a6606cc6f3e_Cells_4);
            float2 _Multiply_5653e08b7cdb40dfa0fd755420c69c82_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_75a104fa5a5149a5b946df7fd1f3f8b6_Out_3, (_Voronoi_3738394378e24709a5873a6606cc6f3e_Out_3.xx), _Multiply_5653e08b7cdb40dfa0fd755420c69c82_Out_2);
            float4 _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0 = SAMPLE_TEXTURE2D(_Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0.tex, _Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0.samplerstate, _Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0.GetTransformedUV(_Multiply_5653e08b7cdb40dfa0fd755420c69c82_Out_2));
            _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0);
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_R_4 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.r;
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_G_5 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.g;
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_B_6 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.b;
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_A_7 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.a;
            float4 _Add_1167af1105f042b29ed2f1c382322709_Out_2;
            Unity_Add_float4(_SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0, _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0, _Add_1167af1105f042b29ed2f1c382322709_Out_2);
            float _Property_faf0138af8284ee18af730107ac28d91_Out_0 = _Normal_Strength;
            float _Lerp_e9f5f2254c63485bbf60161c27089f6c_Out_3;
            Unity_Lerp_float(0, _Property_faf0138af8284ee18af730107ac28d91_Out_0, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3, _Lerp_e9f5f2254c63485bbf60161c27089f6c_Out_3);
            float3 _NormalStrength_35691fd6222d4f3797055369fd967340_Out_2;
            Unity_NormalStrength_float((_Add_1167af1105f042b29ed2f1c382322709_Out_2.xyz), _Lerp_e9f5f2254c63485bbf60161c27089f6c_Out_3, _NormalStrength_35691fd6222d4f3797055369fd967340_Out_2);
            float4 _Property_b89a6f497f904ecebcb204224f6204a3_Out_0 = _Highlight_Color;
            float _Property_1e0453f5ed0946b291991855928ab8c9_Out_0 = _Highlight_Strength;
            float4 _Multiply_4464f97133ef419683675ba4b5d96ce2_Out_2;
            Unity_Multiply_float4_float4(_Property_b89a6f497f904ecebcb204224f6204a3_Out_0, (_Property_1e0453f5ed0946b291991855928ab8c9_Out_0.xxxx), _Multiply_4464f97133ef419683675ba4b5d96ce2_Out_2);
            float _Property_de94933959de451bbb82517c41b560cb_Out_0 = _Metalic;
            float _Property_8a2c01afc51445358940fa27b5c1c89e_Out_0 = _Smoothness;
            UnityTexture2D _Property_dec3e33ded004516a5ad056133c1b58e_Out_0 = UnityBuildTexture2DStructNoScale(_Ripple_Texture_Ambient_Occlusion);
            float2 _Property_530b0cba26934bd18c92b77aa80c6286_Out_0 = _Ripple_Tile;
            float2 _TilingAndOffset_4fda776a90e24c17bc0209d30c2c0b3e_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_530b0cba26934bd18c92b77aa80c6286_Out_0, float2 (0, 0), _TilingAndOffset_4fda776a90e24c17bc0209d30c2c0b3e_Out_3);
            float _Property_8fc20fcbc2d949d8b175eecee5d0746a_Out_0 = _Ripple_Speed;
            float _Multiply_25046a0a489442a0bf3026055fa09c56_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_8fc20fcbc2d949d8b175eecee5d0746a_Out_0, _Multiply_25046a0a489442a0bf3026055fa09c56_Out_2);
            float _Voronoi_b7697bc2164a48b9a16ec45afa015839_Out_3;
            float _Voronoi_b7697bc2164a48b9a16ec45afa015839_Cells_4;
            Unity_Voronoi_float((_Multiply_25046a0a489442a0bf3026055fa09c56_Out_2.xx), 0.1, 0.01, _Voronoi_b7697bc2164a48b9a16ec45afa015839_Out_3, _Voronoi_b7697bc2164a48b9a16ec45afa015839_Cells_4);
            float2 _Multiply_076b83e253344a7386496a7cd0de2587_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_4fda776a90e24c17bc0209d30c2c0b3e_Out_3, (_Voronoi_b7697bc2164a48b9a16ec45afa015839_Out_3.xx), _Multiply_076b83e253344a7386496a7cd0de2587_Out_2);
            float4 _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0 = SAMPLE_TEXTURE2D(_Property_dec3e33ded004516a5ad056133c1b58e_Out_0.tex, _Property_dec3e33ded004516a5ad056133c1b58e_Out_0.samplerstate, _Property_dec3e33ded004516a5ad056133c1b58e_Out_0.GetTransformedUV(_Multiply_076b83e253344a7386496a7cd0de2587_Out_2));
            float _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_R_4 = _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0.r;
            float _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_G_5 = _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0.g;
            float _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_B_6 = _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0.b;
            float _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_A_7 = _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0.a;
            float _Property_ff001ec7d20c49c79f2f4b2d70794ef7_Out_0 = _Ripple_Opacity;
            float4 _Add_f8c7532823d74818bc903a41930674af_Out_2;
            Unity_Add_float4(_SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0, (_Property_ff001ec7d20c49c79f2f4b2d70794ef7_Out_0.xxxx), _Add_f8c7532823d74818bc903a41930674af_Out_2);
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_R_1 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[0];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_G_2 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[1];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_B_3 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[2];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[3];
            surface.BaseColor = (_Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3.xyz);
            surface.NormalTS = _NormalStrength_35691fd6222d4f3797055369fd967340_Out_2;
            surface.Emission = (_Multiply_4464f97133ef419683675ba4b5d96ce2_Out_2.xyz);
            surface.Metallic = _Property_de94933959de451bbb82517c41b560cb_Out_0;
            surface.Smoothness = _Property_8a2c01afc51445358940fa27b5c1c89e_Out_0;
            surface.Occlusion = (_Add_f8c7532823d74818bc903a41930674af_Out_2).x;
            surface.Alpha = _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
        {
            result.vertex     = float4(attributes.positionOS, 1);
            result.tangent    = attributes.tangentOS;
            result.normal     = attributes.normalOS;
            result.texcoord   = attributes.uv0;
            result.texcoord1  = attributes.uv1;
            result.vertex     = float4(vertexDescription.Position, 1);
            result.normal     = vertexDescription.Normal;
            result.tangent    = float4(vertexDescription.Tangent, 0);
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
        }
        
        void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
        {
            result.pos = varyings.positionCS;
            result.worldPos = varyings.positionWS;
            result.worldNormal = varyings.normalWS;
            result.viewDir = varyings.viewDirectionWS;
            // World Tangent isn't an available input on v2f_surf
        
            result._ShadowCoord = varyings.shadowCoord;
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            result.sh = varyings.sh;
            #endif
            #if defined(LIGHTMAP_ON)
            result.lmap.xy = varyings.lightmapUV;
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogCoord = varyings.fogFactorAndVertexLight.x;
                COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
        }
        
        void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
        {
            result.positionCS = surfVertex.pos;
            result.positionWS = surfVertex.worldPos;
            result.normalWS = surfVertex.worldNormal;
            // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
            // World Tangent isn't an available input on v2f_surf
            result.shadowCoord = surfVertex._ShadowCoord;
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            result.sh = surfVertex.sh;
            #endif
            #if defined(LIGHTMAP_ON)
            result.lightmapUV = surfVertex.lmap.xy;
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/PBRForwardAddPass.hlsl"
        
        ENDHLSL
        }
        Pass
        {
            Name "BuiltIn Deferred"
            Tags
            {
                "LightMode" = "Deferred"
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        ColorMask RGB
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma multi_compile_instancing
        #pragma exclude_renderers nomrt
        #pragma multi_compile_prepassfinal
        #pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile _ _GBUFFER_NORMALS_OCT
        // GraphKeywords: <None>
        
        // Defines
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEFERRED
        #define BUILTIN_TARGET_API 1
        #define _BUILTIN_SURFACE_TYPE_TRANSPARENT 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #endif
        #ifdef _BUILTIN_ALPHATEST_ON
        #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
        #endif
        #ifdef _BUILTIN_AlphaClip
        #define _AlphaClip _BUILTIN_AlphaClip
        #endif
        #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
        #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
        #endif
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float3 viewDirectionWS;
            #if defined(LIGHTMAP_ON)
             float2 lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
             float4 shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float3 interp4 : INTERP4;
             float2 interp5 : INTERP5;
             float3 interp6 : INTERP6;
             float4 interp7 : INTERP7;
             float4 interp8 : INTERP8;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp6.xyz =  input.sh;
            #endif
            output.interp7.xyzw =  input.fogFactorAndVertexLight;
            output.interp8.xyzw =  input.shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if defined(LIGHTMAP_ON)
            output.lightmapUV = input.interp5.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp6.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp7.xyzw;
            output.shadowCoord = input.interp8.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Depth;
        float _Strength;
        float4 _Deep_Water_Color;
        float4 _Shadow_Water_Color;
        float4 _Main_Normal_TexelSize;
        float4 _Second_Normal_TexelSize;
        float _Normal_Strength;
        float _Smoothness;
        float _Displacement;
        float _Wave_Strength;
        float2 _Main_Normal_Tile;
        float2 _Second_Normal_Tile;
        float4 _Highlight_Color;
        float _Highlight_Strength;
        float _Metalic;
        float _Ripple_Speed;
        float4 _Ripple_Texture_Ambient_Occlusion_TexelSize;
        float2 _Ripple_Tile;
        float _Ripple_Opacity;
        float _Main_Normal_Speed;
        float _Second_Normal_Speed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Normal);
        SAMPLER(sampler_Main_Normal);
        TEXTURE2D(_Second_Normal);
        SAMPLER(sampler_Second_Normal);
        TEXTURE2D(_Ripple_Texture_Ambient_Occlusion);
        SAMPLER(sampler_Ripple_Texture_Ambient_Occlusion);
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1 = IN.ObjectSpacePosition[0];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_G_2 = IN.ObjectSpacePosition[1];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3 = IN.ObjectSpacePosition[2];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_A_4 = 0;
            float _Property_0357d5684c5741b98876c08275c12954_Out_0 = _Displacement;
            float _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 100, _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2);
            float2 _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2.xx), _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3);
            float _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0 = _Wave_Strength;
            float _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3, _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2);
            float _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2;
            Unity_Multiply_float_float(_Property_0357d5684c5741b98876c08275c12954_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2);
            float4 _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4;
            float3 _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            float2 _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6;
            Unity_Combine_float(_Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2, _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3, 0, _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4, _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5, _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6);
            description.Position = _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0 = _Shadow_Water_Color;
            float4 _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0 = _Deep_Water_Color;
            float _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1);
            float _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2;
            Unity_Multiply_float_float(_SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1, _ProjectionParams.z, _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2);
            float4 _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0 = IN.ScreenPosition;
            float _Split_64cd857bd1d64117a2a108ff88c0779c_R_1 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[0];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_G_2 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[1];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_B_3 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[2];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_A_4 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[3];
            float _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0 = _Depth;
            float _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2;
            Unity_Add_float(_Split_64cd857bd1d64117a2a108ff88c0779c_A_4, _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2);
            float _Subtract_1476eb191c244932ad0606241d596d33_Out_2;
            Unity_Subtract_float(_Multiply_983da0bb704c49f88acdd897af4e2942_Out_2, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2, _Subtract_1476eb191c244932ad0606241d596d33_Out_2);
            float _Property_b8a1367319b64842bc06551f0b38404a_Out_0 = _Strength;
            float _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2;
            Unity_Multiply_float_float(_Subtract_1476eb191c244932ad0606241d596d33_Out_2, _Property_b8a1367319b64842bc06551f0b38404a_Out_0, _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2);
            float _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3;
            Unity_Clamp_float(_Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2, 0, 1, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3);
            float4 _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3;
            Unity_Lerp_float4(_Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0, _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0, (_Clamp_b1c08e0420874f2387bc1673d1678257_Out_3.xxxx), _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3);
            UnityTexture2D _Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0 = UnityBuildTexture2DStructNoScale(_Main_Normal);
            float2 _Property_d1e6d170425c4c18856710c0538aa517_Out_0 = _Main_Normal_Tile;
            float _Divide_2732be57b2a549159a4dabc5f8f137c6_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 50, _Divide_2732be57b2a549159a4dabc5f8f137c6_Out_2);
            float2 _TilingAndOffset_a27ba90f79b3460abf165145741ba6c0_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_d1e6d170425c4c18856710c0538aa517_Out_0, (_Divide_2732be57b2a549159a4dabc5f8f137c6_Out_2.xx), _TilingAndOffset_a27ba90f79b3460abf165145741ba6c0_Out_3);
            float _Property_5c1fb20a3d6b4d3eaafd354baadf9609_Out_0 = _Main_Normal_Speed;
            float _Multiply_b74cc2e778c145c3a7401ac4cd2a4b0b_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_5c1fb20a3d6b4d3eaafd354baadf9609_Out_0, _Multiply_b74cc2e778c145c3a7401ac4cd2a4b0b_Out_2);
            float _Voronoi_467777a2abfd4ce1967536f9e44c2276_Out_3;
            float _Voronoi_467777a2abfd4ce1967536f9e44c2276_Cells_4;
            Unity_Voronoi_float((_Multiply_b74cc2e778c145c3a7401ac4cd2a4b0b_Out_2.xx), 0.1, 0.01, _Voronoi_467777a2abfd4ce1967536f9e44c2276_Out_3, _Voronoi_467777a2abfd4ce1967536f9e44c2276_Cells_4);
            float2 _Multiply_fa06a662967144269ae74ba3b4b6825c_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_a27ba90f79b3460abf165145741ba6c0_Out_3, (_Voronoi_467777a2abfd4ce1967536f9e44c2276_Out_3.xx), _Multiply_fa06a662967144269ae74ba3b4b6825c_Out_2);
            float4 _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0 = SAMPLE_TEXTURE2D(_Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0.tex, _Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0.samplerstate, _Property_2f310bab103f4b6aaa6431e048f6fd2e_Out_0.GetTransformedUV(_Multiply_fa06a662967144269ae74ba3b4b6825c_Out_2));
            _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0);
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_R_4 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.r;
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_G_5 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.g;
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_B_6 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.b;
            float _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_A_7 = _SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0.a;
            UnityTexture2D _Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0 = UnityBuildTexture2DStructNoScale(_Second_Normal);
            float2 _Property_f994634ef25f46e0bbb7777c3dadb5a6_Out_0 = _Second_Normal_Tile;
            float _Divide_2024d2b7d7094075bb3feaa67982fcb2_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, -25, _Divide_2024d2b7d7094075bb3feaa67982fcb2_Out_2);
            float2 _TilingAndOffset_75a104fa5a5149a5b946df7fd1f3f8b6_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_f994634ef25f46e0bbb7777c3dadb5a6_Out_0, (_Divide_2024d2b7d7094075bb3feaa67982fcb2_Out_2.xx), _TilingAndOffset_75a104fa5a5149a5b946df7fd1f3f8b6_Out_3);
            float _Property_9b1f2a6be1a34f95bcb01a67c24c7fd7_Out_0 = _Second_Normal_Speed;
            float _Multiply_0f59000213ec4c6683ebe88920280f10_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9b1f2a6be1a34f95bcb01a67c24c7fd7_Out_0, _Multiply_0f59000213ec4c6683ebe88920280f10_Out_2);
            float _Voronoi_3738394378e24709a5873a6606cc6f3e_Out_3;
            float _Voronoi_3738394378e24709a5873a6606cc6f3e_Cells_4;
            Unity_Voronoi_float((_Multiply_0f59000213ec4c6683ebe88920280f10_Out_2.xx), 0.1, 0.01, _Voronoi_3738394378e24709a5873a6606cc6f3e_Out_3, _Voronoi_3738394378e24709a5873a6606cc6f3e_Cells_4);
            float2 _Multiply_5653e08b7cdb40dfa0fd755420c69c82_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_75a104fa5a5149a5b946df7fd1f3f8b6_Out_3, (_Voronoi_3738394378e24709a5873a6606cc6f3e_Out_3.xx), _Multiply_5653e08b7cdb40dfa0fd755420c69c82_Out_2);
            float4 _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0 = SAMPLE_TEXTURE2D(_Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0.tex, _Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0.samplerstate, _Property_b48e0265002440a9b6a7d5d9b80a55cd_Out_0.GetTransformedUV(_Multiply_5653e08b7cdb40dfa0fd755420c69c82_Out_2));
            _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0);
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_R_4 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.r;
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_G_5 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.g;
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_B_6 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.b;
            float _SampleTexture2D_5a528945c33c45c390f417ea64f21768_A_7 = _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0.a;
            float4 _Add_1167af1105f042b29ed2f1c382322709_Out_2;
            Unity_Add_float4(_SampleTexture2D_df4f48c56b034b00bb0a3cc041ca9b3a_RGBA_0, _SampleTexture2D_5a528945c33c45c390f417ea64f21768_RGBA_0, _Add_1167af1105f042b29ed2f1c382322709_Out_2);
            float _Property_faf0138af8284ee18af730107ac28d91_Out_0 = _Normal_Strength;
            float _Lerp_e9f5f2254c63485bbf60161c27089f6c_Out_3;
            Unity_Lerp_float(0, _Property_faf0138af8284ee18af730107ac28d91_Out_0, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3, _Lerp_e9f5f2254c63485bbf60161c27089f6c_Out_3);
            float3 _NormalStrength_35691fd6222d4f3797055369fd967340_Out_2;
            Unity_NormalStrength_float((_Add_1167af1105f042b29ed2f1c382322709_Out_2.xyz), _Lerp_e9f5f2254c63485bbf60161c27089f6c_Out_3, _NormalStrength_35691fd6222d4f3797055369fd967340_Out_2);
            float4 _Property_b89a6f497f904ecebcb204224f6204a3_Out_0 = _Highlight_Color;
            float _Property_1e0453f5ed0946b291991855928ab8c9_Out_0 = _Highlight_Strength;
            float4 _Multiply_4464f97133ef419683675ba4b5d96ce2_Out_2;
            Unity_Multiply_float4_float4(_Property_b89a6f497f904ecebcb204224f6204a3_Out_0, (_Property_1e0453f5ed0946b291991855928ab8c9_Out_0.xxxx), _Multiply_4464f97133ef419683675ba4b5d96ce2_Out_2);
            float _Property_de94933959de451bbb82517c41b560cb_Out_0 = _Metalic;
            float _Property_8a2c01afc51445358940fa27b5c1c89e_Out_0 = _Smoothness;
            UnityTexture2D _Property_dec3e33ded004516a5ad056133c1b58e_Out_0 = UnityBuildTexture2DStructNoScale(_Ripple_Texture_Ambient_Occlusion);
            float2 _Property_530b0cba26934bd18c92b77aa80c6286_Out_0 = _Ripple_Tile;
            float2 _TilingAndOffset_4fda776a90e24c17bc0209d30c2c0b3e_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_530b0cba26934bd18c92b77aa80c6286_Out_0, float2 (0, 0), _TilingAndOffset_4fda776a90e24c17bc0209d30c2c0b3e_Out_3);
            float _Property_8fc20fcbc2d949d8b175eecee5d0746a_Out_0 = _Ripple_Speed;
            float _Multiply_25046a0a489442a0bf3026055fa09c56_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_8fc20fcbc2d949d8b175eecee5d0746a_Out_0, _Multiply_25046a0a489442a0bf3026055fa09c56_Out_2);
            float _Voronoi_b7697bc2164a48b9a16ec45afa015839_Out_3;
            float _Voronoi_b7697bc2164a48b9a16ec45afa015839_Cells_4;
            Unity_Voronoi_float((_Multiply_25046a0a489442a0bf3026055fa09c56_Out_2.xx), 0.1, 0.01, _Voronoi_b7697bc2164a48b9a16ec45afa015839_Out_3, _Voronoi_b7697bc2164a48b9a16ec45afa015839_Cells_4);
            float2 _Multiply_076b83e253344a7386496a7cd0de2587_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_4fda776a90e24c17bc0209d30c2c0b3e_Out_3, (_Voronoi_b7697bc2164a48b9a16ec45afa015839_Out_3.xx), _Multiply_076b83e253344a7386496a7cd0de2587_Out_2);
            float4 _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0 = SAMPLE_TEXTURE2D(_Property_dec3e33ded004516a5ad056133c1b58e_Out_0.tex, _Property_dec3e33ded004516a5ad056133c1b58e_Out_0.samplerstate, _Property_dec3e33ded004516a5ad056133c1b58e_Out_0.GetTransformedUV(_Multiply_076b83e253344a7386496a7cd0de2587_Out_2));
            float _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_R_4 = _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0.r;
            float _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_G_5 = _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0.g;
            float _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_B_6 = _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0.b;
            float _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_A_7 = _SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0.a;
            float _Property_ff001ec7d20c49c79f2f4b2d70794ef7_Out_0 = _Ripple_Opacity;
            float4 _Add_f8c7532823d74818bc903a41930674af_Out_2;
            Unity_Add_float4(_SampleTexture2D_0d72cb4b96c04acf92c0d84feaeae922_RGBA_0, (_Property_ff001ec7d20c49c79f2f4b2d70794ef7_Out_0.xxxx), _Add_f8c7532823d74818bc903a41930674af_Out_2);
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_R_1 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[0];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_G_2 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[1];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_B_3 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[2];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[3];
            surface.BaseColor = (_Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3.xyz);
            surface.NormalTS = _NormalStrength_35691fd6222d4f3797055369fd967340_Out_2;
            surface.Emission = (_Multiply_4464f97133ef419683675ba4b5d96ce2_Out_2.xyz);
            surface.Metallic = _Property_de94933959de451bbb82517c41b560cb_Out_0;
            surface.Smoothness = _Property_8a2c01afc51445358940fa27b5c1c89e_Out_0;
            surface.Occlusion = (_Add_f8c7532823d74818bc903a41930674af_Out_2).x;
            surface.Alpha = _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
        {
            result.vertex     = float4(attributes.positionOS, 1);
            result.tangent    = attributes.tangentOS;
            result.normal     = attributes.normalOS;
            result.texcoord   = attributes.uv0;
            result.texcoord1  = attributes.uv1;
            result.vertex     = float4(vertexDescription.Position, 1);
            result.normal     = vertexDescription.Normal;
            result.tangent    = float4(vertexDescription.Tangent, 0);
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
        }
        
        void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
        {
            result.pos = varyings.positionCS;
            result.worldPos = varyings.positionWS;
            result.worldNormal = varyings.normalWS;
            result.viewDir = varyings.viewDirectionWS;
            // World Tangent isn't an available input on v2f_surf
        
            result._ShadowCoord = varyings.shadowCoord;
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            result.sh = varyings.sh;
            #endif
            #if defined(LIGHTMAP_ON)
            result.lmap.xy = varyings.lightmapUV;
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogCoord = varyings.fogFactorAndVertexLight.x;
                COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
        }
        
        void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
        {
            result.positionCS = surfVertex.pos;
            result.positionWS = surfVertex.worldPos;
            result.normalWS = surfVertex.worldNormal;
            // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
            // World Tangent isn't an available input on v2f_surf
            result.shadowCoord = surfVertex._ShadowCoord;
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            result.sh = surfVertex.sh;
            #endif
            #if defined(LIGHTMAP_ON)
            result.lightmapUV = surfVertex.lmap.xy;
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/PBRDeferredPass.hlsl"
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.0
        #pragma multi_compile_shadowcaster
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        // GraphKeywords: <None>
        
        // Defines
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        #define BUILTIN_TARGET_API 1
        #define _BUILTIN_SURFACE_TYPE_TRANSPARENT 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #endif
        #ifdef _BUILTIN_ALPHATEST_ON
        #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
        #endif
        #ifdef _BUILTIN_AlphaClip
        #define _AlphaClip _BUILTIN_AlphaClip
        #endif
        #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
        #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
        #endif
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Depth;
        float _Strength;
        float4 _Deep_Water_Color;
        float4 _Shadow_Water_Color;
        float4 _Main_Normal_TexelSize;
        float4 _Second_Normal_TexelSize;
        float _Normal_Strength;
        float _Smoothness;
        float _Displacement;
        float _Wave_Strength;
        float2 _Main_Normal_Tile;
        float2 _Second_Normal_Tile;
        float4 _Highlight_Color;
        float _Highlight_Strength;
        float _Metalic;
        float _Ripple_Speed;
        float4 _Ripple_Texture_Ambient_Occlusion_TexelSize;
        float2 _Ripple_Tile;
        float _Ripple_Opacity;
        float _Main_Normal_Speed;
        float _Second_Normal_Speed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Normal);
        SAMPLER(sampler_Main_Normal);
        TEXTURE2D(_Second_Normal);
        SAMPLER(sampler_Second_Normal);
        TEXTURE2D(_Ripple_Texture_Ambient_Occlusion);
        SAMPLER(sampler_Ripple_Texture_Ambient_Occlusion);
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1 = IN.ObjectSpacePosition[0];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_G_2 = IN.ObjectSpacePosition[1];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3 = IN.ObjectSpacePosition[2];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_A_4 = 0;
            float _Property_0357d5684c5741b98876c08275c12954_Out_0 = _Displacement;
            float _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 100, _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2);
            float2 _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2.xx), _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3);
            float _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0 = _Wave_Strength;
            float _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3, _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2);
            float _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2;
            Unity_Multiply_float_float(_Property_0357d5684c5741b98876c08275c12954_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2);
            float4 _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4;
            float3 _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            float2 _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6;
            Unity_Combine_float(_Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2, _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3, 0, _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4, _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5, _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6);
            description.Position = _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0 = _Shadow_Water_Color;
            float4 _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0 = _Deep_Water_Color;
            float _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1);
            float _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2;
            Unity_Multiply_float_float(_SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1, _ProjectionParams.z, _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2);
            float4 _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0 = IN.ScreenPosition;
            float _Split_64cd857bd1d64117a2a108ff88c0779c_R_1 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[0];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_G_2 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[1];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_B_3 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[2];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_A_4 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[3];
            float _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0 = _Depth;
            float _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2;
            Unity_Add_float(_Split_64cd857bd1d64117a2a108ff88c0779c_A_4, _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2);
            float _Subtract_1476eb191c244932ad0606241d596d33_Out_2;
            Unity_Subtract_float(_Multiply_983da0bb704c49f88acdd897af4e2942_Out_2, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2, _Subtract_1476eb191c244932ad0606241d596d33_Out_2);
            float _Property_b8a1367319b64842bc06551f0b38404a_Out_0 = _Strength;
            float _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2;
            Unity_Multiply_float_float(_Subtract_1476eb191c244932ad0606241d596d33_Out_2, _Property_b8a1367319b64842bc06551f0b38404a_Out_0, _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2);
            float _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3;
            Unity_Clamp_float(_Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2, 0, 1, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3);
            float4 _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3;
            Unity_Lerp_float4(_Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0, _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0, (_Clamp_b1c08e0420874f2387bc1673d1678257_Out_3.xxxx), _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3);
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_R_1 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[0];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_G_2 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[1];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_B_3 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[2];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[3];
            surface.Alpha = _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
        {
            result.vertex     = float4(attributes.positionOS, 1);
            result.tangent    = attributes.tangentOS;
            result.normal     = attributes.normalOS;
            result.texcoord   = attributes.uv0;
            result.vertex     = float4(vertexDescription.Position, 1);
            result.normal     = vertexDescription.Normal;
            result.tangent    = float4(vertexDescription.Tangent, 0);
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
        }
        
        void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
        {
            result.pos = varyings.positionCS;
            result.worldPos = varyings.positionWS;
            // World Tangent isn't an available input on v2f_surf
        
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogCoord = varyings.fogFactorAndVertexLight.x;
                COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
        }
        
        void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
        {
            result.positionCS = surfVertex.pos;
            result.positionWS = surfVertex.worldPos;
            // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
            // World Tangent isn't an available input on v2f_surf
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.0
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
        // GraphKeywords: <None>
        
        // Defines
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define BUILTIN_TARGET_API 1
        #define _BUILTIN_SURFACE_TYPE_TRANSPARENT 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #endif
        #ifdef _BUILTIN_ALPHATEST_ON
        #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
        #endif
        #ifdef _BUILTIN_AlphaClip
        #define _AlphaClip _BUILTIN_AlphaClip
        #endif
        #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
        #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
        #endif
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Depth;
        float _Strength;
        float4 _Deep_Water_Color;
        float4 _Shadow_Water_Color;
        float4 _Main_Normal_TexelSize;
        float4 _Second_Normal_TexelSize;
        float _Normal_Strength;
        float _Smoothness;
        float _Displacement;
        float _Wave_Strength;
        float2 _Main_Normal_Tile;
        float2 _Second_Normal_Tile;
        float4 _Highlight_Color;
        float _Highlight_Strength;
        float _Metalic;
        float _Ripple_Speed;
        float4 _Ripple_Texture_Ambient_Occlusion_TexelSize;
        float2 _Ripple_Tile;
        float _Ripple_Opacity;
        float _Main_Normal_Speed;
        float _Second_Normal_Speed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Normal);
        SAMPLER(sampler_Main_Normal);
        TEXTURE2D(_Second_Normal);
        SAMPLER(sampler_Second_Normal);
        TEXTURE2D(_Ripple_Texture_Ambient_Occlusion);
        SAMPLER(sampler_Ripple_Texture_Ambient_Occlusion);
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1 = IN.ObjectSpacePosition[0];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_G_2 = IN.ObjectSpacePosition[1];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3 = IN.ObjectSpacePosition[2];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_A_4 = 0;
            float _Property_0357d5684c5741b98876c08275c12954_Out_0 = _Displacement;
            float _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 100, _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2);
            float2 _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2.xx), _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3);
            float _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0 = _Wave_Strength;
            float _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3, _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2);
            float _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2;
            Unity_Multiply_float_float(_Property_0357d5684c5741b98876c08275c12954_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2);
            float4 _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4;
            float3 _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            float2 _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6;
            Unity_Combine_float(_Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2, _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3, 0, _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4, _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5, _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6);
            description.Position = _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0 = _Shadow_Water_Color;
            float4 _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0 = _Deep_Water_Color;
            float _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1);
            float _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2;
            Unity_Multiply_float_float(_SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1, _ProjectionParams.z, _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2);
            float4 _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0 = IN.ScreenPosition;
            float _Split_64cd857bd1d64117a2a108ff88c0779c_R_1 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[0];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_G_2 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[1];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_B_3 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[2];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_A_4 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[3];
            float _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0 = _Depth;
            float _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2;
            Unity_Add_float(_Split_64cd857bd1d64117a2a108ff88c0779c_A_4, _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2);
            float _Subtract_1476eb191c244932ad0606241d596d33_Out_2;
            Unity_Subtract_float(_Multiply_983da0bb704c49f88acdd897af4e2942_Out_2, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2, _Subtract_1476eb191c244932ad0606241d596d33_Out_2);
            float _Property_b8a1367319b64842bc06551f0b38404a_Out_0 = _Strength;
            float _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2;
            Unity_Multiply_float_float(_Subtract_1476eb191c244932ad0606241d596d33_Out_2, _Property_b8a1367319b64842bc06551f0b38404a_Out_0, _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2);
            float _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3;
            Unity_Clamp_float(_Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2, 0, 1, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3);
            float4 _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3;
            Unity_Lerp_float4(_Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0, _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0, (_Clamp_b1c08e0420874f2387bc1673d1678257_Out_3.xxxx), _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3);
            float4 _Property_b89a6f497f904ecebcb204224f6204a3_Out_0 = _Highlight_Color;
            float _Property_1e0453f5ed0946b291991855928ab8c9_Out_0 = _Highlight_Strength;
            float4 _Multiply_4464f97133ef419683675ba4b5d96ce2_Out_2;
            Unity_Multiply_float4_float4(_Property_b89a6f497f904ecebcb204224f6204a3_Out_0, (_Property_1e0453f5ed0946b291991855928ab8c9_Out_0.xxxx), _Multiply_4464f97133ef419683675ba4b5d96ce2_Out_2);
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_R_1 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[0];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_G_2 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[1];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_B_3 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[2];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[3];
            surface.BaseColor = (_Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3.xyz);
            surface.Emission = (_Multiply_4464f97133ef419683675ba4b5d96ce2_Out_2.xyz);
            surface.Alpha = _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
        {
            result.vertex     = float4(attributes.positionOS, 1);
            result.tangent    = attributes.tangentOS;
            result.normal     = attributes.normalOS;
            result.texcoord   = attributes.uv0;
            result.texcoord1  = attributes.uv1;
            result.texcoord2  = attributes.uv2;
            result.vertex     = float4(vertexDescription.Position, 1);
            result.normal     = vertexDescription.Normal;
            result.tangent    = float4(vertexDescription.Tangent, 0);
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
        }
        
        void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
        {
            result.pos = varyings.positionCS;
            result.worldPos = varyings.positionWS;
            // World Tangent isn't an available input on v2f_surf
        
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogCoord = varyings.fogFactorAndVertexLight.x;
                COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
        }
        
        void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
        {
            result.positionCS = surfVertex.pos;
            result.positionWS = surfVertex.worldPos;
            // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
            // World Tangent isn't an available input on v2f_surf
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SceneSelectionPass
        #define BUILTIN_TARGET_API 1
        #define SCENESELECTIONPASS 1
        #define _BUILTIN_SURFACE_TYPE_TRANSPARENT 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #endif
        #ifdef _BUILTIN_ALPHATEST_ON
        #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
        #endif
        #ifdef _BUILTIN_AlphaClip
        #define _AlphaClip _BUILTIN_AlphaClip
        #endif
        #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
        #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
        #endif
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Depth;
        float _Strength;
        float4 _Deep_Water_Color;
        float4 _Shadow_Water_Color;
        float4 _Main_Normal_TexelSize;
        float4 _Second_Normal_TexelSize;
        float _Normal_Strength;
        float _Smoothness;
        float _Displacement;
        float _Wave_Strength;
        float2 _Main_Normal_Tile;
        float2 _Second_Normal_Tile;
        float4 _Highlight_Color;
        float _Highlight_Strength;
        float _Metalic;
        float _Ripple_Speed;
        float4 _Ripple_Texture_Ambient_Occlusion_TexelSize;
        float2 _Ripple_Tile;
        float _Ripple_Opacity;
        float _Main_Normal_Speed;
        float _Second_Normal_Speed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Normal);
        SAMPLER(sampler_Main_Normal);
        TEXTURE2D(_Second_Normal);
        SAMPLER(sampler_Second_Normal);
        TEXTURE2D(_Ripple_Texture_Ambient_Occlusion);
        SAMPLER(sampler_Ripple_Texture_Ambient_Occlusion);
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1 = IN.ObjectSpacePosition[0];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_G_2 = IN.ObjectSpacePosition[1];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3 = IN.ObjectSpacePosition[2];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_A_4 = 0;
            float _Property_0357d5684c5741b98876c08275c12954_Out_0 = _Displacement;
            float _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 100, _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2);
            float2 _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2.xx), _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3);
            float _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0 = _Wave_Strength;
            float _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3, _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2);
            float _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2;
            Unity_Multiply_float_float(_Property_0357d5684c5741b98876c08275c12954_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2);
            float4 _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4;
            float3 _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            float2 _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6;
            Unity_Combine_float(_Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2, _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3, 0, _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4, _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5, _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6);
            description.Position = _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0 = _Shadow_Water_Color;
            float4 _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0 = _Deep_Water_Color;
            float _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1);
            float _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2;
            Unity_Multiply_float_float(_SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1, _ProjectionParams.z, _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2);
            float4 _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0 = IN.ScreenPosition;
            float _Split_64cd857bd1d64117a2a108ff88c0779c_R_1 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[0];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_G_2 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[1];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_B_3 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[2];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_A_4 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[3];
            float _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0 = _Depth;
            float _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2;
            Unity_Add_float(_Split_64cd857bd1d64117a2a108ff88c0779c_A_4, _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2);
            float _Subtract_1476eb191c244932ad0606241d596d33_Out_2;
            Unity_Subtract_float(_Multiply_983da0bb704c49f88acdd897af4e2942_Out_2, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2, _Subtract_1476eb191c244932ad0606241d596d33_Out_2);
            float _Property_b8a1367319b64842bc06551f0b38404a_Out_0 = _Strength;
            float _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2;
            Unity_Multiply_float_float(_Subtract_1476eb191c244932ad0606241d596d33_Out_2, _Property_b8a1367319b64842bc06551f0b38404a_Out_0, _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2);
            float _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3;
            Unity_Clamp_float(_Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2, 0, 1, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3);
            float4 _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3;
            Unity_Lerp_float4(_Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0, _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0, (_Clamp_b1c08e0420874f2387bc1673d1678257_Out_3.xxxx), _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3);
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_R_1 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[0];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_G_2 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[1];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_B_3 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[2];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[3];
            surface.Alpha = _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
        {
            result.vertex     = float4(attributes.positionOS, 1);
            result.tangent    = attributes.tangentOS;
            result.normal     = attributes.normalOS;
            result.texcoord   = attributes.uv0;
            result.vertex     = float4(vertexDescription.Position, 1);
            result.normal     = vertexDescription.Normal;
            result.tangent    = float4(vertexDescription.Tangent, 0);
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
        }
        
        void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
        {
            result.pos = varyings.positionCS;
            result.worldPos = varyings.positionWS;
            // World Tangent isn't an available input on v2f_surf
        
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogCoord = varyings.fogFactorAndVertexLight.x;
                COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
        }
        
        void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
        {
            result.positionCS = surfVertex.pos;
            result.positionWS = surfVertex.worldPos;
            // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
            // World Tangent isn't an available input on v2f_surf
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Back
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS ScenePickingPass
        #define BUILTIN_TARGET_API 1
        #define SCENEPICKINGPASS 1
        #define _BUILTIN_SURFACE_TYPE_TRANSPARENT 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #endif
        #ifdef _BUILTIN_ALPHATEST_ON
        #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
        #endif
        #ifdef _BUILTIN_AlphaClip
        #define _AlphaClip _BUILTIN_AlphaClip
        #endif
        #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
        #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
        #endif
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Depth;
        float _Strength;
        float4 _Deep_Water_Color;
        float4 _Shadow_Water_Color;
        float4 _Main_Normal_TexelSize;
        float4 _Second_Normal_TexelSize;
        float _Normal_Strength;
        float _Smoothness;
        float _Displacement;
        float _Wave_Strength;
        float2 _Main_Normal_Tile;
        float2 _Second_Normal_Tile;
        float4 _Highlight_Color;
        float _Highlight_Strength;
        float _Metalic;
        float _Ripple_Speed;
        float4 _Ripple_Texture_Ambient_Occlusion_TexelSize;
        float2 _Ripple_Tile;
        float _Ripple_Opacity;
        float _Main_Normal_Speed;
        float _Second_Normal_Speed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Normal);
        SAMPLER(sampler_Main_Normal);
        TEXTURE2D(_Second_Normal);
        SAMPLER(sampler_Second_Normal);
        TEXTURE2D(_Ripple_Texture_Ambient_Occlusion);
        SAMPLER(sampler_Ripple_Texture_Ambient_Occlusion);
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1 = IN.ObjectSpacePosition[0];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_G_2 = IN.ObjectSpacePosition[1];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3 = IN.ObjectSpacePosition[2];
            float _Split_de3daba8a66f48c9a52f06e4d80e46c3_A_4 = 0;
            float _Property_0357d5684c5741b98876c08275c12954_Out_0 = _Displacement;
            float _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, 100, _Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2);
            float2 _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_7d720ec5ba36444eb24b183e70ea76b0_Out_2.xx), _TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3);
            float _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0 = _Wave_Strength;
            float _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_d50baf671d02468a952f7b96aefc26f9_Out_3, _Property_3c9bd6111e034a0ca09b5e3a081b86f4_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2);
            float _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2;
            Unity_Multiply_float_float(_Property_0357d5684c5741b98876c08275c12954_Out_0, _GradientNoise_1fbfad72bccf485ca33824fcb16a5733_Out_2, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2);
            float4 _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4;
            float3 _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            float2 _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6;
            Unity_Combine_float(_Split_de3daba8a66f48c9a52f06e4d80e46c3_R_1, _Multiply_d45c7d6214c6433094f5dbf3950ecfdd_Out_2, _Split_de3daba8a66f48c9a52f06e4d80e46c3_B_3, 0, _Combine_7af25946b86545bd939a280c7e16a5e7_RGBA_4, _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5, _Combine_7af25946b86545bd939a280c7e16a5e7_RG_6);
            description.Position = _Combine_7af25946b86545bd939a280c7e16a5e7_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0 = _Shadow_Water_Color;
            float4 _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0 = _Deep_Water_Color;
            float _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1);
            float _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2;
            Unity_Multiply_float_float(_SceneDepth_4c48728289dc4e2aae63539d592b43ca_Out_1, _ProjectionParams.z, _Multiply_983da0bb704c49f88acdd897af4e2942_Out_2);
            float4 _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0 = IN.ScreenPosition;
            float _Split_64cd857bd1d64117a2a108ff88c0779c_R_1 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[0];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_G_2 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[1];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_B_3 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[2];
            float _Split_64cd857bd1d64117a2a108ff88c0779c_A_4 = _ScreenPosition_b740b99fc7cb4a0481c0b76939433142_Out_0[3];
            float _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0 = _Depth;
            float _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2;
            Unity_Add_float(_Split_64cd857bd1d64117a2a108ff88c0779c_A_4, _Property_1af6d46ea4334c47a0b7421ba2590ad6_Out_0, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2);
            float _Subtract_1476eb191c244932ad0606241d596d33_Out_2;
            Unity_Subtract_float(_Multiply_983da0bb704c49f88acdd897af4e2942_Out_2, _Add_5c799519c32f4dfba92004c5f9328ecf_Out_2, _Subtract_1476eb191c244932ad0606241d596d33_Out_2);
            float _Property_b8a1367319b64842bc06551f0b38404a_Out_0 = _Strength;
            float _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2;
            Unity_Multiply_float_float(_Subtract_1476eb191c244932ad0606241d596d33_Out_2, _Property_b8a1367319b64842bc06551f0b38404a_Out_0, _Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2);
            float _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3;
            Unity_Clamp_float(_Multiply_cd7c157c473f42a898586e7e921b4a25_Out_2, 0, 1, _Clamp_b1c08e0420874f2387bc1673d1678257_Out_3);
            float4 _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3;
            Unity_Lerp_float4(_Property_4048a5baadc8481594f4f6b13bce8aa0_Out_0, _Property_dd393075151a4f70a1e4857546a1b3fd_Out_0, (_Clamp_b1c08e0420874f2387bc1673d1678257_Out_3.xxxx), _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3);
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_R_1 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[0];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_G_2 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[1];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_B_3 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[2];
            float _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4 = _Lerp_da3ca64871864af1b6aba6f2a8151067_Out_3[3];
            surface.Alpha = _Split_b81a7c13a3db435cb6b946ffc42afff3_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
        {
            result.vertex     = float4(attributes.positionOS, 1);
            result.tangent    = attributes.tangentOS;
            result.normal     = attributes.normalOS;
            result.texcoord   = attributes.uv0;
            result.vertex     = float4(vertexDescription.Position, 1);
            result.normal     = vertexDescription.Normal;
            result.tangent    = float4(vertexDescription.Tangent, 0);
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
        }
        
        void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
        {
            result.pos = varyings.positionCS;
            result.worldPos = varyings.positionWS;
            // World Tangent isn't an available input on v2f_surf
        
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogCoord = varyings.fogFactorAndVertexLight.x;
                COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
        }
        
        void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
        {
            result.positionCS = surfVertex.pos;
            result.positionWS = surfVertex.worldPos;
            // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
            // World Tangent isn't an available input on v2f_surf
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
        ENDHLSL
        }
    }
    CustomEditorForRenderPipeline "UnityEditor.Rendering.BuiltIn.ShaderGraph.BuiltInLitGUI" ""
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    FallBack "Hidden/Shader Graph/FallbackError"
}