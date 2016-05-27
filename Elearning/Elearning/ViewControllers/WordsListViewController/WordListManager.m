//
//  WordListManager.m
//  Elearning
//
//  Created by Văn Tiến Tú on 5/26/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "WordListManager.h"
#import "GetDataWithDictionary.h"
#import "NetworkConnection.h"

@implementation WordListManager

NSString *const URL_WORD_LIST = @"https://manh-nt.herokuapp.com/words.json";
NSString *const PARAM_GET_WORD_LIST = @"category_id=%@&option=%@&page=%lu&per_page=%lu&auth_token=%@";
NSString *const PARAM_GET_ALL_WORD_LIST = @"option=%@&page=%lu&auth_token=%@";

- (void)getWordListWithCategoryId:(NSString *)categoryId
                             option:(NSString *)option
                               page:(NSInteger)page
                        perPageData:(NSInteger)perPageData
                          authToken:(NSString *)authToken {
    NSString *params = [NSString stringWithFormat:PARAM_GET_WORD_LIST, categoryId, option, page, perPageData, authToken];
    NSString *url = URL_WORD_LIST;
    
    [NetworkConnection responseWithUrl:url
                                method:GET
                                params:params
                         resultRequest:^(NSDictionary *dataJSon,
                                         NSError *error) {
                             __block NSMutableArray *arrWords;
                             __block NSString *message = @"";
                             if (!error) {
                                 if (dataJSon[@"error"]) {
                                     message = dataJSon[@"error"];
                                 } else {
                                     arrWords = [[NSMutableArray alloc] init];
                                     GetDataWithDictionary *getArrayDataWithDictionary = [[GetDataWithDictionary alloc] init];
                                     arrWords = [getArrayDataWithDictionary arrayWordListWithDictionary:dataJSon];
                                 }
                             }
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 if (self.delegate && [(NSObject*)self.delegate respondsToSelector:@selector(didReceiveWordListWithArray:message:withError:)]) {
                                     [self.delegate didReceiveWordListWithArray:arrWords message:message withError:error];
                                 }
                             });
    }];
}

@end
