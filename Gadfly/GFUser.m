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
static NSMutableArray<GFScript *> *user_scripts;

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
    NSData *storedEncodedScripts = [[NSUserDefaults standardUserDefaults] objectForKey:@"scripts"];

    if (storedEncodedScripts != nil) {
        NSMutableArray *user_scripts = [NSKeyedUnarchiver unarchiveObjectWithData:storedEncodedScripts];
        [user_scripts addObject:script];
        NSData *encodedScripts = [NSKeyedArchiver archivedDataWithRootObject:user_scripts];
        [[NSUserDefaults standardUserDefaults] setObject:encodedScripts forKey:@"scripts"];
    } else {
        NSMutableArray *user_scripts = [NSMutableArray new];
        [user_scripts addObject:script];
        NSData *encodedScripts = [NSKeyedArchiver archivedDataWithRootObject:user_scripts];
        [[NSUserDefaults standardUserDefaults] setObject:encodedScripts forKey:@"scripts"];
    }
}

+ (void)removeScript:(int)index {
    NSData *storedEncodedScripts = [[NSUserDefaults standardUserDefaults] objectForKey:@"scripts"];
    
    if (storedEncodedScripts != nil) {
        NSMutableArray *user_scripts = [NSKeyedUnarchiver unarchiveObjectWithData:storedEncodedScripts];
        [user_scripts removeObjectAtIndex:index];
        NSData *encodedScripts = [NSKeyedArchiver archivedDataWithRootObject:user_scripts];
        [[NSUserDefaults standardUserDefaults] setObject:encodedScripts forKey:@"scripts"];
    }
}

+ (NSArray *)getScripts {
    NSData *storedEncodedScripts = [[NSUserDefaults standardUserDefaults] objectForKey:@"scripts"];
    if (storedEncodedScripts != nil) {
        NSArray *user_scripts = [NSKeyedUnarchiver unarchiveObjectWithData:storedEncodedScripts];
        return user_scripts;
    } else {
        return nil;
    }
}

+ (void)removeAllScripts {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scripts"];
}

@end
