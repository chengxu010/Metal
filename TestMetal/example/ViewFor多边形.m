//
//  ViewFor多边形.m
//  TestMetal
//
//  Created by dongzhiqiang on 2018/12/18.
//  Copyright © 2018 dongzhiqiang. All rights reserved.
//

#import "ViewFor多边形.h"
#import "VertexType.h"
#import "MapVertexData.h"

@implementation ViewFor多边形

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self setupMtkView];
        [self setupPipeline];
        [self setupVertex];
        [self setupTexture];
    }
    
    return self;
}


#pragma mark -
-(void)setupMtkView
{
    // 初始化 MTKView
    self.mtkView = [[MTKView alloc] initWithFrame:self.bounds];
    self.mtkView.device = MTLCreateSystemDefaultDevice(); // 获取默认的device
    [self addSubview:self.mtkView];
    self.mtkView.delegate = self;
    self.viewportSize = (vector_uint2){self.mtkView.drawableSize.width, self.mtkView.drawableSize.height};
}

// 设置渲染管道
-(void)setupPipeline {
    id<MTLLibrary> defaultLibrary = [self.mtkView.device newDefaultLibrary]; // .metal
    id<MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"customVertexShader"]; // 顶点shader，vertexShader是函数名
    id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"customFragmentShader"]; // 片元shader，samplingShader是函数名
    
    MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
    pipelineStateDescriptor.vertexFunction = vertexFunction;
    pipelineStateDescriptor.fragmentFunction = fragmentFunction;
    pipelineStateDescriptor.colorAttachments[0].pixelFormat = self.mtkView.colorPixelFormat;
    self.pipelineState = [self.mtkView.device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor
                                                                             error:NULL]; // 创建图形渲染管道，耗性能操作不宜频繁调用
    self.commandQueue = [self.mtkView.device newCommandQueue]; // CommandQueue是渲染指令队列，保证渲染指令有序地提交到GPU
}

//设置顶点数据
- (void)setupVertex {
    static const CustomVertexIn quadVertices[] =
    {   // 顶点坐标，分别是x、y、z、w；    纹理坐标，x、y；
        { {  0.5, -0.5, 0.0, 1.0 }},
        { {  0.3, -0.4, 0.0, 1.0 }},
        { {  0.0, -0.6, 0.0, 1.0 }},
        { { -0.2, -0.7, 0.0, 1.0 }},
        { { -0.4, -0.6, 0.0, 1.0 }},
        { { -0.5, -0.5, 0.0, 1.0 }},
        { { -0.3,  0.0, 0.0, 1.0 }},
        { { -0.6,  0.2, 0.0, 1.0 }},
        { { -0.7,  0.5, 0.0, 1.0 }},
        { { -0.4,  0.6, 0.0, 1.0 }},
        { {  0.1,  0.4, 0.0, 1.0 }},
        { {  0.5,  0.5, 0.0, 1.0 }},
    };
    
//    VertexIn *quadVertices = new quadVertices[20];
//    for (int i = 0; i < 20; i++){
//
//    }

    
    NSInteger num = sizeof(quadVertices) / sizeof(CustomVertexIn);
    NSInteger len = num*sizeof(CustomVertexIn);
    float *pVerticeData = malloc(len);
    for (int i = 0 ; i < num; i++){
        CustomVertexIn tmp = quadVertices[i];
        pVerticeData[i*4] = tmp.position.x;
        pVerticeData[i*4+1] = tmp.position.y;
        pVerticeData[i*4+2] = tmp.position.z;
        pVerticeData[i*4+3] = tmp.position.w;
    }
    NSMutableData *data = [[NSMutableData alloc] initWithBytes:pVerticeData length:len];
    
    self.vertices = [self.mtkView.device newBufferWithBytes:data.bytes
                                                     length:len
                                                    options:MTLResourceStorageModeShared]; // 创建顶点缓存
    self.numVertices = num;//sizeof(quadVertices) / sizeof(CustomVertexIn); // 顶点个数
}

- (void)setupTexture {
    UIImage *image = [UIImage imageNamed:@"zhuan"];
    // 纹理描述符
    MTLTextureDescriptor *textureDescriptor = [[MTLTextureDescriptor alloc] init];
    textureDescriptor.pixelFormat = MTLPixelFormatRGBA8Unorm;
    textureDescriptor.width = image.size.width;
    textureDescriptor.height = image.size.height;
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
}

#pragma mark - mtk
- (void)drawInMTKView:(nonnull MTKView *)view {
    // 每次渲染都要单独创建一个CommandBuffer
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
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
        
        [renderEncoder setFragmentTexture:self.texture
                                  atIndex:0]; // 设置纹理
        
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangleStrip
                          vertexStart:0
                          vertexCount:self.numVertices]; // 绘制
        
        [renderEncoder endEncoding]; // 结束
        
        [commandBuffer presentDrawable:view.currentDrawable]; // 显示
    }
    
    [commandBuffer commit]; // 提交；
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
    self.viewportSize = (vector_uint2){size.width, size.height};
}

#pragma mark - private
- (Byte *)loadImage:(UIImage *)image {
    // 1获取图片的CGImageRef
    CGImageRef spriteImage = image.CGImage;
    
    // 2 读取图片的大小
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    Byte * spriteData = (Byte *) calloc(width * height * 4, sizeof(Byte)); //rgba共4个byte
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    // 3在CGContextRef上绘图
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    return spriteData;
}

@end
