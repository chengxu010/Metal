//
//  VertexType.h
//  TestMetal
//
//  Created by dongzhiqiang on 2018/12/17.
//  Copyright © 2018 dongzhiqiang. All rights reserved.
//

#ifndef VertexType_h
#define VertexType_h

typedef struct
{
    vector_float4 position;
    vector_float2 texCoords;
} VertexIn;

typedef struct
{
    vector_float4 position;
} CustomVertexIn;

#endif /* VertexType_h */
