//
//  JPImageCaches.h
//  JPImageDownloader
//
//  Created by ovopark_iOS on 16/8/2.
//  Copyright © 2016年 JaryPan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JPImageCacheType) {
    /**
     * The image wasn't available in the JPImageCaches, but was downloaded from the web.
     */
    JPImageCacheTypeNone,
    /**
     * The image was obtained from the disk cache.
     */
    JPImageCacheTypeDisk,
    /**
     * The image was obtained from the memory cache.
     */
    JPImageCacheTypeMemory
};

@interface JPImageCaches : NSObject

// 单例方法
+ (nonnull instancetype)sharedCaches;

// 最大硬盘缓存（默认500M）
@property (nonatomic) NSUInteger maxDiskCachesSize;
// 最大内存缓存（默认50M）
@property (nonatomic) NSUInteger maxMemoryCachesSize;

// 获取缓存文件夹路径
- (nonnull NSString *)cachesFilePath;

// 缓存图片
- (void)cacheImage:(nonnull UIImage *)image withName:(nonnull NSString *)imageName forCacheType:(JPImageCacheType)cacheType;

// 获取硬盘中的缓存图片
- (nullable UIImage *)imageInDiskCaches:(nonnull NSString *)imageName;

// 获取内存中的缓存图片
- (nullable UIImage *)imageInMemoryCaches:(nonnull NSString *)imageName;

// 获取硬盘缓存图片大小
- (NSUInteger)diskCachesSize;
// 获取硬盘缓存图片个数
- (NSUInteger)diskCachesCount;
// 获取硬盘缓存图片总大小和个数
- (void)calculateDiskCaches:(void(^ _Nullable)(NSUInteger totalSize, NSUInteger fileCount))completionHandler;

// 获取内存缓存图片大小
- (NSUInteger)memoryCachesSize;
// 获取内存缓存图片个数
- (NSUInteger)memoryCachesCount;
// 获取内存缓存图片总大小和个数
- (void)calculateMemoryCaches:(void(^ _Nullable)(NSUInteger totalSize, NSUInteger fileCount))completionHandler;

// 清除硬盘缓存
- (void)clearDiskCaches:(void(^ _Nullable)(NSError  * _Nullable  error))completionHandler;

// 清除内存缓存
- (void)clearMemoryCaches;

@end
