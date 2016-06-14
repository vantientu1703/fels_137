//
//  WordItem.h
//  Elearning
//
//  Created by Văn Tiến Tú on 5/20/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnswerItem.h"

@interface WordItem : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSMutableArray *arrAnswers;
@property (strong, nonatomic) NSString *resultID;
@property (strong, nonatomic) AnswerItem *answer;

@end
