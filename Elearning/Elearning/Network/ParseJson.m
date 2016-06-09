//
//  ParseJson.m
//  Elearning
//
//  Created by Nguyen Van Thieu B on 5/27/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "ParseJson.h"

@implementation ParseJson

+ (User *)parseResponse:(id)responseData {
    NSDictionary *userInfo = [responseData objectForKey:@"user"];
    User *user = [[User alloc] init];
    user.userId = [[userInfo objectForKey:@"id"] intValue];
    user.name = [userInfo objectForKey:@"name"];
    user.email = [userInfo objectForKey:@"email"];
    user.avatar = [userInfo objectForKey:@"avatar"];
    user.authToken = [userInfo objectForKey:@"auth_token"];
    user.learnedWords = [[userInfo objectForKey:@"learned_words"] intValue];
    user.activities = [userInfo objectForKey:@"activities"];
    return user;
}

@end
