//
//  UpdateProfileManager.m
//  Elearning
//
//  Created by Nguyen Van Thieu B on 5/28/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "UpdateProfileManager.h"
#import "DataValidation.h"
#import "StoreData.h"
#import "NetworkConnection.h"
#import "ParseJson.h"
#import "Constants.h"
#import "User.h"

@implementation UpdateProfileManager

- (void)doUpdateProfileWithName:(NSString *)name
                          email:(NSString *)email
                       password:(NSString *)password
           passwordConfirmation:(NSString *)passwordConfirmation
                         avatar:(NSString *)avatarString {
    NSString *errorMessage = @"";
    [self checkUpdateProfileWithName:name
                               email:email
                            password:password
                passwordConfirmation:passwordConfirmation
                        errorMessage:&errorMessage];
    // check local ok, send request update profile
    if (!errorMessage.length) {
        User *user = [StoreData getUser];
        NSString *urlUpdateProfile = [NSString stringWithFormat:@"%@%@%d%@", BASE_URL, USER_REQUEST, user.userId, REQUEST_EXTENSION];
        NSString *paramUpdateProfile = [NSString stringWithFormat:@"%@%@&%@%@&%@%@&%@%@&%@%@&%@%@", USER_NAME, name, USER_EMAIL, email, USER_PASSWORD, password, USER_PASSWORD_CONFIRMATION, passwordConfirmation, USER_AVATAR, avatarString, AUTH_TOKEN, user.authToken];
        [NetworkConnection responseWithUrl:urlUpdateProfile method:PATCH params:paramUpdateProfile resultRequest:^(NSDictionary *dic, NSError *error) {
            NSString *message = ERROR_LOST_CONNECTION;
            if (!error && dic) {
                if (!dic[@"message"] && !dic[@"error"]) {
                    User *user = [ParseJson parseResponse:dic];
                    [StoreData setUser:user];
                    message = UPDATE_PROFILE_SUCCESS;
                } else {
                    message = ERROR_UPDATE_PROFILE;
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

- (BOOL)checkUpdateProfileWithName:(NSString *)name
                             email:(NSString *)email
                          password:(NSString *)password
              passwordConfirmation:(NSString *)passwordConfirmation
                      errorMessage:(NSString **)errorMessage {
    if (![DataValidation isValidName:name errorMessage:errorMessage]) {
        return NO;
    }
    if (![DataValidation isValidEmailAddress:email errorMessage:errorMessage]) {
        return NO;
    }
    if (![DataValidation isValidConfirmedPassword:passwordConfirmation password:password errorMessage:errorMessage]) {
        return NO;
    }
    return YES;
}

@end
