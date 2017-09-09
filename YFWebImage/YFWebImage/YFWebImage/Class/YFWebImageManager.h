//
//  YFOperationManager.h
//  YFImageExhibition
//
//  Created by 邹勇峰 on 2017/8/3.
//  Copyright © 2017年 邹勇峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFImageDownloadOperation.h"
#import <UIKit/UIKit.h>

typedef void (^YFImageDownloadCompletedBlock) (UIImage *image, NSError * error, NSURL *imageURL);

@protocol YFWebImageOperationProtocol <NSObject>
@required
- (void)cancel;
@end

@interface YFWebImageManager : NSObject
/**
 单例
 */
+ (instancetype)shareManager;

/**
 添加操作
 
 @param url 图片的url
 @param completedBlock 完成后回调
 */
- (void)addOperationWithURL:(NSURL *)url completed:(YFImageDownloadCompletedBlock)completedBlock;

/**
 取消操作
 
 @param url 图片的url
 */
- (void)cancleOpeartionWithURL:(NSURL *)url;
@end
