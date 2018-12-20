//
//  ViewFor三维变换.metal
//  TestMetal
//
//  Created by dongzhiqiang on 2018/12/20.
//  Copyright © 2018 dongzhiqiang. All rights reserved.
//

#include <metal_stdlib>
#import "ViewFor三维变换Type.h"

using namespace metal;

typedef struct
{
    float4 clipSpacePosition [[position]];
    float3 pixelColor;
    float2 textureCoordinate;
    
} RasterizerData;

vertex RasterizerData // 顶点
vertexShaderThreeD(uint vertexID [[ vertex_id ]],
             constant LYVertex *vertexArray [[ buffer(LYVertexInputIndexVertices) ]],
             constant LYMatrix *matrix [[ buffer(LYVertexInputIndexMatrix) ]]) {
    RasterizerData out;
    out.clipSpacePosition = matrix->projectionMatrix * matrix->modelViewMatrix * vertexArray[vertexID].position;
    out.textureCoordinate = vertexArray[vertexID].textureCoordinate;
    out.pixelColor = vertexArray[vertexID].color;
    
    return out;
}

fragment float4 // 片元
samplingShaderThreeD(RasterizerData input [[stage_in]],
               texture2d<half> textureColor [[ texture(LYFragmentInputIndexTexture) ]])
{
    constexpr sampler textureSampler (mag_filter::linear,
                                      min_filter::linear);
    
    //    half4 colorTex = textureColor.sample(textureSampler, input.textureCoordinate);
    half4 colorTex = half4(input.pixelColor.x, input.pixelColor.y, input.pixelColor.z, 1);
    return float4(colorTex);
}

