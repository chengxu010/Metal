//
//  ViewFor视频渲染YUV.h
//  TestMetal
//
//  Created by dongzhiqiang on 2018/12/20.
//  Copyright © 2018 dongzhiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMetalView.h"
#import "ViewFor视频渲染YUVType.h"
#import "ViewFor视频渲染YUVAssetReader.h"

NS_ASSUME_NONNULL_BEGIN

@interface ViewFor视频渲染YUV : BaseMetalView

@property (nonatomic, strong) ViewFor视频渲染YUVAssetReader *reader;
@property (nonatomic, assign) CVMetalTextureCacheRef textureCache;

@property (nonatomic, strong) id<MTLBuffer> convertMatrix;

@end

NS_ASSUME_NONNULL_END
