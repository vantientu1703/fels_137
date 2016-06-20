//
//  AlertManager.h
//  Elearning
//
//  Created by  on 6/20/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertManager : NSObject
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
             viewControler:(UIViewController *)viewController
              reloadAction:(void(^)())complete;
@end
