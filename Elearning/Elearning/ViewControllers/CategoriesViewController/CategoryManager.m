//
//  CategoryManager.m
//  Elearning
//
//  Created by Văn Tiến Tú on 5/26/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "CategoryManager.h"
#import "HandleAPIServer.h"
#import "GetDataWithDictionary.h"


#define URL_CATEGORY "https://manh-nt.herokuapp.com/categories.json"
#define PARAM_GET_CATEGORY "page=%d&per_page=%d&auth_token=%@"
@implementation CategoryManager

- (void)doGetCategoryWithAuthToken:(NSString *)authToken
                              page:(NSInteger)page
                       perPageData:(NSInteger)perPageData {
    
    NSString *url = @URL_CATEGORY;
    NSString *paramas = [NSString stringWithFormat:@PARAM_GET_CATEGORY,page,perPageData,authToken];
    
    [HandleAPIServer getWithUrl:url
                     parameters:paramas
                  resultRequest:^(NSDictionary *dataJSon,
                                  NSError *error) {
                      
                      GetDataWithDictionary *getArrayDataWithDictionary = [GetDataWithDictionary new];
                      if (error) {
                          [self.delegate didReceiveCategoriesWithArray:nil
                                                             withError:error];
                      } else {
                          dispatch_async(dispatch_get_main_queue(), ^{
                            NSMutableArray *arr = [getArrayDataWithDictionary arrayCategoriesWithDictionary:dataJSon];
                              [self.delegate didReceiveCategoriesWithArray:arr
                                                                 withError:error];
                          });
                      }
                  }];
    
}
@end
