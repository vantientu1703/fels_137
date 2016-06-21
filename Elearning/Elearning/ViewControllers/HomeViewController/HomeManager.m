//
//  HomeManager.m
//  Elearning
//
//  Created by Nguyen Van Thieu B on 5/27/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "HomeManager.h"
#import "NetworkConnection.h"
#import "User.h"
#import "StoreData.h"
#import "ParseJson.h"
#import "Constants.h"

@implementation HomeManager

- (void)doShowUser {
    User *user = [StoreData getUser];
    NSString *urlShowUser = [NSString stringWithFormat:@"%@%@%ld%@", BASE_URL, USER_REQUEST, user.userId, REQUEST_EXTENSION];
    NSString *paramShowUser = [NSString stringWithFormat:@"%@%@", AUTH_TOKEN, user.authToken];
    [NetworkConnection responseWithUrl:urlShowUser method:GET params:paramShowUser resultRequest:^(NSDictionary *dic, NSError *error) {
        NSString *message = ERROR_LOST_CONNECTION;
        User *user = [[User alloc] init];
        if (!error && dic) {
            if (!dic[@"message"] && !dic[@"error"]) {
                user = [ParseJson parseResponse:dic];
                [StoreData setUser:user];
                message = @"";
            } else {
                message = ERROR_SHOW_USER;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate didReceiveUser:user withMessage:message withError:error];
        });
    }];
}

@end
