//
//  LessonCategoryManager.h
//  Elearning
//
//  Created by Văn Tiến Tú on 5/26/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LessonCategoryItem.h"
#import "HandleAPIServer.h"
#import "DBUtil.h"


@protocol LessonCategoryManagerDelegate

- (void) didReceiveLessonObject:(LessonCategoryItem*) lesson  error:(NSError*) error;
- (void) didReceiveUpdateLessonWithBool:(BOOL) success;
@end

@interface LessonCategoryManager : NSObject

@property (nonatomic, weak) id<LessonCategoryManagerDelegate> delegate;

- (void) doGetLessonWithCategoryId:(NSString*) categoryID
                         authToken:(NSString*) authToken;

- (void) doUpdateLessonWithAuthToken:(NSString*) authToken
                            lessonID:(NSString*) lessonID
                            resultID:(NSString*) resultID
                            answerID:(NSString*) AnswerID;
@end
