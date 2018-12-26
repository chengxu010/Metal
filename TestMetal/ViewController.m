//
//  ViewController.m
//  TestMetal
//
//  Created by dongzhiqiang on 2018/12/13.
//  Copyright © 2018 dongzhiqiang. All rights reserved.
//

#import "ViewController.h"
#import "ViewFor三角形.h"
#import "ViewFor图片绘制.h"
#import "ViewFor多边形.h"
#import "ViewFor三维变换.h"
#import "ViewFor摄像头渲染RGB.h"
#import "ViewFor灰度计算.h"
#import "ViewFor视频渲染YUV.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSInteger example = 2;
    CGRect subViewFrame = CGRectMake(50, 100, 300, 300);
    subViewFrame = self.view.bounds;
    if (example == 0){
        ViewFor三角形 *aView = [[ViewFor三角形 alloc] initWithFrame:subViewFrame];
        aView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:aView];
    }
    else if (example == 1){
        ViewFor图片绘制 *aView = [[ViewFor图片绘制 alloc] initWithFrame:subViewFrame];
        aView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:aView];
    }
    else if (example == 2){
        ViewFor多边形 *aView = [[ViewFor多边形 alloc] initWithFrame:subViewFrame];
        aView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:aView];
    }
    else if (example == 3){
        ViewFor三维变换 *aView = [[ViewFor三维变换 alloc] initWithFrame:subViewFrame];
        aView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:aView];
    }
    else if (example == 4){
        ViewFor摄像头渲染RGB *aView = [[ViewFor摄像头渲染RGB alloc] initWithFrame:subViewFrame];
        aView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:aView];
    }
    else if (example == 5){
        ViewFor灰度计算 *aView = [[ViewFor灰度计算 alloc] initWithFrame:subViewFrame];
        aView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:aView];
    }
    else if (example == 6){
        ViewFor视频渲染YUV *aView = [[ViewFor视频渲染YUV alloc] initWithFrame:subViewFrame];
        aView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:aView];
    }
    
}


@end
