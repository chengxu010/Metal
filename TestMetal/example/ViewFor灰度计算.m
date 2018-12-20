//
//  ViewFor灰度计算.m
//  TestMetal
//
//  Created by dongzhiqiang on 2018/12/20.
//  Copyright © 2018 dongzhiqiang. All rights reserved.
//

#import "ViewFor灰度计算.h"
#import "ViewFor灰度计算Type.h"

@implementation ViewFor灰度计算

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self setupThreadGroup];
    }
    
    return self;
}

// 设置渲染管道和计算管道
-(void)setupPipeline {
    id<MTLLibrary> defaultLibrary = [self.mtkView.device newDefaultLibrary]; // .metal
    id<MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShadergray"]; // 顶点shader，vertexShader是函数名
    id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"samplingShadergray"]; // 片元shader，samplingShader是函数名
    id<MTLFunction> kernelFunction = [defaultLibrary newFunctionWithName:@"grayKernel"];
    
    MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
    pipelineStateDescriptor.vertexFunction = vertexFunction;
    pipelineStateDescriptor.fragmentFunction = fragmentFunction;
    pipelineStateDescriptor.colorAttachments[0].pixelFormat = self.mtkView.colorPixelFormat;
    // 创建图形渲染管道，耗性能操作不宜频繁调用
    self.pipelineState = [self.mtkView.device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor
                                                                                   error:NULL];
    // 创建计算管道，耗性能操作不宜频繁调用
    self.computePipelineState = [self.mtkView.device newComputePipelineStateWithFunction:kernelFunction
                                                                                   error:NULL];
    // CommandQueue是渲染指令队列，保证渲染指令有序地提交到GPU
    self.commandQueue = [self.mtkView.device newCommandQueue];
}
//设置顶点数据
- (void)setupVertex {
    const GrayVertexIn quadVertices[] =
    {   // 顶点坐标，分别是x、y、z、w；    纹理坐标，x、y；
        { {  0.5, -0.5 / self.viewportSize.y * self.viewportSize.x, 0.0, 1.0 },  { 1.f, 1.f } },
        { { -0.5, -0.5 / self.viewportSize.y * self.viewportSize.x, 0.0, 1.0 },  { 0.f, 1.f } },
        { { -0.5,  0.5 / self.viewportSize.y * self.viewportSize.x, 0.0, 1.0 },  { 0.f, 0.f } },
        
        { {  0.5, -0.5 / self.viewportSize.y * self.viewportSize.x, 0.0, 1.0 },  { 1.f, 1.f } },
        { { -0.5,  0.5 / self.viewportSize.y * self.viewportSize.x, 0.0, 1.0 },  { 0.f, 0.f } },
        { {  0.5,  0.5 / self.viewportSize.y * self.viewportSize.x, 0.0, 1.0 },  { 1.f, 0.f } },
    };
    self.vertices = [self.mtkView.device newBufferWithBytes:quadVertices
                                                     length:sizeof(quadVertices)
                                                    options:MTLResourceStorageModeShared]; // 创建顶点缓存
    self.numVertices = sizeof(quadVertices) / sizeof(GrayVertexIn); // 顶点个数
}

- (void)setupTexture {
    UIImage *image = [UIImage imageNamed:@"def"];
    // 纹理描述符
    MTLTextureDescriptor *textureDescriptor = [[MTLTextureDescriptor alloc] init];
    textureDescriptor.pixelFormat = MTLPixelFormatRGBA8Unorm; // 图片的格式要和数据一致
    textureDescriptor.width = image.size.width;
    textureDescriptor.height = image.size.height;
    textureDescriptor.usage = MTLTextureUsageShaderRead; // 原图片只需要读取
    self.texture = [self.mtkView.device newTextureWithDescriptor:textureDescriptor]; // 创建纹理
    
    MTLRegion region = {{ 0, 0, 0 }, {image.size.width, image.size.height, 1}}; // 纹理上传的范围
    Byte *imageBytes = [self loadImage:image];
    if (imageBytes) { // UIImage的数据需要转成二进制才能上传，且不用jpg、png的NSData
        [self.texture replaceRegion:region
                              mipmapLevel:0
                                withBytes:imageBytes
                              bytesPerRow:4 * image.size.width];
        free(imageBytes); // 需要释放资源
        imageBytes = NULL;
    }
    
    textureDescriptor.usage = MTLTextureUsageShaderWrite | MTLTextureUsageShaderRead; // 目标纹理在compute管道需要写，在render管道需要读
    self.destTexture = [self.mtkView.device newTextureWithDescriptor:textureDescriptor];
}

- (void)setupThreadGroup {
    self.groupSize = MTLSizeMake(16, 16, 1); // 太大某些GPU不支持，太小效率低；
    
    //保证每个像素都有处理到
    _groupCount.width  = (self.texture.width  + self.groupSize.width -  1) / self.groupSize.width;
    _groupCount.height = (self.texture.height + self.groupSize.height - 1) / self.groupSize.height;
    _groupCount.depth = 1; // 我们是2D纹理，深度设为1
}

- (void)drawInMTKView:(MTKView *)view {
    // 每次渲染都要单独创建一个CommandBuffer
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    
    {
        // 创建计算指令的编码器
        id<MTLComputeCommandEncoder> computeEncoder = [commandBuffer computeCommandEncoder];
        // 设置计算管道，以调用shaders.metal中的内核计算函数
        [computeEncoder setComputePipelineState:self.computePipelineState];
        // 输入纹理
        [computeEncoder setTexture:self.texture
                           atIndex:0];
        // 输出纹理
        [computeEncoder setTexture:self.destTexture
                           atIndex:1];
        // 计算区域
        [computeEncoder dispatchThreadgroups:self.groupCount
                       threadsPerThreadgroup:self.groupSize];
        // 调用endEncoding释放编码器，下个encoder才能创建
        [computeEncoder endEncoding];
    }
    
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    // MTLRenderPassDescriptor描述一系列attachments的值，类似GL的FrameBuffer；同时也用来创建MTLRenderCommandEncoder
    if(renderPassDescriptor != nil)
    {
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.5, 0.5, 1.0f); // 设置默认颜色
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor]; //编码绘制指令的Encoder
        [renderEncoder setViewport:(MTLViewport){0.0, 0.0, self.viewportSize.x, self.viewportSize.y, -1.0, 1.0 }]; // 设置显示区域
        [renderEncoder setRenderPipelineState:self.pipelineState]; // 设置渲染管道，以保证顶点和片元两个shader会被调用
        
        [renderEncoder setVertexBuffer:self.vertices
                                offset:0
                               atIndex:0]; // 设置顶点缓存
        
        [renderEncoder setFragmentTexture:self.destTexture
                                  atIndex:0]; // 设置纹理
        
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                          vertexStart:0
                          vertexCount:self.numVertices]; // 绘制
        
        [renderEncoder endEncoding]; // 结束
        
        [commandBuffer presentDrawable:view.currentDrawable]; // 显示
    }
    
    [commandBuffer commit]; // 提交；
}

@end
