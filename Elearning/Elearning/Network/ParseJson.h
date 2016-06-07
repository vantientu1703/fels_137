//
//  ParseJson.h
//  Elearning
//
//  Created by Nguyen Van Thieu B on 5/27/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface ParseJson : NSObject

+ (User *)parseResponse:(id)responseData;

@end
