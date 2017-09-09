//
//  UIImageView+YFAdd.m
//  YFImageExhibition
//
//  Created by 邹勇峰 on 2017/8/3.
//  Copyright © 2017年 邹勇峰. All rights reserved.
//

#import "UIImageView+YFWebImage.h"
#import "YFImageCacheManager.h"
#import <objc/runtime.h>

static char urlKey;

@implementation UIImageView (YFAdd)
- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil completedBlock:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage
{
    [self setImageWithURL:url placeholderImage:placeholderImage completedBlock:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage completedBlock:(YFImageDownloadCompletedBlock)completedBlock
{
    if (placeholderImage) {
        self.image = placeholderImage;
    } else {
        self.image = [UIImage imageNamed:@""];
    }
            
    
    if (url == nil || url.absoluteString.length == 0) {
        completedBlock(nil, [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:nil], nil);
        return;
    }
    
    if ([url isKindOfClass:NSString.class]) {
        url = [NSURL URLWithString:(NSString *)url];
    }
    

    // 获取当前视图 上一次的 urlkey
    NSString *lastKey = [self getURLKey];
    
    // 移除
    [[YFWebImageManager shareManager] cancleOpeartionWithURL:[NSURL URLWithString:lastKey]];
    
    
    
    [[YFWebImageManager shareManager] addOperationWithURL:url completed:^(UIImage *image, NSError *error, NSURL *imageURL) {
        self.image = image;
        if (completedBlock) completedBlock(image, nil, url);
    }];
    
    [self setURLKey:url.absoluteString];
}

// 获取urlkey
- (NSString *)getURLKey
{
    return objc_getAssociatedObject(self, &urlKey);
}

// 设置urlkey
- (void)setURLKey:(NSString *)urlStr
{
    objc_setAssociatedObject(self, &urlKey, urlStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
