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
static NSArray<GFScript *> *user_scripts;
static NSMutableArray<NSNumber *> *user_scripts_ids;

@implementation GFUser

+ (void)reset {
    user_address = nil;
    user_polis = nil;
    user_scripts_ids = nil;
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

+ (void)addScript:(int)ID {
    if (user_scripts_ids == nil) {
        user_scripts_ids = [NSMutableArray new];
        [user_scripts_ids addObject: [NSNumber numberWithInteger:ID]];
    } else {
        [user_scripts_ids addObject: [NSNumber numberWithInteger:ID]];
    }
}

+ (void)cacheScripts:(NSArray *)scripts {
    user_scripts = scripts;
}

+ (NSArray *)getScriptIDs {
    return user_scripts_ids;
}

+ (NSArray *)getScripts {
    return user_scripts;
}

@end
