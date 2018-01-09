//
//  GFUser.m
//  Gadfly
//
//  Created by Ziwen Chen on 1/6/18.
//  Copyright © 2018 G-FORVM. All rights reserved.
//

#import "GFUser.h"

static NSString *user_address;
static NSArray *user_polis;
static NSMutableArray *user_scripts;

@implementation GFUser

+ (void)reset {
    user_address = nil;
    user_polis = nil;
    user_scripts = nil;
}


+ (void)cacheAddress:(NSString *)address {
    user_address=address;
}

+ (NSString *)getAddress {
    return user_address;
}

+ (void)cachePolis:(NSArray *)polis {
    user_polis=polis;
}

+ (NSArray *)getPolis {
    return user_polis;
}

+ (void)addScript:(GFScript *)script {
    if (user_scripts == nil) {
        user_scripts = [NSMutableArray new];
        [user_scripts addObject:script];
    } else {
        [user_scripts addObject:script];
    }
}

+ (NSArray *)getScripts {
    return user_scripts;
}

@end
