//
//  DataValidation.m
//  Elearning
//

#import "DataValidation.h"

@implementation DataValidation

+ (BOOL)isValidEmailAddress:(NSString *)emailAddress errorMessage:(NSString **)errorMessage {
    // Check if email is empty
    if (![emailAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
        *errorMessage = ERROR_EMAIL_REQUIRED;
        return NO;
    }
    // Check if valid email
    if (emailAddress.length) {
        // Create predicate with format matching your regex string
        NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", EMAIL_FILTER_REGEX];
        // Check if email is invalid
        if (![emailPredicate evaluateWithObject:emailAddress]) {
            *errorMessage = ERROR_EMAIL_INVALID;
            return NO;
        }
    }
    // Check maximum length
    if (emailAddress.length > MAX_LENGTH_EMAIL) {
        *errorMessage = [NSString stringWithFormat:@"%@%ld",ERROR_MAX_LENGTH_EMAIL,(long)MAX_LENGTH_EMAIL];
        return NO;
    }
    return YES;
}

+ (BOOL)isValidPassword:(NSString *)password errorMessage:(NSString **)errorMessage {
    // Check if password is empty
    if (![password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
        *errorMessage = ERROR_PASSWORD_REQUIRED;
        return NO;
    }
    // Check minimum length
    if (password.length < MIN_LENGTH_PASSWORD) {
        *errorMessage = [NSString stringWithFormat:@"%@%ld",ERROR_MIN_LENGTH_PASSWORD,(long)MIN_LENGTH_PASSWORD];
        return NO;
    }
    return YES;
}

+ (BOOL)isValidConfirmedPassword:(NSString *)confirmedPassword password:(NSString *)password errorMessage:(NSString **)errorMessage {
    if(![password isEqualToString:confirmedPassword]){
        *errorMessage = ERROR_PASSWORD_RETYPE;
        return NO;
    }
    return YES;
}

+ (BOOL)isValidName:(NSString *)name errorMessage:(NSString **)errorMessage {
    // Check if name is empty
    if (![name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
        *errorMessage = ERROR_NAME_REQUIRED;
        return NO;
    }
    // Check maximum length
    if (name.length > MAX_LENGTH_USER_NAME) {
        *errorMessage = [NSString stringWithFormat:@"%@%ld",ERROR_MAX_LENGTH_NAME,(long)MAX_LENGTH_USER_NAME];
        return NO;
    }
    return YES;
}

@end
