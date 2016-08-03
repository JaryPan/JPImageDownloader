//
//  JPImageOperationManager.h
//  JPImageDownloader
//
//  Created by ovopark_iOS on 16/8/3.
//  Copyright © 2016年 JaryPan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JPImageOperation;

@interface JPImageOperationManager : NSObject

// 单例方法
+ (nonnull instancetype)sharedManager;

// 所有操作对象（只读）
@property (strong, nonatomic, readonly, nonnull) NSDictionary<NSString *, JPImageOperation *> *allOperations;

// 增加一个操作对象
- (void)setOperation:(nonnull JPImageOperation *)operation forKey:(nonnull NSString *)key;
// 移除一个操作对象
- (void)removeOperationForKey:(nonnull NSString *)key;

@end
