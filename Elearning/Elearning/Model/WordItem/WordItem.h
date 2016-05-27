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

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSMutableArray *arrAnswers;
@property (nonatomic, strong) NSString *resultID;
@property (nonatomic, strong) AnswerItem *answer;

@end
