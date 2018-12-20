//
//  ViewFor视频渲染YUVAssetReader.h
//  TestMetal
//
//  Created by dongzhiqiang on 2018/12/20.
//  Copyright © 2018 dongzhiqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewFor视频渲染YUVAssetReader : NSObject
- (instancetype)initWithUrl:(NSURL *)url;

- (CMSampleBufferRef)readBuffer;
@end

NS_ASSUME_NONNULL_END
