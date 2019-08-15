//
//  ViewController+OHHTTPStub.m
//  ThirtyPartyFramework
//
//  Created by 罗孟歌 on 2019/8/12.
//  Copyright © 2019 we. All rights reserved.
//

#import "ViewController+OHHTTPStub.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>
#import <AFNetworking.h>


@implementation ViewController (OHHTTPStub)

- (void)oh_customInitMethod
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * _Nonnull request) {
        return [request.URL.host isEqualToString:@"mywebservice.com"];
    } withStubResponse:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        
//        NSError *notConnectedError = [NSError errorWithDomain:NSURLErrorDomain code:305 userInfo:nil];
//        return [OHHTTPStubsResponse responseWithError:notConnectedError];
        
        NSString *filePath = OHPathForFile(@"hello.json", self.class);
        return [[OHHTTPStubsResponse responseWithFileAtPath:filePath statusCode:200 headers:@{@"Content-Type":@"application/json"}] requestTime:0.0 responseTime:0.0];
    }];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://mywebservice.com/" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSLog(@"---%@---",responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"---%@---",error);
        }
    }];
}

@end
