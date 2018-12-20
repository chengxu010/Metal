//
//  ViewFor灰度计算.h
//  TestMetal
//
//  Created by dongzhiqiang on 2018/12/20.
//  Copyright © 2018 dongzhiqiang. All rights reserved.
//

#import "BaseMetalView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ViewFor灰度计算 : BaseMetalView

@property (nonatomic, strong) id<MTLComputePipelineState> computePipelineState;
@property (nonatomic, strong) id<MTLTexture> destTexture;

@property (nonatomic, assign) MTLSize groupSize;
@property (nonatomic, assign) MTLSize groupCount;

@end

NS_ASSUME_NONNULL_END
