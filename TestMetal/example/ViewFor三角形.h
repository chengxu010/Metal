//
//  ViewFor三角形.h
//  TestMetal
//
//  Created by dongzhiqiang on 2018/12/13.
//  Copyright © 2018 dongzhiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMetalView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ViewFor三角形 : BaseMetalView{
    dispatch_semaphore_t _renderSemaphore;
}

@end

NS_ASSUME_NONNULL_END
