//
//  ViewFor视频渲染YUVType.h
//  TestMetal
//
//  Created by dongzhiqiang on 2018/12/20.
//  Copyright © 2018 dongzhiqiang. All rights reserved.
//

#ifndef ViewFor视频渲染YUVType_h
#define ViewFor视频渲染YUVType_h

#include <simd/simd.h>

typedef struct
{
    vector_float4 position;
    vector_float2 textureCoordinate;
} LYVertex;


typedef struct {
    matrix_float3x3 matrix;
    vector_float3 offset;
} LYConvertMatrix;



typedef enum LYVertexInputIndex
{
    LYVertexInputIndexVertices     = 0,
} LYVertexInputIndex;


typedef enum LYFragmentBufferIndex
{
    LYFragmentInputIndexMatrix     = 0,
} LYFragmentBufferIndex;


typedef enum LYFragmentTextureIndex
{
    LYFragmentTextureIndexTextureY     = 0,
    LYFragmentTextureIndexTextureUV     = 1,
} LYFragmentTextureIndex;


#endif /* ViewFor____YUVType_h */
