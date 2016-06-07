//
//  Constants.h
//  Elearning
//
//  Created by  on 6/10/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

#pragma mark - Regex
extern NSString *const EMAIL_FILTER_REGEX;

#pragma mark - Error Strings
extern NSString *const ERROR_EMAIL_REQUIRED;
extern NSString *const ERROR_EMAIL_INVALID;
extern NSString *const ERROR_PASSWORD_REQUIRED;
extern NSString *const ERROR_PASSWORD_RETYPE;
extern NSString *const ERROR_NAME_REQUIRED;
extern NSString *const ERROR_MAX_LENGTH_EMAIL;
extern NSString *const ERROR_MIN_LENGTH_PASSWORD;
extern NSString *const ERROR_MAX_LENGTH_NAME;

#pragma mark - Data Validation Constants
extern NSInteger const MAX_LENGTH_USER_NAME;
extern NSInteger const MAX_LENGTH_EMAIL;
extern NSInteger const MIN_LENGTH_PASSWORD;

#pragma mark - KeyChain Keys
extern NSString *const KEYCHAIN_KEY_SERVICE;

@end
