//
//  WordListManager.h
//  Elearning
//
//  Created by Văn Tiến Tú on 5/26/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WordListManagerDelegate

- (void) didReceiveWordListWithArray:(NSMutableArray*) arrWords
                           withError:(NSError*) error;

@end
@interface WordListManager : NSObject

//@property (nonatomic, assign) BOOL isError;

@property (nonatomic, weak) id<WordListManagerDelegate> delegate;

- (void) doGetWordListWithCategoryId:(NSString *) categoryId
                              option:(NSString *) option
                                page:(NSInteger) page
                         perPageData:(NSInteger) perPageData
                           authToken:(NSString *) authToken;
@end
