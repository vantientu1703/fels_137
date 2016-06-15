//
//  Constants.h
//  Elearning
//
//  Created by  on 6/10/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

#pragma mark - API
extern NSString *const BASE_URL;
extern NSString *const LOG_IN_REQUEST;
extern NSString *const LOG_OUT_REQUEST;
extern NSString *const SIGN_UP_REQUEST;
extern NSString *const GET_CATEGORIES_REQUEST;
extern NSString *const LESSONS_REQUEST;
extern NSString *const USER_REQUEST;
extern NSString *const REQUEST_EXTENSION;
extern NSString *const SESSION_EMAIL;
extern NSString *const SESSION_PASSWORD;
extern NSString *const SESSION_REMEMBERME;
extern NSString *const AUTH_TOKEN;
extern NSString *const USER_NAME;
extern NSString *const USER_EMAIL;
extern NSString *const USER_PASSWORD;
extern NSString *const USER_PASSWORD_CONFIRMATION;
extern NSString *const USER_AVATAR;
extern NSString *const PAGE;
extern NSString *const PER_PAGE;
extern NSString *const USER_TOKEN;

#pragma mark - Avatar
extern NSString *const ERROR_CAMERA_TITLE;
extern NSString *const ERROR_CAMERA_MESSAGE;
extern NSString *const AVATAR_ALERT_TITLE;
extern NSString *const AVATAR_ALERT_MESSAGE;
extern NSString *const CANCEL_MESSAGE;
extern NSString *const CHOSSE_GALLERY_MESSAGE;
extern NSString *const TAKE_PHOTO_MESSAGE;

#pragma mark - Regex
extern NSString *const EMAIL_FILTER_REGEX;

#pragma mark - Strings
extern NSString *const ERROR_EMAIL_REQUIRED;
extern NSString *const ERROR_EMAIL_INVALID;
extern NSString *const ERROR_PASSWORD_REQUIRED;
extern NSString *const ERROR_PASSWORD_RETYPE;
extern NSString *const ERROR_NAME_REQUIRED;
extern NSString *const ERROR_MAX_LENGTH_EMAIL;
extern NSString *const ERROR_MIN_LENGTH_PASSWORD;
extern NSString *const ERROR_MAX_LENGTH_NAME;
extern NSString *const ERROR_LOST_CONNECTION;
extern NSString *const ERROR_UPDATE_PROFILE;
extern NSString *const UPDATE_PROFILE_SUCCESS;
extern NSString *const LEARNED_WORD_FORMAT;

#pragma mark - Data Validation Constants
extern NSInteger const MAX_LENGTH_USER_NAME;
extern NSInteger const MAX_LENGTH_EMAIL;
extern NSInteger const MIN_LENGTH_PASSWORD;

#pragma mark - KeyChain Keys
extern NSString *const KEYCHAIN_KEY_SERVICE;

@end
