//
//  ParseDataJSon.h
//  Elearning
//
//  Created by Văn Tiến Tú on 5/26/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LessonCategoryItem.h"

@interface GetDataWithDictionary : NSObject
- (NSMutableArray*) arrayWordListWithDictionary:(NSDictionary*) dictionaryWordList;
- (NSMutableArray*) arrayCategoriesWithDictionary:(NSDictionary*) dictionaryCategories;
- (NSDictionary*) lessonCategoryWithDictionary:(NSDictionary*) dictionaryLesson;
@end
