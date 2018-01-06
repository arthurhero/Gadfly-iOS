//
//  GFUser.h
//  Gadfly
//
//  Created by Ziwen Chen on 1/6/18.
//  Copyright © 2018 G-FORVM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GFPoli.h"
#import "GFScript.h"
#import "GFTag.h"

@interface GFUser : NSObject

@property bool initialized;

- (GFUser *)init;
- (void)reset;
+ (void)cacheAddress:(NSString *)address;
+ (NSString *)getAddress;
+ (void)cachePolis:(NSArray *)polis;
+ (NSArray *)getPolis;

@end
