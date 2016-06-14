//
//  LoginManager.m
//  Elearning
//
//  Created by Nguyen Van Thieu B on 5/26/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "LoginManager.h"
#import "DataValidation.h"
#import "NetworkConnection.h"
#import "ParseJson.h"
#import "StoreData.h"
#import "User.h"
#import "Constants.h"

@implementation LoginManager

- (void)doLoginWithEmail:(NSString *)email
                password:(NSString *)password
                remember:(BOOL)rememberMe {
    NSString *errorMessage = @"";
    [self checkLoginWithEmail:email password:password errorMessage:&errorMessage];
    // check local ok, send request login
    if (!errorMessage.length) {
        NSInteger iRememberMe = @(rememberMe).integerValue;
        NSString *urlLogin = [NSString stringWithFormat:@"%@%@", BASE_URL, LOG_IN_REQUEST];
        NSString *paramLogin = [NSString stringWithFormat:@"%@%@&%@%@&%@%d", SESSION_EMAIL, email, SESSION_PASSWORD, password, SESSION_REMEMBERME, (int)iRememberMe];
        [NetworkConnection responseWithUrl:urlLogin method:POST params:paramLogin resultRequest:^(NSDictionary *dic, NSError *error) {
            NSString *message = ERROR_LOST_CONNECTION;
            if (!error && dic) {
                message = dic[@"message"];
                if (!message) {
                    message = dic[@"error"];
                    if (!message) {
                        User *user = [[User alloc] init];
                        user = [ParseJson parseResponse:dic];
                        [StoreData setUser:user];
                        message = @"";
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate didResponseWithMessage:message withError:error];
            });
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate didResponseWithMessage:errorMessage withError:nil];
        });
    }
}

- (BOOL)checkLoginWithEmail:(NSString *)email
                   password:(NSString *)password
               errorMessage:(NSString **)errorMessage {
    if (![DataValidation isValidEmailAddress:email errorMessage:errorMessage]) {
        return NO;
    }
    if (![DataValidation isValidPassword:password errorMessage:errorMessage]) {
        return NO;
    }
    return YES;
}

@end
