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
        [self initMetal];
        
//        self.metalView.framebufferOnly = NO;
//        [self.metalView setPaused:YES];
        
        _renderSemaphore = dispatch_semaphore_create(1);
    }
    
    return self;
}

- (void)initMetal{
    self.device = MTLCreateSystemDefaultDevice();
    self.queue = _device.newCommandQueue;
    
    _metalView = [[MTKView alloc] initWithFrame:self.bounds device:self.device];
    [self addSubview:_metalView];
    self.metalView.delegate = self;
    self.viewportSize = (vector_uint2){self.metalView.drawableSize.width, self.metalView.drawableSize.height};
    
    //设置渲染管线
    id<MTLLibrary> lib = [_device newDefaultLibrary];
    MTLRenderPipelineDescriptor *pipelineDes = [MTLRenderPipelineDescriptor new];
    pipelineDes.vertexFunction = [lib newFunctionWithName:@"myVertexShader"];
    pipelineDes.fragmentFunction = [lib newFunctionWithName:@"myFragmentShader"];
    pipelineDes.colorAttachments[0].pixelFormat = self.metalView.colorPixelFormat;
    self.pipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineDes error:nil];
    
    // init vertex buffer
    static const VertexIn vertexs[] = {
        // 前 4 位 位置 x , y , z ,w
        {{0.5, -0.5,1,1}, {0.0, 1.0}},
        {{-0.5, -0.5,1,1}, {1.0, 0.0}},
        {{0.0,  0.5,1,1}, {1.0, 1.0}},
    };
    self.vertexBuffer =  [_device newBufferWithBytes:vertexs
                                              length:sizeof(vertexs)
                                             options:MTLResourceStorageModeShared];
    self.numVertices = sizeof(vertexs) / sizeof(VertexIn); // 顶点个数
    
    UIImage *image = [UIImage imageNamed:@"abc"];
    MTKTextureLoader *loader = [[MTKTextureLoader alloc]initWithDevice:self.device];
    NSError* err;
    self.videoTexture = [loader newTextureWithCGImage:image.CGImage options:nil error:&err];
//    MTLTextureDescriptor *textureDescriptor = [[MTLTextureDescriptor alloc] init];
//    textureDescriptor.pixelFormat = MTLPixelFormatRGBA8Unorm;
//    textureDescriptor.width = image.size.width;
//    textureDescriptor.height = image.size.height;
//    self.videoTexture = [self.metalView.device newTextureWithDescriptor:textureDescriptor]; // 创建纹理
//
//    MTLRegion region = {{ 0, 0, 0 }, {image.size.width, image.size.height, 1}}; // 纹理上传的范围
//    Byte *imageBytes = [self loadImage:image];
//    if (imageBytes) { // UIImage的数据需要转成二进制才能上传，且不用jpg、png的NSData
//        [self.videoTexture replaceRegion:region
//                        mipmapLevel:0
//                          withBytes:imageBytes
//                        bytesPerRow:4 * image.size.width];
//        free(imageBytes); // 需要释放资源
//        imageBytes = NULL;
//    }
    
    
    
    MTLSamplerDescriptor *sampleDes = [MTLSamplerDescriptor new];
    sampleDes.minFilter = MTLSamplerMinMagFilterNearest;
    sampleDes.magFilter = MTLSamplerMinMagFilterLinear;
    self.samplerState = [_device newSamplerStateWithDescriptor:sampleDes];
    
    
    
}

-(void)draw
{
    [self.metalView draw];
}

- (void)render:(id<MTLTexture>) texture{

    @autoreleasepool {
        CAMetalLayer *metaLayer = (CAMetalLayer*)self.metalView.layer;
        id<CAMetalDrawable> drawable = [metaLayer nextDrawable];

        id<MTLCommandBuffer> buffer = [_queue commandBuffer];
        MTLRenderPassDescriptor *rpDes = self.metalView.currentRenderPassDescriptor;

        id<MTLTexture> sourceTexture = texture;

        // off - screen end
        dispatch_semaphore_wait(_renderSemaphore, DISPATCH_TIME_FOREVER);

        // on - screen start
        if (rpDes != nil) {
            //set bg color  = black
//            rpDes.colorAttachments[0].texture = drawable.texture;
            rpDes.colorAttachments[0].loadAction = MTLLoadActionClear;
            rpDes.colorAttachments[0].storeAction = MTLStoreActionStore;
            rpDes.colorAttachments[0].clearColor = MTLClearColorMake(1, 1, 1, 1); //background color

            id<MTLRenderCommandEncoder> encoder = [buffer renderCommandEncoderWithDescriptor:rpDes];
            [encoder setViewport:(MTLViewport){0.0, 0.0, self.viewportSize.x, self.viewportSize.y, -1.0, 1.0 }]; // 设置显示区域
            [encoder setRenderPipelineState:self.pipelineState];
            [encoder setVertexBuffer:self.vertexBuffer offset:0 atIndex:0];
            [encoder setFragmentTexture:sourceTexture atIndex:0];
            [encoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:3];

            [encoder setLabel:@"pass encoder"];
            [encoder pushDebugGroup:@"rander"];

            [encoder setCullMode:MTLCullModeFront];
            [encoder setFrontFacingWinding:MTLWindingClockwise];
            [encoder setFragmentSamplerState:self.samplerState atIndex:0];


            [encoder popDebugGroup];
            [encoder endEncoding];
            // on - screen end


            [buffer presentDrawable:self.metalView.currentDrawable];

            __weak dispatch_semaphore_t semaphore = _renderSemaphore;

            [buffer addCompletedHandler:^(id<MTLCommandBuffer> _Nonnull buffer) {
                // render finish release drawable
                dispatch_semaphore_signal(semaphore);
            }];
        }

        [buffer commit];
    }

}

#pragma mark - mtk
- (void)drawInMTKView:(nonnull MTKView *)view {
    [self render:self.videoTexture];

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
