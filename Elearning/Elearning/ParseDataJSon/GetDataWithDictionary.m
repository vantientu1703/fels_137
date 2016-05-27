//
//  ParseDataJSon.m
//  Elearning
//
//  Created by Văn Tiến Tú on 5/26/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "GetDataWithDictionary.h"

@implementation GetDataWithDictionary

- (NSMutableArray*) arrayWordListWithDictionary:(NSDictionary*) dictionaryWordList {
    NSMutableArray *arrWordList = dictionaryWordList[@"words"];
    NSString *stringTotalPages = dictionaryWordList[@"total_pages"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:arrWordList];
    [arr addObject:stringTotalPages];
    return arr;
}

- (NSMutableArray *)arrayCategoriesWithDictionary:(NSDictionary *)dictionaryCategories {
    NSMutableArray *arrCategories = dictionaryCategories[@"categories"];
    NSString *stringTotalPages = dictionaryCategories[@"total_pages"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:arrCategories];
    [arr addObject:stringTotalPages];
    return arr;
}

- (NSDictionary *)lessonCategoryWithDictionary:(NSDictionary *)dictionaryLesson {
    NSDictionary *dicLesson;
    if (dictionaryLesson) {
        dicLesson = [NSDictionary dictionaryWithDictionary:dictionaryLesson[@"lesson"]];
    }
    return dicLesson;
}
@end
