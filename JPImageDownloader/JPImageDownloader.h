//
//  JPImageDownloader.h
//  JPImageDownloader
//
//  Created by ovopark_iOS on 16/8/2.
//  Copyright © 2016年 JaryPan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPImageOperationManager.h"
#import "JPImageOperation.h"

@interface JPImageDownloader : NSObject

// 下载图片的方法
+ (void)imageWithUrlString:(nonnull NSString *)urlString completionHandler:(void(^ _Nullable )(UIImage * _Nullable image, NSError * _Nullable error, JPImageCacheType cacheType, NSURL  * _Nullable imageURL))completionHandler;

// 停止某个图片的下载
+ (void)cancelWithUrlString:(nonnull NSString *)urlString;


/*
 如果不想有任何缓存，直接设置为0即可；
 size指的是字节大小，例如：最大硬盘缓存设置为100兆，size应为1024*1024*100
 */
// 设置最大硬盘缓存（默认500M）
+ (void)setMaxDiskCachesSize:(NSUInteger)maxSize;

// 设置最大内存缓存（默认50M）
+ (void)setMaxMemoryCachesSize:(NSUInteger)maxSize;


// 获取硬盘缓存图片大小
+ (NSUInteger)diskCachesSize;
// 获取硬盘缓存图片个数
+ (NSUInteger)diskCachesCount;
// 获取硬盘缓存图片总大小和个数
+ (void)calculateDiskCaches:(void(^ _Nullable)(NSUInteger totalSize, NSUInteger fileCount))completionHandler;

// 获取内存缓存图片大小
+ (NSUInteger)memoryCachesSize;
// 获取内存缓存图片个数
+ (NSUInteger)memoryCachesCount;
// 获取内存缓存图片总大小和个数
+ (void)calculateMemoryCaches:(void(^ _Nullable)(NSUInteger totalSize, NSUInteger fileCount))completionHandler;

// 清除硬盘缓存
+ (void)clearDiskCaches:(void(^ _Nullable)(NSError  * _Nullable  error))completionHandler;

// 清除内存缓存
+ (void)clearMemoryCaches;

@end
