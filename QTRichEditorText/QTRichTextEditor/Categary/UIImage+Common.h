//
//  UIImage+Common.h
//  Kangaroo
//
//  Created by QinTuanye on 2019/3/5.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UIImage (Common)

+(UIImage *)imageWithColor:(UIColor *)aColor;
+(UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;
-(UIImage*)scaledToSize:(CGSize)targetSize;
-(UIImage*)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality;
-(UIImage*)scaledToMaxSize:(CGSize )size;

+ (UIImage *)imageWithFileType:(NSString *)fileType;
+ (UIImage *)big_imageWithFileType:(NSString *)fileType;

- (NSData *)dataSmallerThan:(NSUInteger)dataLength;
- (NSData *)dataForCodingUpload;

@end
