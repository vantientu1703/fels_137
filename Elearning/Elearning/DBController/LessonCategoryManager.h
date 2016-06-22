//
//  LessonCategoryManager.h
//  Elearning
//
//  Created by Văn Tiến Tú on 5/26/16.
//  Copyright © 2016 Framgia. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "LessonCategoryItem.h"
#import "DBUtil.h"

@protocol LessonCategoryManagerDelegate <NSObject>

- (void)didReceiveLessonObject:(LessonCategoryItem *)lesson message:(NSString *)message error:(NSError *)error;
- (void)didReceiveUpdateLessonWithBool:(BOOL)success withMessage:(NSString *)message;

@end

@interface LessonCategoryManager : NSObject
@property (nonatomic, weak) id<LessonCategoryManagerDelegate> delegate;
- (void)getLessonWithCategoryId:(NSString *)categoryID authToken:(NSString *)authToken;
- (void)updateLessonWithAuthToken:(NSString *)authToken
                         lessonID:(NSString *)lessonID
             withArrWordAnswereds:(NSMutableArray *)arrWordAnswereds;
@end
