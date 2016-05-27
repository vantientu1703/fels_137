//
//  AnswerItem.h
//  Elearning
//
//  Created by Văn Tiến Tú on 5/24/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnswerItem : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, assign) BOOL isCorrect;
@property (nonatomic, strong) NSString *content;

@end
