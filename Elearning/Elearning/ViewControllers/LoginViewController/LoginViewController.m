//
//  LoginViewController.m
//  Elearning
//
//  Created by Văn Tiến Tú on 5/20/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginManager.h"
#import "StoreData.h"
#import "UserInput.h"
#import "HomeViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblAlert;
@property (weak, nonatomic) IBOutlet UIButton *btnRememberMe;
- (IBAction)btnLogin:(id)sender;
- (IBAction)btnRememberMe:(id)sender;
@end

@implementation LoginViewController

UIActivityIndicatorView *_spinnerLogin;
BOOL _rememberMeChecked;

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self checkLogin];
    self.title = @"Login";
    self.lblAlert.text = @"";
    [self checkRememberMe];
    // loading
    _spinnerLogin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _spinnerLogin.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [_spinnerLogin setCenter:CGPointMake(screenSize.width/2.0, screenSize.height/2.0)];
    [self.view addSubview:_spinnerLogin];
}

- (IBAction)TurnOffKeyboard:(id)sender {
    [self.view endEditing:YES];
}

 -(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)btnLogin:(id)sender {
    [_spinnerLogin startAnimating];
    self.lblAlert.text = @"";
    [self saveRememberMe];
    LoginManager *loginManager = [[LoginManager alloc] init];
    loginManager.delegate = self;
    [loginManager doLoginWithEmail:self.txtEmail.text
                          password:self.txtPassword.text
                          remember:_rememberMeChecked];
}

- (IBAction)btnRememberMe:(id)sender {
    if (_rememberMeChecked) {
        _rememberMeChecked = NO;
        [self.btnRememberMe setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
    } else {
        _rememberMeChecked = YES;
        [self.btnRememberMe setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
    }
    [self saveRememberMe];
}

#pragma mark - Check Remember Me
- (void)checkRememberMe {
    UserInput *input = [[UserInput alloc] init];
    input = [StoreData getInput];
    _rememberMeChecked = input.rememberMe;
    if (_rememberMeChecked) {
        [self.btnRememberMe setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        self.txtEmail.text = input.emailInput;
        self.txtPassword.text = input.passwordInput;
    } else {
        [self.btnRememberMe setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
    }
}

- (void)saveRememberMe {
    if (_rememberMeChecked) {
        UserInput *input = [[UserInput alloc] init];
        input.rememberMe = _rememberMeChecked;
        input.emailInput = self.txtEmail.text;
        input.passwordInput = self.txtPassword.text;
        [StoreData setInput:input];
    } else {
        [StoreData clearInput];
    }
}

#pragma mark - Check Login
- (void)checkLogin {
    if ([StoreData getLogin]) {
        [self goHome];
    }
}

#pragma mark - LoginManagerDelegate
- (void)didResponseWithMessage:(NSString *)message withError:(NSError *)error {
    [_spinnerLogin stopAnimating];
    if ([message isEqualToString:@""] && !error) {
        [StoreData setLogin:YES];
        [self goHome];
    } else {
        self.lblAlert.text = message;
    }
}

#pragma mark - Open other screen
- (void)goHome {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"HomeViewController"];
    self.navigationController.viewControllers = @[vc];
}
@end
