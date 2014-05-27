Web
===

网络请求封装

使用方式:
DataHandle *dataHandle = [[DataHandle alloc] init];
[dataHandle asynchronous:url HTTPMethod:@"GET" HTTPBody:nil asynchronous:^(DataHandle *dataHandle, NSURLResponse *response, NSError *error, NSData *data, id result) {
    NSLog(@"%@", result);
}];
[dataHandle release];
