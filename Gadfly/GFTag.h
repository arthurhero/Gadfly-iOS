//
//  GFTag.h
//  Gadfly
//
//  Created by Ziwen Chen on 1/6/18.
//  Copyright © 2018 G-FORVM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GFPoli.h"
#import "GFScript.h"
#import "GFUser.h"

@interface GFTag : NSObject

/*!
 @brief Fetching the tags data from alltags API. Everytime you want to initiate or update local
 tag dictionary, you can call this method.
 */
+ (void)initTags;

/*!
 @brief Since tags is a static class variable, you cannot directly get it. You should call this method
 to get local tags dictionary.
 */
+ (NSDictionary *)getTags;

@end
