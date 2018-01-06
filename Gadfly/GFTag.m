//
//  GFTag.m
//  Gadfly
//
//  Created by Ziwen Chen on 1/6/18.
//  Copyright © 2018 G-FORVM. All rights reserved.
//

#import "GFTag.h"

static NSMutableDictionary *tags;

static const NSString *URL = @"http://gadfly.mobi/services/v1/alltags";
static const NSString *APIKey = @"v1key";
static const NSTimeInterval timeoutInterval = 60.0;

@implementation GFTag

+ (void)initTags {
    NSURL *url=[NSURL URLWithString:URL];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeoutInterval];
    [req setHTTPMethod:@"GET"];
    [req setValue:APIKey forHTTPHeaderField:@"APIKey"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Fetch ID Unseccessful!");
            return;
        }
        if (!(response)){
            NSLog(@"No Response!");
            return;
        }
        NSLog(@"Successful!");
        
        NSError *JSONParsingError;
        tags = [NSMutableDictionary new];
        tags = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONParsingError];
        
    }];
    [task resume];
}

+ (NSDictionary *)getTags {
    return tags;
}

@end
