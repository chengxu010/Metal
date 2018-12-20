//
//  ViewFor三维变换Type.h
//  TestMetal
//
//  Created by dongzhiqiang on 2018/12/20.
//  Copyright © 2018 dongzhiqiang. All rights reserved.
//

#ifndef ViewFor三维变换Type_h
#define ViewFor三维变换Type_h

#include <simd/simd.h>

typedef struct
{
    vector_float4 position;
    vector_float3 color;
    vector_float2 textureCoordinate;
} LYVertex;


typedef struct
{
    matrix_float4x4 projectionMatrix;
    matrix_float4x4 modelViewMatrix;
} LYMatrix;



typedef enum LYVertexInputIndex
{
    LYVertexInputIndexVertices     = 0,
    LYVertexInputIndexMatrix       = 1,
} LYVertexInputIndex;



typedef enum LYFragmentInputIndex
{
    LYFragmentInputIndexTexture     = 0,
} LYFragmentInputIndex;

#endif /* ViewFor____Type_h */
