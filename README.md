Web
===


IOS网络请求封装


MRC方式


使用方式:

    //    GET请求
    NSString *urlString = @"http://172.16.1.126:8888/xpmz/joke/index.php/site/articleList?page=1";
    [[DataHandle shareDataHandle] synchronous:urlString HTTPMethod:@"GET" HTTPBody:nil synchronous:^(NSURLResponse *response, NSError *error, NSData *data, id result) {
        NSLog(@"%@", result);
    }];
    [[DataHandle shareDataHandle] asynchronousDelegate:urlString HTTPMethod:@"GET" HTTPBody:nil progress:^(float progess) {
        NSLog(@"%f", progess);
    } data:^(NSData *data, id result) {
        NSLog(@"%@", result);
    } error:^(NSError *error) {
        
    }];
    
	//    POST请求
    NSString *urlString = @"http://172.16.1.126:8888/xpmz/joke/index.php/site/loging";
    NSString *bodyString = @"user_email=361131953@qq.com&user_pass=123456";
    [[DataHandle shareDataHandle] asynchronous:urlString HTTPMethod:@"POST" HTTPBody:bodyString asynchronous:^(NSURLResponse *response, NSError *error, NSData *data, id result) {
        NSLog(@"%@", result);
    }];
