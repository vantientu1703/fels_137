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

NSString *const PARAM_UPDATE_CATEGORY = @"lesson[learned]=%d&%@auth_token=%@";
NSString *const GROUP_ANSWER = @"lesson[results_attributes][%ld][id]=%@&lesson[results_attributes][%ld][answer_id]=%@&";
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
             withArrWordAnswereds:(NSMutableArray *)arrWordAnswereds {
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@%@", BASE_URL, LESSON,lessonID, REQUEST_EXTENSION];
    NSMutableString *groupAnswer = [[NSMutableString alloc] init];
    [arrWordAnswereds enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *group = [NSString stringWithFormat:GROUP_ANSWER, idx, obj[0], idx, obj[1]];
        [groupAnswer appendString:group];
    }];
    NSString *params = [NSString stringWithFormat:PARAM_UPDATE_CATEGORY, YES, groupAnswer, authToken];
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
