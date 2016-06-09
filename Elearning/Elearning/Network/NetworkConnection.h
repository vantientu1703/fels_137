//
//  NetworkConnection.h
//  Elearning
//
//  Created by Nguyen Van Thieu B on 5/27/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkConnection : NSObject

typedef void(^ResultRequest)(NSDictionary *, NSError *);

typedef NS_ENUM(NSInteger, METHODS) {
    GET,
    POST,
    PATCH,
    DELETE
};

+ (NSString *)formatMethodTypeToString:(METHODS)method;

+ (void)responseWithUrl:(NSString *)url
                 method:(NSString *)method
                 params:(NSString *)params
          resultRequest:(ResultRequest)complete;

@end
