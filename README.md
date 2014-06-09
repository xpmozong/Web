Web
===


IOS网络请求封装


MRC方式


使用方式:

    //    异步请求
    NSString *urlString = @"http://172.16.1.126:8888/xpmz/joke/index.php/site/articleList?page=1";
    DataHandle *dataHandle = [[DataHandle alloc] init];
    [dataHandle synchronous:urlString HTTPMethod:@"GET" HTTPBody:nil synchronous:^(NSURLResponse *response, NSError *error, NSData *data, id result) {
        NSLog(@"%@", result);
    }];
    [dataHandle release];
    
    //    异步请求代理
    DataHandle *dataHandle2 = [[DataHandle alloc] init];
    [dataHandle2 asynchronousDelegate:urlString HTTPMethod:@"GET" HTTPBody:nil progress:^(float progess) {
        NSLog(@"%f", progess);
    } data:^(NSData *data, id result) {
        NSLog(@"%@", result);
    } error:^(NSError *error) {
        
    }];
    [dataHandle2 release];
    
    //    异步请求
    DataHandle *dataHandle3 = [[DataHandle alloc] init];
    NSString *urlString = @"http://172.16.1.126:8888/xpmz/joke/index.php/site/loging";
    NSString *bodyString = @"user_email=361131953@qq.com&user_pass=123456";
    [dataHandle3 asynchronous:urlString HTTPMethod:@"POST" HTTPBody:bodyString asynchronous:^(NSURLResponse *response, NSError *error, NSData *data, id result) {
        NSLog(@"%@", result);
    }];
    [dataHandle3 release];
