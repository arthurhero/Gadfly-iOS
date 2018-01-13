//
//  GFUser.m
//  Gadfly
//
//  Created by Ziwen Chen on 1/6/18.
//  Copyright © 2018 G-FORVM. All rights reserved.
//

#import "GFUser.h"

@implementation GFUser

+ (void)reset {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"polis"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"address"];
}


+ (void)cacheAddress:(NSString *)address {
    [[NSUserDefaults standardUserDefaults] setObject:address forKey:@"address"];
}

+ (NSString *)getAddress {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"address"];
}

+ (void)cachePolis:(NSArray *)polis {
    NSData *encodedScripts = [NSKeyedArchiver archivedDataWithRootObject:polis];
    [[NSUserDefaults standardUserDefaults] setObject:encodedScripts forKey:@"polis"];
}

+ (NSArray *)getPolis {
    NSData *storedEncodedScripts = [[NSUserDefaults standardUserDefaults] objectForKey:@"polis"];
    if (storedEncodedScripts != nil) {
        NSArray *user_polis = [NSKeyedUnarchiver unarchiveObjectWithData:storedEncodedScripts];
        return user_polis;
    } else {
        return nil;
    }
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
