//
//  JPImageOperation.m
//  JPImageDownloader
//
//  Created by ovopark_iOS on 16/8/2.
//  Copyright © 2016年 JaryPan. All rights reserved.
//

#import "JPImageOperation.h"

@interface JPImageOperation ()

@property (strong, nonatomic) NSURLSessionDownloadTask *dataTask;
@property (copy, nonatomic) NSString *urlString;

@end

@implementation JPImageOperation

- (instancetype)initWithUrlString:(NSString *)urlString
{
    if (self = [super init]) {
        self.urlString = urlString;
    }
    return self;
}

#pragma mark - imageURLString
- (NSString *)imageURLString
{
    return self.urlString;
}

#pragma mark - 开始下载图片
- (void)startDownloadImage:(void (^)(UIImage * _Nullable, NSError * _Nullable, JPImageCacheType, NSURL * _Nullable))completionHandler
{
    if (self.urlString.length == 0) {
        if (completionHandler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [NSError errorWithDomain:@"imageUrlString cannot be nil or its length cannont be zero." code:0 userInfo:nil];
                completionHandler(nil, error, -999, nil);
            });
        }
        return;
    }
    
    dispatch_async(dispatch_queue_create(nil, nil), ^{
        // 处理图片名称
        NSString *imageName = [self.urlString stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
        
        UIImage *image = nil;
        
        // 查看内存中是否有图片
        image = [[JPImageCaches sharedCaches] imageInMemoryCaches:imageName];
        if (image) {
            // 缓存图片
            [[JPImageCaches sharedCaches] cacheImage:image withName:imageName forCacheType:JPImageCacheTypeMemory];
            // 判断是否实现block
            if (completionHandler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(image, nil, JPImageCacheTypeMemory, [NSURL URLWithString:self.urlString]);
                });
            }
            return;
        }
        
        // 查看硬盘中是否有图片
        image = [[JPImageCaches sharedCaches] imageInDiskCaches:imageName];
        if (image) {
            // 缓存图片
            [[JPImageCaches sharedCaches] cacheImage:image withName:imageName forCacheType:JPImageCacheTypeDisk];
            // 判断是否实现block
            if (completionHandler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(image, nil, JPImageCacheTypeDisk, [NSURL URLWithString:self.urlString]);
                });
            }
            return;
        }
        
        // 下载图片
        [self stopDownloadImage];
        
        self.dataTask = [[NSURLSession sharedSession] downloadTaskWithURL:[NSURL URLWithString:self.urlString] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            // 拿到图片
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            // 缓存图片
            [[JPImageCaches sharedCaches] cacheImage:image withName:imageName forCacheType:JPImageCacheTypeNone];
            // 判断是否实现block
            if (completionHandler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(image, error, JPImageCacheTypeNone, [NSURL URLWithString:self.urlString]);
                });
            }
        }];
        
        [self.dataTask resume];
    });
}
#pragma mark - 停止下载图片
- (void)stopDownloadImage
{
    [self.dataTask cancel];
}

@end
