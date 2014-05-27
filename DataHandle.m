//
//  DataHandle.m
//  LessonWeb
//
//  Created by 许 萍 on 14-5-10.
//  Copyright (c) 2014年 许 萍. All rights reserved.
//

#import "DataHandle.h"

@interface DataHandle () {
    SynchronousBlock didSynchronous;
    AsynchronousBlock didAsynchronous;
    AsynchronousProgressDelegateBlock didAsynchronousProgress;
    AsynchronousDataDelegateBlock didAsynchronousData;
    AsynchronousErrorDelegateBlock didAsynchronousError;
    CacheImageBlock didCacheImage;
}

@end

@implementation DataHandle

- (id)init
{
    self = [super init];
    if (self) {
        self.receiveData = [NSMutableData data];
    }
    return self;
}

- (void)dealloc
{
    [_receiveData release];
    
    [super dealloc];
}

#pragma mark - 便利方法
static DataHandle *handle = nil;
+ (DataHandle *)shareDataHandle
{
    if (handle == nil) {
        handle = [[DataHandle alloc] init];
    }
    return handle;
}

#pragma mark - 私有方法
/// 请求 request
- (NSURLRequest *)getRequest:(NSString *)urlString HTTPMethod:(NSString *)HTTPMethod HTTPBody:(NSString *)HTTPBody
{
    const char *str = [urlString UTF8String];
    NSString *url = [NSString stringWithUTF8String:str];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *requestUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [request setHTTPMethod:HTTPMethod];
    [request setHTTPBody:[HTTPBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    return [request autorelease];
}

/// json解析
- (id)getSerializationData:(NSData *)data
{
    id result = nil;
    if (data != nil) {
        result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    }
    
    return result;
}

#pragma mark - 实例方法
/// 同步请求
- (void)synchronous:(NSString *)urlString HTTPMethod:(NSString *)HTTPMethod HTTPBody:(NSString *)HTTPBody synchronous:(SynchronousBlock)synchronous
{
    didSynchronous = [synchronous copy];
    
    NSURLRequest *request = [self getRequest:urlString HTTPMethod:HTTPMethod HTTPBody:HTTPBody];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (didSynchronous != nil) {
        id result = [self getSerializationData:data];
        didSynchronous(self, response, error, data, result);
    }
}

/// 异步请求
- (void)asynchronous:(NSString *)urlString HTTPMethod:(NSString *)HTTPMethod HTTPBody:(NSString *)HTTPBody asynchronous:(AsynchronousBlock)asynchronous
{
    didAsynchronous = [asynchronous copy];
    
    NSURLRequest *request = [self getRequest:urlString HTTPMethod:HTTPMethod HTTPBody:HTTPBody];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (didAsynchronous != nil) {
            id result = [self getSerializationData:data];
            didAsynchronous(self, response, connectionError, data, result);
        }
    }];
    [queue release];
}

/// 异步请求 delegate
- (void)asynchronousDelegate:(NSString *)urlString HTTPMethod:(NSString *)HTTPMethod HTTPBody:(NSString *)HTTPBody progress:(AsynchronousProgressDelegateBlock)progress data:(AsynchronousDataDelegateBlock)data error:(AsynchronousErrorDelegateBlock)error
{
    didAsynchronousProgress = [progress copy];
    didAsynchronousData = [data copy];
    didAsynchronousError = [error copy];
    
    NSURLRequest *request = [self getRequest:urlString HTTPMethod:HTTPMethod HTTPBody:HTTPBody];
    NSURLConnection *connetion = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connetion release];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // 读取总长度
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    self.totalLength = [[[res allHeaderFields] objectForKey:@"Content-Length"] longLongValue];
    [self.receiveData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // 进行数据拼接，计算进度
    [self.receiveData appendData:data];
    NSUInteger currentLength = [self.receiveData length];
    float progess = 1.0 * currentLength / _totalLength;
    if (didAsynchronousProgress != nil) {
        didAsynchronousProgress(self, progess);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // 数据解析，以及数据使用
    if (didAsynchronousData != nil) {
        id result = [self getSerializationData:_receiveData];
        didAsynchronousData(self, _receiveData, result);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // 错误处理
    if (didAsynchronousError != nil) {
        didAsynchronousError(self, error);
    }
}

@end
