//
//  AnswerItem.h
//  Elearning
//
//  Created by Văn Tiến Tú on 5/24/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnswerItem : NSObject

@property (strong, nonatomic) NSString *ID;
@property (nonatomic) BOOL isCorrect;
@property (strong, nonatomic) NSString *content;

@end
