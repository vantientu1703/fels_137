//
//  HomeManager.h
//  Elearning
//
//  Created by Nguyen Van Thieu B on 5/27/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@protocol HomeManagerDelegate
- (void)didReceiveUser:(User *)user
           withMessage:(NSString *)message
             withError:(NSError *)error;
@end

@interface HomeManager : NSObject
@property (weak, nonatomic) id<HomeManagerDelegate> delegate;
- (void)doShowUser;
@end
