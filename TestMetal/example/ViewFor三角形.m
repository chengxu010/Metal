//
//  ViewFor三角形.m
//  TestMetal
//
//  Created by dongzhiqiang on 2018/12/13.
//  Copyright © 2018 dongzhiqiang. All rights reserved.
//

#import "ViewFor三角形.h"
#import "VertexType.h"

@import Metal;
@import MetalKit;
@import MetalPerformanceShaders;



@implementation ViewFor三角形

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        _renderSemaphore = dispatch_semaphore_create(1);
    }
    
    return self;
}


//设置顶点数据
- (void)setupVertex
{
    // init vertex buffer
    static const VertexIn vertexs[] = {
        // 前 4 位 位置 x , y , z ,w
        {{0.5, -0.5,1,1}, {0.0, 1.0}},
        {{-0.5, -0.5,1,1}, {1.0, 0.0}},
        {{0.0,  0.5,1,1}, {1.0, 1.0}},
    };
    self.vertices =  [self.mtkView.device newBufferWithBytes:vertexs
                                              length:sizeof(vertexs)
                                             options:MTLResourceStorageModeShared];
    self.numVertices = sizeof(vertexs) / sizeof(VertexIn); // 顶点个数
}

- (void)setupTexture {
    UIImage *image = [UIImage imageNamed:@"abc"];
    MTKTextureLoader *loader = [[MTKTextureLoader alloc]initWithDevice:self.mtkView.device];
    NSError* err;
    self.texture = [loader newTextureWithCGImage:image.CGImage options:nil error:&err];
}


@end
