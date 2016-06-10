//
//  LoginManager.h
//  Elearning
//
//  Created by Nguyen Van Thieu B on 5/26/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginManagerDelegate
- (void)didResponseWithMessage:(NSString *)message withError:(NSError *)error;
@end

@interface LoginManager : NSObject
@property (weak, nonatomic) id<LoginManagerDelegate> delegate;
- (void)doLoginWithEmail:(NSString *)email
                password:(NSString *)password
                remember:(BOOL)rememberMe;
@end
