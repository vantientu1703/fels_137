//
//  LessonCategoryManager.m
//  Elearning
//
//  Created by Văn Tiến Tú on 5/26/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "LessonCategoryManager.h"
#import "HandleAPIServer.h"

#define URL_UPDATE_CATEGORY "https://manh-nt.herokuapp.com/categories/%@/lessons.json"
#define PARAM_AUTH_TOKEN "auth_token=%@"
#define PARAM_UPDATE_CATEGORY "lesson[learned]=%d,lesson[results_attributes][0][id]=%@&lesson[results_attributes][0][answer_id]=%@&lesson[results_attributes][1][id]=%@&lesson[results_attributes][1][answer_id]=%@&auth_token=%@"
@implementation LessonCategoryManager


- (void) doGetLessonWithCategoryId:(NSString *)categoryID
                      authToken:(NSString *)authToken {
    
    NSString *url = [NSString stringWithFormat:@URL_UPDATE_CATEGORY,categoryID];
    NSString *params = [NSString stringWithFormat:@PARAM_AUTH_TOKEN,authToken];
    
    [HandleAPIServer postWithUrl:url
                       pramaters:params
                   resultRequest:^(NSDictionary *dataJSon, NSError *error) {
                       
                       if (error) {
                           [self.delegate didReceiveLessonObject:nil error:error];
                       } else {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [self.delegate didReceiveLessonObject:[DBUtil dbLessonCategoryItem:dataJSon] error:error];
                           });
                       }
                   }];
}

- (void)doUpdateLessonWithAuthToken:(NSString *)authToken
                           lessonID:(NSString *)lessonID
                           resultID:(NSString *)resultID
                           answerID:(NSString *)answerID {
    
    NSString *url = [NSString stringWithFormat:@URL_UPDATE_CATEGORY,lessonID];
    NSString *params = [NSString stringWithFormat:@PARAM_UPDATE_CATEGORY,true,resultID,answerID,resultID,answerID,authToken];
    
    [HandleAPIServer patchWithUrl:url
                        pramaters:params
                    resultRequest:^(NSDictionary *dataJSon,
                                    NSError *error) {
                        if (error) {
                            [self.delegate didReceiveUpdateLessonWithBool:false];
                        } else {
                            [self.delegate didReceiveUpdateLessonWithBool:true];
                        }
    }];
}
@end
