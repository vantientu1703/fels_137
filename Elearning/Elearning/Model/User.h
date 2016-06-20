//
//  User.h
//  Elearning
//
//  Created by Nguyen Van Thieu B on 5/26/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic) NSInteger userId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *authToken;
@property (nonatomic) NSInteger learnedWords;
@property (strong, nonatomic) NSArray *activities;

@end
