//
//  TestMatrix4.m
//  TestMetal
//
//  Created by dongzhiqiang on 2018/12/21.
//  Copyright © 2018 dongzhiqiang. All rights reserved.
//

#import "TestMatrix4.h"
#import "TestMatrix4.h"
#import <GLKit/GLKit.h>

@implementation TestMatrix4

+(void)test
{
    //生成矩阵
    GLKMatrix4 matrix4_1 = GLKMatrix4Make(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16);
    //将矩阵的行列互换得到的新矩阵称为转置矩阵
    GLKMatrix4 matrix4_2 = GLKMatrix4MakeAndTranspose(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16);
    //从数组创建矩阵
    float valueOfMatrix4[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16};
    GLKMatrix4 matrix4_3 = GLKMatrix4MakeWithArray(valueOfMatrix4);
    GLKMatrix4 matrix4_4 = GLKMatrix4MakeWithArrayAndTranspose(valueOfMatrix4);
    
    //返回由四个列向量创建的4x4矩阵
    GLKVector4 vector0 = GLKVector4Make(1, 2, 3, 4);
    GLKVector4 vector1 = GLKVector4Make(5, 6, 7, 8);
    GLKVector4 vector2 = GLKVector4Make(9, 10, 11, 12);
    GLKVector4 vector3 = GLKVector4Make(13, 14, 15, 16);
    GLKMatrix4 matrix4_5 = GLKMatrix4MakeWithColumns(vector0,vector1,vector2,vector3);
    //返回由四个行向量创建的4x4矩阵
    GLKMatrix4 matrix4_6 = GLKMatrix4MakeWithRows(vector0,vector1,vector2,vector3);
    
    //返回一个旋转矩阵
    //GLKMatrix4 GLKMatrix4MakeRotation(float radians, float x, float y, float z);
    //radians : 旋转角度，它接受一个弧度值，可以用GLKMathDegreesToRadians(30)，将角度转换为弧度
    GLKMatrix4 matrix4_7 = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(30),0,0,1);
    //返回围绕正x轴执行旋转的4x4矩阵
    GLKMatrix4 matrix4_8 = GLKMatrix4MakeXRotation(GLKMathDegreesToRadians(30));
    //返回围绕正y轴执行旋转的4x4矩阵
    GLKMatrix4 matrix4_9 = GLKMatrix4MakeYRotation(GLKMathDegreesToRadians(30));
    //返回围绕正z轴执行旋转的4x4矩阵
    GLKMatrix4 matrix4_10 = GLKMatrix4MakeZRotation(GLKMathDegreesToRadians(30));
    
    //返回基于四元数执行旋转的4x4矩阵。
    //GLKMatrix4 GLKMatrix4MakeWithQuaternion(GLKQuaternion quaternion);
    GLKQuaternion quaternion_11 = GLKQuaternionMake(1, 2, 3, 4);
    GLKMatrix4 matrix4_11 = GLKMatrix4MakeWithQuaternion(quaternion_11);
    
    //返回一个缩放矩阵：sx sy sz 分别是x y z轴方向上的缩放倍数
    //GLKMatrix4MakeScale(float sx, float sy, float sz);
    GLKMatrix4 matrix4_12 = GLKMatrix4MakeScale(2,0,0);
    
    //返回一个平移矩阵：tx ty tz 分别是在x y z 轴的移动距离，
    //GLKMatrix4MakeTranslation(float tx, float ty, float tz);
    GLKMatrix4 matrix4_13 = GLKMatrix4MakeTranslation(2,0,0);
    
    //返回一个model-view矩阵，这个矩阵会对齐从眼睛的位置到看向的位置之间的矢量与当前视域的中心线。
    /*
     GLKMatrix4 GLKMatrix4MakeLookAt(
     float eyeX, float eyeY, float eyeZ,
     float centerX, float centerY, float centerZ,
     float upX, float upY, float upZ)
     */
    GLKMatrix4 matrix4_14 = GLKMatrix4MakeLookAt(0, 0, 0.5, 0, 0, -0.3, 0.5, 0.6, 0);
    
    //返回一个正射投影的矩阵
    /*
     GLKMatrix4 GLKMatrix4MakeOrtho(float left, float right, float bottom, float top, float nearZ, float farZ);
     它定义了一个由 left、right、bottom、top、near、far 所界定的一个矩形视域。此时，视点与每个位置之间的距离对于投影将毫无影响。
     */
    GLKMatrix4 matrix4_15;
    
    //返回透视投影矩阵,快速创建透视矩阵的函数
    /*
     GLKMatrix4 GLKMatrix4MakePerspective(float fovyRadians, float aspect, float nearZ, float farZ);
     // fovyRadians是视角，它接受一个弧度值，可以用GLKMathDegreesToRadians(30)，将角度转换为弧度
     // aspect视图宽高比，nearZ近视点，farZ远视点
     */
    CGSize size = [UIScreen mainScreen].bounds.size;
    float aspect = fabs(size.width / size.height);
    GLKMatrix4 matrix4_16 = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90.0), aspect, 0.1f, 10.f);
    
    //返回一个透视投影的矩阵
    /*
     GLKMatrix4 GLKMatrix4MakeFrustum(float left, float right, float bottom, float top, float nearZ, float farZ);
     它定义了一个由 left、right、bottom、top、near、far 所界定的一个平截头体(椎体切去顶端之后的形状)视域。此时，视点与每个位置之间的距离越远，对象越小。
     */
    GLKMatrix4 matrix4_17;
    
    
    
    NSLog(@"");
}

@end
