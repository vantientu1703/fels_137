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

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *arrWords;
@property (nonatomic, strong) AnswerItem *answer;

@end
