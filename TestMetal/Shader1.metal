//
//  Shader1.metal
//  TestMetal
//
//  Created by dongzhiqiang on 2018/12/13.
//  Copyright © 2018 dongzhiqiang. All rights reserved.
//

#include <metal_stdlib>
#import "VertexType.h"

using namespace metal;


typedef struct
{
    float4 position [[position]];
    float2 texCoords;
}VertexOut;



vertex VertexOut myVertexShader(const device VertexIn* vertexArray [[buffer(0)]],
                                unsigned int vid  [[vertex_id]]){
    
    VertexOut verOut;
    verOut.position = vertexArray[vid].position;
    verOut.texCoords = vertexArray[vid].texCoords;
    return verOut;
    
}

fragment float4 myFragmentShader(
                                 VertexOut vertexIn [[stage_in]],
                                 texture2d<float,access::sample>   inputImage   [[ texture(0) ]]
                                 )
{
    constexpr sampler textureSampler (mag_filter::linear,
                                      min_filter::linear); // sampler是采样器
    float4 color = inputImage.sample(textureSampler, vertexIn.texCoords);
    return color;
    
}
