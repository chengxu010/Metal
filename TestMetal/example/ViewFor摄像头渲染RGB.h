//
//  ViewFor摄像头渲染RGB.h
//  TestMetal
//
//  Created by dongzhiqiang on 2018/12/20.
//  Copyright © 2018 dongzhiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MetalKit/MetalKit.h>
#import <MetalPerformanceShaders/MetalPerformanceShaders.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewFor摄像头渲染RGB : UIView<MTKViewDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

// view
@property (nonatomic, strong) MTKView *mtkView;

@property (nonatomic, strong) AVCaptureSession *mCaptureSession; //负责输入和输出设备之间的数据传递
@property (nonatomic, strong) AVCaptureDeviceInput *mCaptureDeviceInput;//负责从AVCaptureDevice获得输入数据
@property (nonatomic, strong) AVCaptureVideoDataOutput *mCaptureDeviceOutput; //output
@property (nonatomic, strong) dispatch_queue_t mProcessQueue;
@property (nonatomic, assign) CVMetalTextureCacheRef textureCache; //output


// data
@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;
@property (nonatomic, strong) id<MTLTexture> texture;

@end

NS_ASSUME_NONNULL_END
