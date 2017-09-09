//
//  YFImageDownloadOperation.h
//  YFImageExhibition
//
//  Created by 邹勇峰 on 2017/8/8.
//  Copyright © 2017年 邹勇峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YFImageDownloadOperation : NSOperation
/**
 初始化一个操作 异步执行
 
 @param url 图片的url
 @param complete 完成后回调
 */
- (instancetype)initWithURL:(NSURL *)url complete:(void (^)(UIImage *image))complete;
@end
