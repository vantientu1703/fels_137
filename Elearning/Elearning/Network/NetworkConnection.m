//
//  NetworkConnection.m
//  Elearning
//
//  Created by Nguyen Van Thieu B on 5/27/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "NetworkConnection.h"

@implementation NetworkConnection

+ (NSString *)formatMethodTypeToString:(METHODS)method {
    NSString *result;
    switch(method) {
        case GET:
            result = @"GET";
            break;
        case POST:
            result = @"POST";
            break;
        case PATCH:
            result = @"PATCH";
            break;
        case DELETE:
            result = @"DELETE";
            break;
    }
    return result;
}

+ (NSURLSessionDataTask *)responseWithUrl:(NSString *)url
                                   method:(METHODS)method
                                   params:(NSString *)params
                            resultRequest:(ResultRequest)complete {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    if (method == GET) {
        // GET method
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",url,params]]];
    } else {
        // POST, DELETE, PATCH method
        [request setURL:[NSURL URLWithString:url]];
        NSData *postData = [params dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)postData.length];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        request.HTTPBody = postData;
    }
    request.HTTPMethod = [self formatMethodTypeToString:method];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dic;
        if (data) {
            dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        }
        if (complete) {
            complete(dic, error);
        }
    }];
    [dataTask resume];
    return dataTask;
}

@end
