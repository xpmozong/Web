//
//  DataHandle.h
//  LessonWeb
//
//  Created by 许 萍 on 14-5-10.
//  Copyright (c) 2014年 许 萍. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 同步请求 block
typedef void (^SynchronousBlock)(NSURLResponse *response, NSError *error, NSData *data, id result);
/// 异步请求 block
typedef void (^AsynchronousBlock)(NSURLResponse *response, NSError *error, NSData *data, id result);
/// 异步请求 delegate block
typedef void (^AsynchronousProgressDelegateBlock)(float progess);
typedef void (^AsynchronousDataDelegateBlock)(NSData *data, id result);
typedef void (^AsynchronousErrorDelegateBlock)(NSError *error);

@interface DataHandle : NSObject<NSURLConnectionDataDelegate>

@property (nonatomic, assign) long long totalLength;
@property (nonatomic, retain) NSMutableData *receiveData;
@property (nonatomic, assign) float progess;

#pragma mark - 便利方法
+ (DataHandle *)shareDataHandle;

#pragma mark - 实例方法
/// 同步请求
- (void)synchronous:(NSString *)urlString HTTPMethod:(NSString *)HTTPMethod HTTPBody:(NSString *)HTTPBody synchronous:(SynchronousBlock)synchronous;

/// 异步请求
- (void)asynchronous:(NSString *)urlString HTTPMethod:(NSString *)HTTPMethod HTTPBody:(NSString *)HTTPBody asynchronous:(AsynchronousBlock)asynchronous;

/// 异步请求 delegate
- (void)asynchronousDelegate:(NSString *)urlString HTTPMethod:(NSString *)HTTPMethod HTTPBody:(NSString *)HTTPBody progress:(AsynchronousProgressDelegateBlock)progress data:(AsynchronousDataDelegateBlock)data error:(AsynchronousErrorDelegateBlock)error;


@end
