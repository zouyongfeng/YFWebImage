//
//  YFCacheManager.m
//  YFImageExhibition
//
//  Created by 邹勇峰 on 2017/8/2.
//  Copyright © 2017年 邹勇峰. All rights reserved.
//

#import "YFImageCacheManager.h"
#import "UIImage+Decode.h"

@interface YFImageCacheManager()
@property (nonatomic, strong) NSCache *imageCache;
@property (nonatomic, strong) dispatch_queue_t ioQueue;
@end

@implementation YFImageCacheManager
+ (instancetype)shareManager
{
    static YFImageCacheManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YFImageCacheManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.imageCache = [[NSCache alloc] init];
        self.imageCache.totalCostLimit = 500;
        
        self.ioQueue = dispatch_queue_create("com.yf.YFWebImageCache", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}



- (void)storeImage:(UIImage *)image imageData:(NSData *)imageData forKey:(NSString *)key completion:(void (^)())completedBlock
{
    if (!image || !key) {
        if (completedBlock) {
            completedBlock();
        }
        return;
    }
    
    // 缓存
    [self.imageCache setObject:image forKey:key];
    
    dispatch_async(self.ioQueue, ^{
        @autoreleasepool {
            if (![self diskImageForKey:key]) {
                [imageData writeToFile:[self getFilePathWithURLStr:key] atomically:YES];
            }
        }
        
        if (completedBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completedBlock();
            });
        }
    });
}

- (UIImage *)imageFromMemoryCacheForKey:(NSString *)key
{
    return [self.imageCache objectForKey:key];
}

- (UIImage *)diskImageForKey:(nullable NSString *)key
{
    NSData *data = [NSData dataWithContentsOfFile:[self getFilePathWithURLStr:key]];
    if (data) {
        UIImage *image = [UIImage imageWithData:data];
        image = [UIImage decodedImageWithImage:image];
        return image;
    } else {
        return nil;
    }
}

- (NSOperation *)queryCacheOperationForKey:(NSString *)key complete:(void (^)(UIImage *))completedBlock
{
    // 条件先判断一下
    if (!key) {
        if (completedBlock) {
            completedBlock(nil);
        }
        return nil;
    }
    
    // 从缓存中取呀
    UIImage *image = [self imageFromMemoryCacheForKey:key];
    if (image) {
        if (completedBlock) {
            completedBlock(image);
        }
        return nil;
    }
    
    // 缓存中没有呀 异步去磁盘
    NSOperation *operation = [NSOperation new];
    dispatch_async(self.ioQueue, ^{ // 异步执行
        if (operation.isCancelled) {
            return;
        }
        
        @autoreleasepool {
            UIImage *diskImage = [self diskImageForKey:key];
            
            if (diskImage) {
                [self.imageCache setObject:diskImage forKey:key];
            }
            
            if (completedBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completedBlock(diskImage);
                });
            }
        }
    });
    
    return operation;
}


// 删除全部的缓存
- (void)deleteAllMemory
{
    [self.imageCache removeAllObjects];
}


// 获得图片保存的路径
- (NSString *)getFilePathWithURLStr:(NSString *)urlStr
{
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[urlStr lastPathComponent]];
    return filePath;
}

@end
