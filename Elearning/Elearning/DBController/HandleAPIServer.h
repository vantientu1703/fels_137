//
//  HandleAPIServer.h
//  Elearning
//
//  Created by Văn Tiến Tú on 5/25/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HandleAPIServer : NSObject

typedef void(^ResultRequest)(NSDictionary*,NSError*);

/*
 * Do get request
 * @param url get request
 * @pram params Parameters need for get request
 */
+ (void) getWithUrl:(NSString*)url
         parameters:(NSString*)params
      resultRequest:(ResultRequest) complete;

/*
 * Do post request
 * @param url post request
 * @param params Parameters need for post request
 */
+ (void) postWithUrl:(NSString*) url
           pramaters:(NSString*) params
       resultRequest:(ResultRequest) complete;

/*
 * Do get patch request
 * @param url patch request
 * @param params params Parameters need for patch request
 */
+ (void) patchWithUrl:(NSString*) url
           pramaters:(NSString*) params
       resultRequest:(ResultRequest) complete;
@end
