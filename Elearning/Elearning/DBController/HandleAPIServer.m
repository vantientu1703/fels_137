//
//  HandleAPIServer.m
//  Elearning
//
//  Created by Văn Tiến Tú on 5/25/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "HandleAPIServer.h"

@implementation HandleAPIServer

+ (void)getWithUrl:(NSString *)url parameters:(NSString *)params resultRequest:(ResultRequest)complete {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",url,params]]];
    NSString * post = @"";
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    request.HTTPMethod = @"GET";
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = postData;
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                        NSError *error) {
    
                    NSError *errors;
                    NSDictionary *dic;
                    if (data) {
                        dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&errors];
                    }
                    if (complete) {
                        complete(dic,error);
                    }
                    }] resume];
    
}
+ (void) postWithUrl:(NSString*) url
           pramaters:(NSString*) params
       resultRequest:(ResultRequest) complete {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]]];
    NSString * post = params;
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    request.HTTPMethod = @"POST";
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = postData;
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    
                    NSError *errors;
                    NSDictionary *dic;
                    if (data) {
                        dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&errors];
                    }
                    if (complete) {
                        complete(dic,error);
                    }
                }] resume];
    
}

+ (void)patchWithUrl:(NSString *)url
           pramaters:(NSString *)params
       resultRequest:(ResultRequest)complete {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]]];
    NSString * post = params;
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    request.HTTPMethod = @"PATCH";
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = postData;
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    
                    NSError *errors;
                    NSDictionary *dic;
                    if (data) {
                        dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&errors];
                    }
                    if (complete) {
                        complete(dic,error);
                    }
                }] resume];
}
@end
