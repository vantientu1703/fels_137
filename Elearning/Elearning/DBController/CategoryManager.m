//
//  CategoryManager.m
//  Elearning
//
//  Created by Văn Tiến Tú on 5/26/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "CategoryManager.h"
#import "NetworkConnection.h"
//#import "HandleAPIServer.h"
#import "GetDataWithDictionary.h"
#import "Constants.h"

@implementation CategoryManager

- (void)getCategoryWithAuthToken:(NSString *)authToken
                            page:(NSInteger)page
                     perPageData:(NSInteger)perPageData {
    NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, GET_CATEGORIES_REQUEST];
    NSString *paramas = [NSString stringWithFormat:@"%@%ld&%@%ld&%@%@",PAGE, page, PER_PAGE, perPageData, AUTH_TOKEN, authToken];
    [NetworkConnection responseWithUrl:url
                                method:GET
                                params:paramas
                         resultRequest:^(NSDictionary *dataJSon,
                                         NSError *error) {
                             GetDataWithDictionary *getArrayDataWithDictionary = [GetDataWithDictionary new];
                             __block NSMutableArray *arr = [[NSMutableArray alloc] init];
                             NSString *message = @"";
                             if (!error) {
                                 if (dataJSon[@"error"]) {
                                     message = dataJSon[@"error"];
                                 } else {
                                    arr = [getArrayDataWithDictionary arrayCategoriesWithDictionary: dataJSon];
                                 }
                             }
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveCategories:message:withError:)]) {
                                     [self.delegate didReceiveCategories:arr message:message withError:error];
                                 }
                             });
    }];
}
@end
