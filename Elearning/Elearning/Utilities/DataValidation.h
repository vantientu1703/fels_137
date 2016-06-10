//
//  DataValidation.h
//  Elearning
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface DataValidation : NSObject

+ (BOOL)isValidEmailAddress:(NSString *)emailAddress errorMessage:(NSString **)errorMessage;

+ (BOOL)isValidPassword:(NSString *)password errorMessage:(NSString **)errorMessage;

+ (BOOL)isValidConfirmedPassword:(NSString *)confirmedPassword password:(NSString *)password errorMessage:(NSString **)errorMessage;

+ (BOOL)isValidName:(NSString *)name errorMessage:(NSString **)errorMessage;

@end
