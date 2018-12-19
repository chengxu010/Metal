//
//  ViewFor三角形.h
//  TestMetal
//
//  Created by dongzhiqiang on 2018/12/13.
//  Copyright © 2018 dongzhiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewFor三角形 : UIView<MTKViewDelegate>{
    dispatch_semaphore_t _renderSemaphore;
}

@property (nonatomic,strong) id<MTLDevice> device;
@property (nonatomic,strong) id<MTLCommandQueue> queue;


@property (nonatomic,strong) id<MTLRenderPipelineState> pipelineState;
@property (nonatomic,strong) id<MTLSamplerState> samplerState;

@property (nonatomic,strong) MTKView *metalView;

@property (nonatomic,strong) id<MTLTexture> videoTexture;
@property (nonatomic,strong) id<MTLBuffer> vertexBuffer;

@property (nonatomic, assign) vector_uint2 viewportSize;
@property (nonatomic, assign) NSUInteger numVertices;

-(void)draw;

@end

NS_ASSUME_NONNULL_END
