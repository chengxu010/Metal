//
//  ViewFor摄像头渲染RGB.m
//  TestMetal
//
//  Created by dongzhiqiang on 2018/12/20.
//  Copyright © 2018 dongzhiqiang. All rights reserved.
//

#import "ViewFor摄像头渲染RGB.h"

@implementation ViewFor摄像头渲染RGB

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        // 设置Metal 相关
        [self setupMetal];
        // 设置采集相关
        [self setupCaptureSession];
    }
    
    return self;
}


- (void)setupMetal {
    self.mtkView = [[MTKView alloc] initWithFrame:self.bounds];
    self.mtkView.device = MTLCreateSystemDefaultDevice();
    [self insertSubview:self.mtkView atIndex:0];
    self.mtkView.delegate = self;
    self.mtkView.framebufferOnly = NO; // 允许读写操作
    //    self.mtkView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    self.commandQueue = [self.mtkView.device newCommandQueue];
    CVMetalTextureCacheCreate(NULL, NULL, self.mtkView.device, NULL, &_textureCache);
}

- (void)setupCaptureSession {
    self.mCaptureSession = [[AVCaptureSession alloc] init];
    self.mCaptureSession.sessionPreset = AVCaptureSessionPreset1920x1080;
    self.mProcessQueue = dispatch_queue_create("mProcessQueue", DISPATCH_QUEUE_SERIAL); // 串行队列
    AVCaptureDevice *inputCamera = nil;
//    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceDiscoverySession *captureDeviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position: AVCaptureDevicePositionUnspecified]; // here you pass AVCaptureDevicePositionUnspecified to find all capture devices
    
    NSArray *devices = [captureDeviceDiscoverySession devices];
    
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionBack) {
            inputCamera = device;
        }
    }
    self.mCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:inputCamera error:nil];
    if ([self.mCaptureSession canAddInput:self.mCaptureDeviceInput]) {
        [self.mCaptureSession addInput:self.mCaptureDeviceInput];
    }
    self.mCaptureDeviceOutput = [[AVCaptureVideoDataOutput alloc] init];
    [self.mCaptureDeviceOutput setAlwaysDiscardsLateVideoFrames:NO];
    // 这里设置格式为BGRA，而不用YUV的颜色空间，避免使用Shader转换
    [self.mCaptureDeviceOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    [self.mCaptureDeviceOutput setSampleBufferDelegate:self queue:self.mProcessQueue];
    if ([self.mCaptureSession canAddOutput:self.mCaptureDeviceOutput]) {
        [self.mCaptureSession addOutput:self.mCaptureDeviceOutput];
    }
    AVCaptureConnection *connection = [self.mCaptureDeviceOutput connectionWithMediaType:AVMediaTypeVideo];
    [connection setVideoOrientation:AVCaptureVideoOrientationPortrait]; // 设置方向
    [self.mCaptureSession startRunning];
}

#pragma mark - delegate

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
    
}

- (void)drawInMTKView:(MTKView *)view {
    if (self.texture) {
        id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer]; // 创建指令缓冲
        id<MTLTexture> drawingTexture = view.currentDrawable.texture; // 把MKTView作为目标纹理
        
        MPSImageGaussianBlur *filter = [[MPSImageGaussianBlur alloc] initWithDevice:self.mtkView.device sigma:1]; // 这里的sigma值可以修改，sigma值越高图像越模糊
        [filter encodeToCommandBuffer:commandBuffer sourceTexture:self.texture destinationTexture:drawingTexture]; // 把摄像头返回图像数据的原始数据
        
        [commandBuffer presentDrawable:view.currentDrawable]; // 展示数据
        [commandBuffer commit];
        
        self.texture = nil;
    }
}


#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    size_t width = CVPixelBufferGetWidth(pixelBuffer);
    size_t height = CVPixelBufferGetHeight(pixelBuffer);
    
    CVMetalTextureRef tmpTexture = NULL;
    // 如果MTLPixelFormatBGRA8Unorm和摄像头采集时设置的颜色格式不一致，则会出现图像异常的情况；
    CVReturn status = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, self.textureCache, pixelBuffer, NULL, MTLPixelFormatBGRA8Unorm, width, height, 0, &tmpTexture);
    if(status == kCVReturnSuccess)
    {
        self.mtkView.drawableSize = CGSizeMake(width, height);
        self.texture = CVMetalTextureGetTexture(tmpTexture);
        CFRelease(tmpTexture);
    }
}

@end
