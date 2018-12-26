//
//  ViewFor多边形Triangle.m
//  TestMetal
//
//  Created by dongzhiqiang on 2018/12/25.
//  Copyright © 2018 dongzhiqiang. All rights reserved.
//

#import "ViewFor多边形Triangle.h"
#import "triangle.h"
#import <UIKit/UIKit.h>

@implementation ViewFor多边形Triangle

+(NSArray *)parseTriangle:(NSArray *)dataList
{
    int nPoints = dataList.count;
    
    CPolyTri      triangle;
    Vector3F*   points   = new Vector3F[nPoints];
    float       Area=0.0f;
    //
    for( int i=0 ; i < nPoints ; i++ ){
        NSValue *value = dataList[i];
        CGPoint point = value.CGPointValue;
        points[i][0]   = point.x;
        points[i][1]   = point.y;
        if( i ){
            NSValue *value = dataList[i];
            CGPoint point1 = value.CGPointValue;
          Area+= ( point.x * point1.y - point1.x * point.y) * 0.5f;
        }
    }
    int   nTriangle=triangle.Triangulate(points,
                                         Vector3F(0.0f,0.0f,( Area > 0.0f ? -111.0f : 111.0f ) ),
                                         nPoints);
    
    NSMutableArray *tmpArray = [NSMutableArray new];
    for (int i = 0 ; i < nTriangle; i++){
        Vector3F tmp = points[i];
        float x = tmp.m_v[0];
        float y = tmp.m_v[1];
        float z = tmp.m_v[2];
        [tmpArray addObject:@[@(x),@(y),@(z)]];
    }
    
    printf("");
    
    return tmpArray.copy;
}

@end
