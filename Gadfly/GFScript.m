//
//  GFScript.m
//  Gadfly
//
//  Created by Ziwen Chen on 1/6/18.
//  Copyright © 2018 G-FORVM. All rights reserved.
//

#import "GFScript.h"

static NSString *idFromQRCode;
static GFScript *tempScript;

static const NSString *idURL = @"http://gadfly.mobi/services/v1/id";
static const NSString *scriptURL = @"http://gadfly.mobi/services/v1/script";
static const NSString *APIKey = @"v1key";
static const NSTimeInterval timeoutInterval = 60.0;

@implementation GFScript

+ (void)cacheID:(NSString *)scriptID {
    idFromQRCode=scriptID;
}

+ (NSString *)getID {
    return idFromQRCode;
}

+ (void)cacheScript:(GFScript *)script {
    tempScript = script;
}

+ (GFScript *)getScript {
    return tempScript;
}

- (GFScript *)initWithDictionary:(NSDictionary *)dict {
    GFScript *script=[GFScript new];
    script.title=[dict valueForKey:@"title"];
    script.content=[dict valueForKey:@"content"];
    if ([dict valueForKey:@"tags"]!=(id)[NSNull null]) {
        script.tags=[NSMutableArray new];
        for (NSString *tag in [dict valueForKey:@"tags"]) {
            [script.tags addObject:tag];
        }
    }
    return script;
}

+ (void)fetchIDtWithTicket:(NSString *)ticket
         completionHandler:(void(^_Nonnull)(NSDictionary *))completion {
    NSMutableArray *queryItems = [NSMutableArray<NSURLQueryItem *> new];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"ticket" value:ticket]];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:idURL];
    components.queryItems = queryItems;
    NSURL *URL = components.URL;
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeoutInterval];
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
        NSDictionary *result=[NSDictionary new];
        NSError *JSONParsingError;
        result=[NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONParsingError];
        completion(result);
    }];
    [task resume];
}

+ (void)fetchScriptWithID:(NSString *)ID
        completionHandler:(void(^_Nonnull)(GFScript *))completion {
    NSMutableArray *queryItems = [NSMutableArray<NSURLQueryItem *> new];
    
    //NSString *IDS = [NSString stringWithFormat: @"%s", ID];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"id" value:ID]];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:scriptURL];
    components.queryItems = queryItems;
    NSURL *URL = components.URL;
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeoutInterval];
    [req setHTTPMethod:@"GET"];
    [req setValue:APIKey forHTTPHeaderField:@"APIKey"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Fetch Script Unseccessful!");
            return;
        }
        if (!(response)){
            NSLog(@"No Response!");
            return;
        }
        NSLog(@"Successful!");
        NSDictionary *result=[NSDictionary new];
        NSError *JSONParsingError;
        result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONParsingError];
        NSString *status=[result valueForKey:@"Status"];
        if (![status isEqualToString:@"OK"]) {
            GFScript *error=[GFScript new];
            error.title=status;
            error.content=@"";
            completion(error);
        }
        else {
            NSLog(@"Successfully got scrip!!!");
            NSDictionary *scriptData=[NSDictionary new];
            scriptData=[result valueForKey:@"Script"];
            GFScript *script=[[GFScript alloc]initWithDictionary:scriptData];
            completion(script);
        }
    }];
    [task resume];
}

+ (void)submitScriptWithDictionary:(NSDictionary *)dict
                 completionHandler:(void(^_Nonnull)(NSDictionary *))completion {
    NSURL *URL = [NSURL URLWithString:scriptURL];
    NSString *post = [NSString stringWithFormat:@"title=%@&content=%@&tags=%@&tags=%@",[dict valueForKey:@"title"],[dict valueForKey:@"content"],[dict valueForKey:@"tag1"],[dict valueForKey:@"tag2"]];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] init];
    [req setURL: URL];
    [req setHTTPMethod:@"POST"];
    [req setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody:postData];
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
        NSDictionary *result=[NSDictionary new];
        NSError *JSONParsingError;
        result=[NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONParsingError];
        completion(result);
    }];
    
    [task resume];

}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.content forKey:@"content"];
    [encoder encodeObject:self.tags forKey:@"tags"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.title = [decoder decodeObjectForKey:@"title"];
        self.content = [decoder decodeObjectForKey:@"content"];
        self.tags = [decoder decodeObjectForKey:@"tags"];
    }
    return self;
}

@end
