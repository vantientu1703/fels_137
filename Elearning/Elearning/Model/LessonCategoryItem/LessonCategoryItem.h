//
//  LessonCategoryItem.h
//  Elearning
//
//  Created by Văn Tiến Tú on 5/26/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnswerItem.h"

@interface LessonCategoryItem : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray *arrWords;
@property (strong, nonatomic) AnswerItem *answer;

@end
