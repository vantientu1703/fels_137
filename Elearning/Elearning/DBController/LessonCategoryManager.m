//
//  LessonCategoryManager.m
//  Elearning
//
//  Created by Văn Tiến Tú on 5/26/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "LessonCategoryManager.h"
#import "NetworkConnection.h"
#import "Constants.h"

NSString *const PARAM_UPDATE_CATEGORY = @"lesson[learned]=%d&\
                                          lesson[results_attributes][0][id]=%@&\
                                          lesson[results_attributes][0][answer_id]=%@&\
                                          lesson[results_attributes][1][id]=%@&\
                                          lesson[results_attributes][1][answer_id]=%@\
                                          &auth_token=%@";
@implementation LessonCategoryManager

- (void)getLessonWithCategoryId:(NSString *)categoryID
                      authToken:(NSString *)authToken {
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@", BASE_URL, CATEGORIES, categoryID, LESSONS_REQUEST];
    NSString *params = [NSString stringWithFormat:@"%@%@", AUTH_TOKEN, authToken];
    [NetworkConnection responseWithUrl:url method:POST params:params resultRequest:^(NSDictionary *dataJSon, NSError *error) {
        __block NSString *message = @"";
        __block LessonCategoryItem *lesson;
        if (!error) {
            if (dataJSon[@"error"]) {
                message = dataJSon[@"error"];
            } else {
                lesson = [DBUtil dbLessonCategoryItem:dataJSon];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveLessonObject:message:error:)]) {
                [self.delegate didReceiveLessonObject:lesson message:message error:error];
            }
        });
    }];
}
- (void)updateLessonWithAuthToken:(NSString *)authToken
                         lessonID:(NSString *)lessonID
                         resultID:(NSString *)resultID
                         answerID:(NSString *)answerID {
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@%@", BASE_URL, LESSON,lessonID, REQUEST_EXTENSION];
    NSString *params = [NSString stringWithFormat:PARAM_UPDATE_CATEGORY, YES, resultID, answerID, resultID, answerID, authToken];
    [NetworkConnection responseWithUrl:url method:PATCH params:params resultRequest:^(NSDictionary *dataJSon, NSError *error) {
        __block BOOL success = NO;
        __block NSString *message = @"";
        if (!error) {
            if (dataJSon[@"error"]) {
                message = dataJSon[@"error"];
            } else {
                success = YES;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveUpdateLessonWithBool:withMessage:)]) {
                [self.delegate didReceiveUpdateLessonWithBool:success withMessage:message];
            }
        });
    }];
}
@end
