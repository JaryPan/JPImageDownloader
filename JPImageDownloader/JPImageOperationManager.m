//
//  JPImageOperationManager.m
//  JPImageDownloader
//
//  Created by ovopark_iOS on 16/8/3.
//  Copyright © 2016年 JaryPan. All rights reserved.
//

#import "JPImageOperationManager.h"

static JPImageOperationManager *instance = nil;

@interface JPImageOperationManager ()

@property (strong, nonatomic) NSMutableDictionary<NSString *, JPImageOperation *> *operations;

@end

@implementation JPImageOperationManager

#pragma mark - 单例方法
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JPImageOperationManager alloc] init];
    });
    return instance;
}
// 重写init方法，保证单例地址不变
- (instancetype)init
{
    if (!instance) {
        instance = [super init];
        self.operations = [NSMutableDictionary dictionary];
    }
    return instance;
}


#pragma mark - allOperations
- (NSDictionary<NSString *,JPImageOperation *> *)allOperations
{
    return [NSDictionary dictionaryWithDictionary:self.operations];
}


#pragma mark - 增加一个操作对象
- (void)setOperation:(JPImageOperation *)operation forKey:(NSString *)key
{
    [self.operations setValue:operation forKey:key];
}

#pragma mark - 移除一个操作对象
- (void)removeOperationForKey:(NSString *)key
{
    [self.operations removeObjectForKey:key];
}


@end
