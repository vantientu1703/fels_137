//
//  RegisterManager.m
//  Elearning
//
//  Created by  on 6/13/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "RegisterManager.h"
#import "DataValidation.h"
#import "NetworkConnection.h"
#import "ParseJson.h"
#import "StoreData.h"
#import "User.h"
#import "Constants.h"

@implementation RegisterManager

- (void)doLogout {
    User *user = [[User alloc] init];
    user = [StoreData getUser];
    NSString *urlLogout = [NSString stringWithFormat:@"%@%@", BASE_URL, LOG_OUT_REQUEST];
    NSString *paramLogout = [NSString stringWithFormat:@"%@%@", AUTH_TOKEN, user.authToken];
    [NetworkConnection responseWithUrl:urlLogout method:DELETE params:paramLogout resultRequest:^(NSDictionary *dic, NSError *error) {
        NSString *message = ERROR_LOST_CONNECTION;
        if (!error && dic) {
            message = dic[@"message"];
            if (!message) {
                message = dic[@"error"];
                if (!message) {
                    message = @"";
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate didLogoutwithMessage:message withError:error];
        });
    }];
}

- (void)doRegisterWithEmail:(NSString *)email
                       name:(NSString *)name
                   password:(NSString *)password
          confirmedPassword:(NSString *)confirmedPassword {
    NSString *errorMessage = @"";
    [self checkRegisterWithEmail:email name:name password:password confirmedPassword:confirmedPassword errorMessage:&errorMessage];
    // check local ok, send request login
    if (!errorMessage.length) {
        NSString *urlRegister = [NSString stringWithFormat:@"%@%@", BASE_URL, SIGN_UP_REQUEST];
        NSString *paramRegister = [NSString stringWithFormat:@"%@%@&%@%@&%@%@&%@%@", USER_NAME, name, USER_EMAIL, email, USER_PASSWORD, password, USER_PASSWORD_CONFIRMATION, confirmedPassword];
        [NetworkConnection responseWithUrl:urlRegister method:POST params:paramRegister resultRequest:^(NSDictionary *dic, NSError *error) {
            NSString *message = ERROR_LOST_CONNECTION;
            NSLog(@"dic = %@", dic);
            if (!error) {
                message = dic[@"message"];
                if (!message) {
                    message = dic[@"error"];
                    if (!message) {
                        User *user = [[User alloc] init];
                        user = [ParseJson parseResponse:dic];
                        [StoreData setUser:user];
                        message = @"";
                    }
                } else {
                    NSDictionary *dict = dic[@"message"];
                    if (dict[@"email"]) {
                        NSArray *arrMessage = dict[@"email"];
                        if (arrMessage.count > 0) {
                            message = [NSString stringWithFormat:@"%@ %@", EMAIL, arrMessage[0]];
                        } else {
                            message = CHECK_AGAIN;
                        }
                    } else {
                        message = CHECK_AGAIN;
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

- (BOOL)checkRegisterWithEmail:(NSString *)email
                          name:(NSString *)name
                      password:(NSString *)password
             confirmedPassword:(NSString *)confirmedPassword
                  errorMessage:(NSString **)errorMessage {
    if (![DataValidation isValidEmailAddress:email errorMessage:errorMessage]) {
        return NO;
    }
    if (![DataValidation isValidName:name errorMessage:errorMessage]) {
        return NO;
    }
    if (![DataValidation isValidPassword:password errorMessage:errorMessage]) {
        return NO;
    }
    if (![DataValidation isValidPassword:confirmedPassword errorMessage:errorMessage]) {
        return NO;
    }
    if (![DataValidation isValidConfirmedPassword:confirmedPassword password:password errorMessage:errorMessage]) {
        return NO;
    }
    return YES;
}

@end
