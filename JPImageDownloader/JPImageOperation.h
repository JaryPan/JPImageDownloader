//
//  JPImageOperation.h
//  JPImageDownloader
//
//  Created by ovopark_iOS on 16/8/2.
//  Copyright © 2016年 JaryPan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPImageCaches.h"

@interface JPImageOperation : NSObject

- (nonnull instancetype)initWithUrlString:(nonnull NSString *)urlString;

@property (copy, nonatomic, readonly, nullable) NSString *imageURLString;

// 开始下载图片
- (void)startDownloadImage:(void(^ _Nullable )(UIImage * _Nullable image, NSError * _Nullable error, JPImageCacheType cacheType, NSURL  * _Nullable imageURL))completionHandler;

// 停止下载图片
- (void)stopDownloadImage;

@end
