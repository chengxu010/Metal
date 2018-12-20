//
//  ViewFor图片绘制.m
//  TestMetal
//
//  Created by dongzhiqiang on 2018/12/17.
//  Copyright © 2018 dongzhiqiang. All rights reserved.
//

#import "ViewFor图片绘制.h"
#import "VertexType.h"

@implementation ViewFor图片绘制


//设置顶点数据
- (void)setupVertex {
//    static const float quadVertices[][6] =
//    {   // 顶点坐标，分别是x、y、z、w；    纹理坐标，x、y；
//        {   0.5, -0.5, 0.0, 1.0 ,   1.f, 1.f  },
//        {  -0.5, -0.5, 0.0, 1.0 ,   0.f, 1.f  },
//        {  -0.5,  0.5, 0.0, 1.0 ,   0.f, 0.f  },
//
//        {   0.5, -0.5, 0.0, 1.0 ,   1.f, 1.f  },
//        {  -0.5,  0.5, 0.0, 1.0 ,   0.f, 0.f  },
//        {   0.5,  0.5, 0.0, 1.0 ,   1.f, 0.f  },
//    };
    static const VertexIn quadVertices[] =
    {   // 顶点坐标，分别是x、y、z、w；    纹理坐标，x、y；
        { {  0.5, -0.5, 0.0, 1.0 },  { 1.f, 1.f } },
        { { -0.5, -0.5, 0.0, 1.0 },  { 0.f, 1.f } },
        { { -0.5,  0.5, 0.0, 1.0 },  { 0.f, 0.f } },
        
        { {  0.5, -0.5, 0.0, 1.0 },  { 1.f, 1.f } },
        { { -0.5,  0.5, 0.0, 1.0 },  { 0.f, 0.f } },
        { {  0.5,  0.5, 0.0, 1.0 },  { 1.f, 0.f } },
    };
    self.vertices = [self.mtkView.device newBufferWithBytes:quadVertices
                                                     length:sizeof(quadVertices)
                                                    options:MTLResourceStorageModeShared]; // 创建顶点缓存
    self.numVertices = sizeof(quadVertices) / sizeof(VertexIn); // 顶点个数
}


@end
