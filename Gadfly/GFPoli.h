//
//  GFPoli.h
//  Gadfly
//
//  Created by Ziwen Chen on 1/6/18.
//  Copyright © 2018 G-FORVM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GFTag.h"
#import "GFScript.h"
@class GFUser;

@interface GFPoli : NSObject

@property (nonatomic,strong,nonnull) NSString *name;
@property (nonatomic,strong,nonnull) NSString *party;
@property (nonatomic,strong,nullable) NSString *picURL;
@property (nonatomic,strong,nullable) NSString *phone;
@property (nonatomic,strong,nullable) NSString *email;
@property (nonatomic,strong,nonnull) NSMutableArray *tags;


- (GFPoli *)initWithDictionary:(NSDictionary *)dict;

/*!
 @discussion Upon success, this method returns an array of GFPoli objects. Upon failure, this method
 returns an array containing a single NSString object, which is an error message.
 */
+ (void)fetchPoliWithAddress:(NSString *)address
           completionHandler:(void(^_Nonnull)(NSArray *))completion;

- (void)printInfo;

@end
