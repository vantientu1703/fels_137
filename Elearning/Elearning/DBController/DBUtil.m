//
//  DBUtil.m
//  Elearning
//
//  Created by Văn Tiến Tú on 5/22/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "DBUtil.h"

@implementation DBUtil

+ (WordItem *)dbItemToWordItem:(NSDictionary *)dictionary {
    WordItem *wordItem = [WordItem new];
    if (dictionary) {
        wordItem.ID = dictionary[@"id"];
        wordItem.content = dictionary[@"content"];
        wordItem.arrAnswers = dictionary[@"answers"];
        wordItem.resultID = dictionary[@"result_id"];
    }
    return wordItem;
}

+ (CategoryItem *)dbCategoryItem:(NSDictionary *)dictionary {
    CategoryItem *categoryItem = [CategoryItem new];
    if (dictionary) {
        categoryItem.ID = dictionary[@"id"];
        categoryItem.name = dictionary[@"name"];
        categoryItem.url = [NSURL URLWithString:dictionary[@"photo"]];
        categoryItem.totalLearnedWords = [dictionary[@"learned_words"] intValue];
    }
    return categoryItem;
}
+ (AnswerItem *)dbAnswerItem: (NSDictionary *)dictionary {
    AnswerItem *answerItem = [AnswerItem new];
    if (dictionary) {
        answerItem.ID = dictionary[@"id"];
        answerItem.content = dictionary[@"content"];
        answerItem.isCorrect = [dictionary[@"is_correct"] boolValue];
    }
    return answerItem;
}
// TODO: Dành cho màn hình lesson
//+ (LessonCategoryItem *)dbLessonCategoryItem: (NSDictionary *)dictionary {
//    LessonCategoryItem *lesson = [[LessonCategoryItem alloc] init];
//    if (dictionary) {
//        NSDictionary *dicLesson = [NSDictionary dictionaryWithDictionary:dictionary[@"lesson"]];
//        lesson.ID = dicLesson[@"id"];
//        lesson.arrWords = dicLesson[@"words"];
//        lesson.name = dicLesson[@"name"];
//    }
//    return lesson;
//}
@end
