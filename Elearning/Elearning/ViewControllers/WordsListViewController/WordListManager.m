//
//  WordListManager.m
//  Elearning
//
//  Created by Văn Tiến Tú on 5/26/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "WordListManager.h"
#import "HandleAPIServer.h"
#import "GetDataWithDictionary.h"


#define URL_WORD_LIST "https://manh-nt.herokuapp.com/words.json"
#define PARAM_GET_WORD_LIST "category_id=%@&option=%@&page=%ld&per_page=%ld&auth_token=%@"
@implementation WordListManager

- (void) doGetWordListWithCategoryId:(NSString *) categoryId
                              option:(NSString *) option
                                page:(NSInteger) page
                         perPageData:(NSInteger) perPageData
                           authToken:(NSString *) authToken {
    
    NSString *params = [NSString stringWithFormat:@PARAM_GET_WORD_LIST,categoryId,option,page,perPageData,authToken];
    NSString *url = @URL_WORD_LIST;
    
    [HandleAPIServer getWithUrl:url
                     parameters:params
                  resultRequest:^(NSDictionary *dataJSon,
                                  NSError *error) {
                      if (!error) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              GetDataWithDictionary *getArrayDataWithDictionary = [[GetDataWithDictionary alloc] init];
                              NSMutableArray *arrWords = [getArrayDataWithDictionary arrayWordListWithDictionary:dataJSon];
                              [self.delegate didReceiveWordListWithArray:arrWords
                                                               withError:error];
                          });
                      } else {
                          [self.delegate didReceiveWordListWithArray:nil
                                                           withError:error];
                      }
                  }];
}
@end
