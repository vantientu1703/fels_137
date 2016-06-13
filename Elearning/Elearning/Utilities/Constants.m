//
//  Constants.m
//  Elearning
//
//  Created by  on 6/10/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "Constants.h"

@implementation Constants

#pragma mark - API
NSString *const URL_LOGIN = @"https://manh-nt.herokuapp.com/login.json";
NSString *const SESSION_EMAIL = @"session[email]=";
NSString *const SESSION_PASSWORD = @"session[password]=";
NSString *const SESSION_REMEMBERME = @"session[remember_me]=";

#pragma mark - Regex
NSString *const EMAIL_FILTER_REGEX = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";

#pragma mark - Error Strings
NSString *const ERROR_EMAIL_REQUIRED = @"Email address required";
NSString *const ERROR_EMAIL_INVALID = @"Email address is invalid";
NSString *const ERROR_PASSWORD_REQUIRED = @"Password required";
NSString *const ERROR_PASSWORD_RETYPE = @"Retype password not corrected";
NSString *const ERROR_NAME_REQUIRED = @"Name required";
NSString *const ERROR_MAX_LENGTH_EMAIL = @"Email can not be longer than ";
NSString *const ERROR_MIN_LENGTH_PASSWORD = @"Password should be at least ";
NSString *const ERROR_MAX_LENGTH_NAME = @"Name can not be longer than ";
NSString *const ERROR_LOST_CONNECTION = @"Lost connection";

#pragma mark - Data Validation Constants
NSInteger const MAX_LENGTH_USER_NAME = 50;
NSInteger const MAX_LENGTH_EMAIL = 255;
NSInteger const MIN_LENGTH_PASSWORD = 6;

#pragma mark - KeyChain
NSString *const KEYCHAIN_KEY_SERVICE = @"com.framgia.elearning";

@end
