//
//  BaseMetalView.h
//  TestMetal
//
//  Created by dongzhiqiang on 2018/12/20.
//  Copyright © 2018 dongzhiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MetalKit/MetalKit.h>
#import "VertexType.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseMetalView : UIView<MTKViewDelegate>

@property (nonatomic, strong) MTKView *mtkView;
@property (nonatomic, assign) vector_uint2 viewportSize;
@property (nonatomic, strong) id<MTLRenderPipelineState> pipelineState;
@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;
@property (nonatomic, strong) id<MTLTexture> texture;
@property (nonatomic, strong) id<MTLBuffer> vertices;
@property (nonatomic, assign) NSUInteger numVertices;


#pragma mark - tools
- (Byte *)loadImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
