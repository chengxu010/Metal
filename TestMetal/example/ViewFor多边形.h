//
//  ViewFor多边形.h
//  TestMetal
//
//  Created by dongzhiqiang on 2018/12/18.
//  Copyright © 2018 dongzhiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewFor多边形 : UIView<MTKViewDelegate>

// view
@property (nonatomic, strong) MTKView *mtkView;

// data
@property (nonatomic, assign) vector_uint2 viewportSize;
@property (nonatomic, strong) id<MTLRenderPipelineState> pipelineState;
@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;
@property (nonatomic, strong) id<MTLTexture> texture;
@property (nonatomic, strong) id<MTLBuffer> vertices;
@property (nonatomic, assign) NSUInteger numVertices;

@end

NS_ASSUME_NONNULL_END
