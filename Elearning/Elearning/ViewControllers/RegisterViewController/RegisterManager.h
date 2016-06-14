//
//  RegisterManager.h
//  Elearning
//
//  Created by  on 6/13/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RegisterManagerDelegate
- (void)didLogoutwithMessage:(NSString *)message withError:(NSError *)error;
- (void)didResponseWithMessage:(NSString *)message withError:(NSError *)error;
@end

@interface RegisterManager : NSObject
@property (nonatomic, weak) id<RegisterManagerDelegate> delegate;
- (void)doLogout;
- (void)doRegisterWithEmail:(NSString *)email
                       name:(NSString *)name
                   password:(NSString *)password
          confirmedPassword:(NSString *)confirmedPassword;
@end
