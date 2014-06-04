//
//  DataHandle.h
//  LessonWeb
//
//  Created by 许 萍 on 14-5-10.
//  Copyright (c) 2014年 许 萍. All rights reserved.
//

//使用方式:
//DataHandle *dataHandle = [[DataHandle alloc] init];
//[dataHandle asynchronous:url HTTPMethod:@"GET" HTTPBody:nil asynchronous:^(DataHandle *dataHandle, NSURLResponse *response, NSError *error, NSData *data, id result) {
//    NSLog(@"%@", result);
//}];
//[dataHandle release];

#import <Foundation/Foundation.h>

@class DataHandle;

/// 同步请求 block
typedef void (^SynchronousBlock)(DataHandle *dataHandle, NSURLResponse *response, NSError *error, NSData *data, id result);
/// 异步请求 block
typedef void (^AsynchronousBlock)(DataHandle *dataHandle, NSURLResponse *response, NSError *error, NSData *data, id result);
/// 异步请求 delegate block
typedef void (^AsynchronousProgressDelegateBlock)(DataHandle *dataHandle, float progess);
typedef void (^AsynchronousDataDelegateBlock)(DataHandle *dataHandle, NSData *data, id result);
typedef void (^AsynchronousErrorDelegateBlock)(DataHandle *dataHandle, NSError *error);

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
