//
//  JPImageCaches.m
//  JPImageDownloader
//
//  Created by ovopark_iOS on 16/8/2.
//  Copyright © 2016年 JaryPan. All rights reserved.
//

#import "JPImageCaches.h"

static JPImageCaches *instance = nil;

@interface JPImageCaches ()

@property (strong, atomic) NSMutableDictionary<NSString *, UIImage *> *memoryCaches;

@end

@implementation JPImageCaches

#pragma mark - 单例方法
+ (instancetype)sharedCaches
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JPImageCaches alloc] init];
    });
    return instance;
}
// 重写init方法，保证单例地址不变
- (instancetype)init
{
    if (!instance) {
        instance = [super init];
        self.maxDiskCachesSize = 1024 * 1024 * 500;
        self.maxMemoryCachesSize = 1024 * 1024 * 50;
        [instance createCachesFile];
        self.memoryCaches = [NSMutableDictionary dictionary];
    }
    return instance;
}
// 创建文件夹
- (void)createCachesFile
{
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"JPImageCaches"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

#pragma mark - setMaxDiskCachesSize
- (void)setMaxDiskCachesSize:(NSUInteger)maxDiskCachesSize
{
    _maxDiskCachesSize = maxDiskCachesSize;
    
    if ([self diskCachesSize] >= maxDiskCachesSize) {
        [self clearDiskCaches:nil];
    }
}
#pragma mark - setMaxMemoryCachesSize
- (void)setMaxMemoryCachesSize:(NSUInteger)maxMemoryCachesSize
{
    _maxMemoryCachesSize = maxMemoryCachesSize;
    
    if ([self memoryCachesSize] >= maxMemoryCachesSize) {
        [self clearMemoryCaches];
    }
}

#pragma mark - 获取缓存文件夹路径
- (NSString *)cachesFilePath
{
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"JPImageCaches"];
}

#pragma mark - 缓存图片
- (void)cacheImage:(UIImage *)image withName:(NSString *)imageName forCacheType:(JPImageCacheType)cacheType
{
    dispatch_async(dispatch_queue_create(nil, nil), ^{
        switch (cacheType) {
            case JPImageCacheTypeNone:
                // 下载的图片
                
                // 判断硬盘中缓存大小是否超过上限
                if ([self diskCachesSize] >= self.maxDiskCachesSize) {
                    [self clearDiskCaches:nil];
                }
                // 缓存到硬盘中
                [UIImagePNGRepresentation(image) writeToFile:[[self cachesFilePath] stringByAppendingPathComponent:imageName] atomically:YES];
                
                // 判断内存中缓存大小是否超过上限
                if ([self memoryCachesSize] >= self.maxMemoryCachesSize) {
                    [self clearMemoryCaches];
                }
                // 缓存到内存中
                [self.memoryCaches setValue:image forKey:imageName];
                
                break;
                
            case JPImageCacheTypeDisk:
                // 硬盘缓存的图片
                
                // 判断内存中缓存大小是否超过上限
                if ([self memoryCachesSize] >= self.maxMemoryCachesSize) {
                    [self clearMemoryCaches];
                }
                // 缓存到内存中
                [self.memoryCaches setValue:image forKey:imageName];
                
                break;
                
            default:
                break;
        }
    });
}

#pragma mark - 获取硬盘中的缓存图片
- (UIImage *)imageInDiskCaches:(NSString *)imageName
{
    NSString *imagePath = [[self cachesFilePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        return [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
    }
    return nil;
}

#pragma mark - 获取内存中的缓存图片
- (UIImage *)imageInMemoryCaches:(NSString *)imageName
{
    return self.memoryCaches[imageName];
}

#pragma mark - 获取硬盘缓存图片大小
- (NSUInteger)diskCachesSize
{
    __block NSUInteger size = 0;
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:[self cachesFilePath]];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [[self cachesFilePath] stringByAppendingPathComponent:fileName];
        size += [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return size;
}
#pragma mark - 获取硬盘缓存图片个数
- (NSUInteger)diskCachesCount
{
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:[self cachesFilePath]];
    return [[fileEnumerator allObjects] count];
}
#pragma mark - 获取硬盘缓存图片总大小和个数
- (void)calculateDiskCaches:(void (^)(NSUInteger, NSUInteger))completionHandler
{
    dispatch_async(dispatch_queue_create(nil, nil), ^{
        __block NSUInteger size = 0;
        NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:[self cachesFilePath]];
        NSUInteger fileCount = 0;
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [[self cachesFilePath] stringByAppendingPathComponent:fileName];
            size += [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
            fileCount++;
        }
        if (completionHandler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(size, fileCount);
            });
        }
    });
}

#pragma mark - 获取内存缓存图片大小
- (NSUInteger)memoryCachesSize
{
    NSUInteger size = 0;
    for (UIImage *image in [self.memoryCaches allValues]) {
        size += sizeof(image);
    }
    return size;
}
#pragma mark - 获取内存缓存图片个数
- (NSUInteger)memoryCachesCount
{
    return [[self.memoryCaches allValues] count];
}
#pragma mark - 获取内存缓存图片总大小和个数
- (void)calculateMemoryCaches:(void (^)(NSUInteger, NSUInteger))completionHandler
{
    dispatch_async(dispatch_queue_create(nil, nil), ^{
        NSUInteger size = 0;
        for (UIImage *image in [self.memoryCaches allValues]) {
            size += UIImagePNGRepresentation(image).length;
        }
        NSUInteger totalCount = [[self.memoryCaches allValues] count];
        if (completionHandler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(size, totalCount);
            });
        }
    });
}

#pragma mark - 清除硬盘缓存
- (void)clearDiskCaches:(void (^)(NSError * _Nullable))completionHandler
{
    dispatch_async(dispatch_queue_create(nil, nil), ^{
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:[self cachesFilePath] error:&error];
        [self createCachesFile];
        if (completionHandler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(error);
            });
        }
    });
}

#pragma mark - 清除内存缓存
- (void)clearMemoryCaches
{
    [self.memoryCaches removeAllObjects];
}

@end
