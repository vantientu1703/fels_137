//
//  Input.h
//  Elearning
//
//  Created by Nguyen Van Thieu B on 5/28/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInput : NSObject
@property (assign, nonatomic) BOOL rememberMe;
@property (strong, nonatomic) NSString *emailInput;
@property (strong, nonatomic) NSString *passwordInput;
@end
