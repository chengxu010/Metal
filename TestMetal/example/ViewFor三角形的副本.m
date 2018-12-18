//
//  ViewFor三角形.m
//  TestMetal
//
//  Created by dongzhiqiang on 2018/12/13.
//  Copyright © 2018 dongzhiqiang. All rights reserved.
//

#import "ViewFor三角形.h"

static const float vertexArrayData[] = {
    // 前 4 位 位置 x , y , z ,w
    0.577, -0.25, 0.0, 1.0,
    -0.577, -0.25, 0.0, 1.0,
    0.0,  0.5, 0.0, 1.0,
};

@implementation ViewFor三角形

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        //获取设备
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        if (device == nil) {
            NSLog(@"don't support metal !");
            return self;
        }
        self.device = device;
        
        self.queue = device.newCommandQueue;
        
        _mtkView = [[MTKView alloc] initWithFrame:frame device:device];
        [self addSubview:_mtkView];
        
        //command buffer
        id<MTLCommandBuffer> commandBuffer = [_queue commandBuffer];
        
        id<MTLBuffer> vertexBuffer = [_device newBufferWithBytes:vertexArrayData
                                                          length:sizeof(vertexArrayData)
                                                         options:0];
        
        UIImage *image = [UIImage imageNamed:@"abc"];
        MTKTextureLoader *loader = [[MTKTextureLoader alloc]initWithDevice:self.device];
        NSError* err;
        id<MTLTexture> sourceTexture = [loader newTextureWithCGImage:image.CGImage options:nil error:&err];
        
        id<MTLLibrary> library = [_device newDefaultLibrary];
        [library newFunctionWithName:@"myVertexShader"];
        
        //构造Pipeline
        MTLRenderPipelineDescriptor *des = [MTLRenderPipelineDescriptor new];
        
        
        //获取 shader 的函数
        des.vertexFunction = [library newFunctionWithName:@"myVertexShader"];
        des.fragmentFunction = [library newFunctionWithName:@"myFragmentShader"];
        des.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
        
        //生成 MTLRenderPipelineState
        NSError *error;
        id <MTLRenderPipelineState> pipelineState = [_device newRenderPipelineStateWithDescriptor:des
                                                                 error:&error];
        
        CAMetalLayer *metaLayer = (CAMetalLayer*)self.mtkView.layer;
        id<CAMetalDrawable> drawable = [metaLayer nextDrawable];
        
        //render des
        MTLRenderPassDescriptor *renderDes = [MTLRenderPassDescriptor new];
        renderDes.colorAttachments[0].texture = drawable.texture;
        renderDes.colorAttachments[0].loadAction = MTLLoadActionClear;
        renderDes.colorAttachments[0].storeAction = MTLStoreActionStore;
        renderDes.colorAttachments[0].clearColor = MTLClearColorMake(0.5, 0.65, 0.8, 1); //background color
        
        
        //command encoder
        id<MTLRenderCommandEncoder> encoder = [commandBuffer renderCommandEncoderWithDescriptor:renderDes];
        [encoder setCullMode:MTLCullModeNone];
        [encoder setFrontFacingWinding:MTLWindingCounterClockwise];
        [encoder setRenderPipelineState:pipelineState];
        [encoder setVertexBuffer:vertexBuffer offset:0 atIndex:0];
        [encoder setFragmentTexture:sourceTexture atIndex:0];
        
        //set render vertex
        [encoder drawPrimitives:MTLPrimitiveTypeTriangle
                    vertexStart:0
                    vertexCount:3];
        
        [encoder endEncoding];
        
        
        //commit
        [commandBuffer presentDrawable:drawable];
        [commandBuffer commit];
        
    }
    
    return self;
}

@end
