//
//  Shader3.metal
//  TestMetal
//
//  Created by dongzhiqiang on 2018/12/19.
//  Copyright © 2018 dongzhiqiang. All rights reserved.
//

#include <metal_stdlib>
#import "VertexType.h"

using namespace metal;

typedef struct
{
    float4 position [[position]];
}CustomVertexOut;



vertex CustomVertexOut customVertexShader(const device CustomVertexIn* vertexArray [[buffer(0)]],
                                unsigned int vid  [[vertex_id]]){
    
    CustomVertexOut verOut;
    verOut.position = vertexArray[vid].position;
    return verOut;
    
}

fragment float4 customFragmentShader(
                                 CustomVertexOut vertexIn [[stage_in]],
                                 texture2d<float,access::sample>   inputImage   [[ texture(0) ]]
                                 )
{
    float4 color = float4(1,0,0,0.3);
    return color;
    
}

