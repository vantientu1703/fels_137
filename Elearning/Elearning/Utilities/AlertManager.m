//
//  AlertManager.m
//  Elearning
//
//  Created by  on 6/20/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "AlertManager.h"

@implementation AlertManager

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
             viewControler:(UIViewController *)viewController
              reloadAction:(void(^)())complete {
    UIAlertController *alerController;
    alerController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *reloadAction = [UIAlertAction actionWithTitle:ACTION_RELOAD style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (complete) {
            complete();
        }
    }];
    UIAlertAction *quitAction = [UIAlertAction actionWithTitle:ACTION_QUIT style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        exit(0);
    }];
    [alerController addAction:reloadAction];
    [alerController addAction:quitAction];
    [viewController presentViewController:alerController
                                 animated:YES
                               completion:nil];
}

@end
