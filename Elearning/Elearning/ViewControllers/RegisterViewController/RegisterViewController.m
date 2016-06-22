//
//  RegisterViewController.m
//  Elearning
//
//  Created by Văn Tiến Tú on 5/20/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "RegisterViewController.h"
#import "User.h"
#import "RegisterManager.h"
#import "StoreData.h"
#import "LoadingView.h"

@interface RegisterViewController ()<RegisterManagerDelegate>
@property (strong, nonatomic) LoadingView *loadingView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtRetypePassword;
@property (weak, nonatomic) IBOutlet UITextField *txtFullName;
@property (weak, nonatomic) IBOutlet UILabel *lblAlert;
- (IBAction)btnCancel:(id)sender;
- (IBAction)btnDone:(id)sender;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Register";
    RegisterManager *registerManager = [[RegisterManager alloc] init];
    registerManager.delegate = self;
    [registerManager doLogout];
}

- (IBAction)turnOffKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (self.txtEmail.text.length && self.txtPassword.text.length &&
            self.txtRetypePassword.text.length && self.txtFullName.text.length) {
        [self register];
    }
    return YES;
}

- (IBAction)btnCancel:(id)sender {
    [self goLogin];
}

- (IBAction)btnDone:(id)sender {
    [self register];
}

- (void)register {
    [self.view endEditing:YES];
    self.loadingView = [[LoadingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.loadingView];
    self.lblAlert.text = @"";
    RegisterManager *registerManager = [[RegisterManager alloc] init];
    registerManager.delegate = self;
    [registerManager doRegisterWithEmail:self.txtEmail.text
                                    name:self.txtFullName.text
                                password:self.txtPassword.text
                       confirmedPassword:self.txtRetypePassword.text];
}

#pragma mark RegisterManagerDelegate
- (void)didLogoutwithMessage:(NSString *)message withError:(NSError *)error {
    [StoreData clearUser];
}

- (void)didResponseWithMessage:(NSString *)message withError:(NSError *)error {
    CGFloat height = CGRectGetHeight(self.lblAlert.frame);
    self.scrollView.contentOffset = CGPointMake(0.f, height);
    [self.loadingView removeFromSuperview];
    self.loadingView = nil;
    if ([message isEqualToString:@""] && !error) {
        [StoreData clearInput];
        UserInput *input = [[UserInput alloc] init];
        input.rememberMe = YES;
        input.emailInput = self.txtEmail.text;
        input.passwordInput = self.txtPassword.text;
        [StoreData setInput:input];
        [self goHome];
    } else {
        self.lblAlert.text = message;
    }
}

#pragma mark Open other screen
- (void)goHome {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"HomeViewController"];
    self.navigationController.viewControllers = @[vc];
}

- (void)goLogin {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
