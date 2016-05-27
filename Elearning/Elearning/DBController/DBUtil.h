//
//  DBUtil.h
//  Elearning
//
//  Created by Văn Tiến Tú on 5/22/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WordItem.h"
//#import "CategoryItem.h"
#import "AnswerItem.h"
//#import "LessonCategoryItem.h"

@interface DBUtil : NSObject

+ (WordItem *)dbItemToWordItem:(NSDictionary *)dictionary;
//+ (CategoryItem *)dbCategoryItem: (NSDictionary *)dictionary;
+ (AnswerItem *)dbAnswerItem:(NSDictionary *)dictionary;
//+ (LessonCategoryItem *)dbLessonCategoryItem: (NSDictionary *)dictionary;

@end
