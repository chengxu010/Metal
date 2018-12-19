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

@interface ViewFor三角形 : UIView

@property (nonatomic, strong) id<MTLDevice> device;
@property (nonatomic, strong) MTKView *mtkView;
@property (nonatomic, strong) id<MTLCommandQueue> queue;

@end

NS_ASSUME_NONNULL_END
