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

@implementation GFUser

+ (void)reset {
    user_address = nil;
    user_polis = nil;
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

@end
