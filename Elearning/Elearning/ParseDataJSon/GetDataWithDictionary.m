//
//  ParseDataJSon.m
//  Elearning
//
//  Created by Văn Tiến Tú on 5/26/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "GetDataWithDictionary.h"

@implementation GetDataWithDictionary

- (NSMutableArray *)arrayWordListWithDictionary:(NSDictionary *)dictionaryWordList {
    NSMutableArray *arrWords = dictionaryWordList[@"words"];
    NSString *totalPages = dictionaryWordList[@"total_pages"];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:arrWords];
    [arr addObject:totalPages];
    return arr;
}
- (NSMutableArray *)arrayCategoriesWithDictionary:(NSDictionary *)dictionaryCategories {
    NSMutableArray *arr = dictionaryCategories[@"categories"];
    return arr;
}
- (NSDictionary *)lessonCategoryWithDictionary:(NSDictionary *)dictionaryLesson {
    NSDictionary *dicLesson;
    if (dictionaryLesson) {
        dicLesson = dictionaryLesson[@"lesson"];
    }
    return dicLesson;
}
@end
