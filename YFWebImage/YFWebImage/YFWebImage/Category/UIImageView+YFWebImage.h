//
//  UIImageView+YFAdd.h
//  YFImageExhibition
//
//  Created by 邹勇峰 on 2017/8/3.
//  Copyright © 2017年 邹勇峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFWebImageManager.h"


@interface UIImageView (YFWebImage)
/**
 通过url设置图片（来源：网络或本地）
 
 @param url 图片的url
 */
- (void)setImageWithURL:(NSURL *)url;

/**
 通过url设置图片（来源：网络或本地）
 
 @param url 图片的url
 @param placeholderImage 占位图片
 */
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage;

/**
 通过url设置图片（来源：网络或本地）
 
 @param url 图片的url
 @param placeholderImage 占位图片
 @param completedBlock 完成回调
 */
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage completedBlock:(YFImageDownloadCompletedBlock)completedBlock;
@end
