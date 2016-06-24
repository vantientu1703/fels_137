//
//  StoreData.h
//  Elearning
//
//  Created by Nguyen Van Thieu B on 5/27/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "UserInput.h"
#import "UICKeyChainStore.h"
#import "Constants.h"

@interface StoreData : NSObject

+ (User *)getUser;

+ (void)setUser:(User *)user;

+ (void)clearUser;

+ (UserInput *)getInput;

+ (void)setInput:(UserInput *)input;

+ (void)clearInput;

+ (BOOL)getLogin;

+ (void)setLogin:(BOOL)isLogin;

+ (void)clearLogin;

+ (BOOL)getShowUser;

+ (void)setShowUser:(BOOL)isShow;

+ (void)clearShowUser;

@end
