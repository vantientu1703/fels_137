//
//  CategoryManager.h
//  Elearning
//
//  Created by Văn Tiến Tú on 5/26/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CategoryManagerDelegate <NSObject>

- (void) didReceiveCategoriesWithArray:(NSMutableArray*) arrCategories withError:(NSError*) error;

@end

@interface CategoryManager : NSObject

@property (nonatomic, assign) BOOL isError;
@property (nonatomic, weak) id<CategoryManagerDelegate> delegate;


/*
 * @
 */
- (void) doGetCategoryWithAuthToken:(NSString*) authToken
                               page:(NSInteger) page
                        perPageData:(NSInteger) perPageData;
@end
