//
//  JPImageDownloader.m
//  JPImageDownloader
//
//  Created by ovopark_iOS on 16/8/2.
//  Copyright © 2016年 JaryPan. All rights reserved.
//

#import "JPImageDownloader.h"

@implementation JPImageDownloader

#pragma mark - 下载图片的方法
+ (void)imageWithUrlString:(NSString *)urlString completionHandler:(void (^)(UIImage * _Nullable, NSError * _Nullable, JPImageCacheType, NSURL * _Nullable))completionHandler
{
    JPImageOperation *operation = [[JPImageOperation alloc] initWithUrlString:urlString];
    [operation startDownloadImage:^(UIImage * _Nullable image, NSError * _Nullable error, JPImageCacheType cacheType, NSURL * _Nullable imageURL) {
        // 移除对应的操作对象
        if ([[JPImageOperationManager sharedManager].allOperations.allKeys containsObject:urlString]) {
            // 移除操作对象
            [[JPImageOperationManager sharedManager] removeOperationForKey:urlString];
        }
        // 实现回调
        if (completionHandler) {
            completionHandler(image, error, cacheType, imageURL);
        }
    }];
    
    // 记录操作对象
    [[JPImageOperationManager sharedManager] setOperation:operation forKey:urlString];
}

#pragma mark - 停止某个图片的下载
+ (void)cancelWithUrlString:(NSString *)urlString
{
    if ([[JPImageOperationManager sharedManager].allOperations.allKeys containsObject:urlString]) {
        // 停止任务
        [(JPImageOperation *)([JPImageOperationManager sharedManager].allOperations[urlString]) stopDownloadImage];
        // 移除操作对象
        [[JPImageOperationManager sharedManager] removeOperationForKey:urlString];
        
    }
}


#pragma mark - 设置最大硬盘缓存（默认500M）
+ (void)setMaxDiskCachesSize:(NSUInteger)maxSize
{
    [JPImageCaches sharedCaches].maxDiskCachesSize = maxSize;
}

#pragma mark - 设置最大内存缓存（默认50M）
+ (void)setMaxMemoryCachesSize:(NSUInteger)maxSize
{
    [JPImageCaches sharedCaches].maxMemoryCachesSize = maxSize;
}


#pragma mark - 获取硬盘缓存图片大小
+ (NSUInteger)diskCachesSize
{
    return [[JPImageCaches sharedCaches] diskCachesSize];
}
#pragma mark - 获取硬盘缓存图片个数
+ (NSUInteger)diskCachesCount
{
    return [[JPImageCaches sharedCaches] diskCachesCount];
}
// 获取硬盘缓存图片总大小和个数
+ (void)calculateDiskCaches:(void(^ _Nullable)(NSUInteger totalSize, NSUInteger fileCount))completionHandler
{
    [[JPImageCaches sharedCaches] calculateDiskCaches:^(NSUInteger totalSize, NSUInteger fileCount) {
        if (completionHandler) {
            completionHandler(totalSize, fileCount);
        }
    }];
}

#pragma mark - 获取内存缓存图片大小
+ (NSUInteger)memoryCachesSize
{
    return [[JPImageCaches sharedCaches] memoryCachesSize];
}
#pragma mark - 获取内存缓存图片个数
+ (NSUInteger)memoryCachesCount
{
    return [[JPImageCaches sharedCaches] memoryCachesCount];
}
#pragma mark - 获取内存缓存图片总大小和个数
+ (void)calculateMemoryCaches:(void(^ _Nullable)(NSUInteger totalSize, NSUInteger fileCount))completionHandler
{
    [[JPImageCaches sharedCaches] calculateMemoryCaches:^(NSUInteger totalSize, NSUInteger fileCount) {
        if (completionHandler) {
            completionHandler(totalSize, fileCount);
        }
    }];
}

#pragma mark - 清除硬盘缓存
+ (void)clearDiskCaches:(void(^ _Nullable)(NSError  * _Nullable  error))completionHandler
{
    [[JPImageCaches sharedCaches] clearDiskCaches:^(NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(error);
        }
    }];
}

#pragma mark - 清除内存缓存
+ (void)clearMemoryCaches
{
    [[JPImageCaches sharedCaches] clearMemoryCaches];
}

@end
