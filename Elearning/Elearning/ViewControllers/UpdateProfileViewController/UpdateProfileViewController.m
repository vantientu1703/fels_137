//
//  UpdateProfileViewController.m
//  Elearning
//
//  Created by Văn Tiến Tú on 5/20/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "UpdateProfileViewController.h"
#import "UpdateProfileManager.h"
#import "User.h"
#import "StoreData.h"
#import "LoadingView.h"
#import "UIImageView+WebCache.h"

@interface UpdateProfileViewController ()<UpdateProfileManagerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) LoadingView *loadingView;
@property (strong, nonatomic) UIImagePickerController *avatarPicker;
@property (strong, nonatomic) NSString *avatarString;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtRetypePassword;
@property (weak, nonatomic) IBOutlet UITextField *txtFullName;
@property (weak, nonatomic) IBOutlet UILabel *lblAlert;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
- (IBAction)btnCancel:(id)sender;
- (IBAction)btnUpdate:(id)sender;
@end

@implementation UpdateProfileViewController

UpdateProfileManager *_updateProfileManager;
BOOL _isUpdate;
BOOL _isAvatarChanged;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Update profile";
    self.lblAlert.text = @"";
    User *user = [StoreData getUser];
    self.txtEmail.text = user.email;
    self.txtNewPassword.text = @"";
    self.txtRetypePassword.text = @"";
    self.txtFullName.text = user.name;
    NSURL *url = [NSURL URLWithString:user.avatar];
    [self.imgAvatar sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"place.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) {
            self.imgAvatar.image = [UIImage imageNamed:@"noavatar.png"];
        }
    }];
    _updateProfileManager = [[UpdateProfileManager alloc] init];
    _updateProfileManager.delegate = self;
    // Click avatar
    [self.imgAvatar setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapOnAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnAvatarAction:)];
    [self.imgAvatar addGestureRecognizer:tapOnAvatar];
}

- (IBAction)turnOffKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)btnCancel:(id)sender {
    [self.view endEditing:YES];
    [_updateProfileManager cancelUpdateProfile];
    [self goHome];
}

- (IBAction)btnUpdate:(id)sender {
    [self.view endEditing:YES];
    User *user = [StoreData getUser];
    NSString *email = [NSString stringWithFormat:@"%@", self.txtEmail.text];
    NSString *name = [NSString stringWithFormat:@"%@", self.txtFullName.text];
    BOOL emailChanged = ![user.email isEqualToString:email];
    BOOL nameChanged = ![user.name isEqualToString:name];
    if (emailChanged || nameChanged || self.txtNewPassword.text.length || self.txtRetypePassword.text.length) {
        _isUpdate = YES;
    }
    if (_isUpdate) {
        _isUpdate = NO;
        [self updateProfile];
    }
}

- (void)updateProfile {
    [self.view endEditing:YES];
    self.loadingView = [[LoadingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.loadingView];
    self.lblAlert.text = @"";
    self.avatarString = @"";
    if (self.imgAvatar.image) {
        self.avatarString = [UIImageJPEGRepresentation(self.imgAvatar.image, 0.4) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    NSString *strImageData = [self.avatarString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [_updateProfileManager doUpdateProfileWithName:self.txtFullName.text
                                             email:self.txtEmail.text
                                          password:self.txtNewPassword.text
                              passwordConfirmation:self.txtRetypePassword.text
                                            avatar:strImageData];
}

#pragma mark - Avatar click
- (void)tapOnAvatarAction:(UITapGestureRecognizer *)tapOnAvatar {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AVATAR_ALERT_TITLE message:AVATAR_ALERT_MESSAGE preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:CANCEL_MESSAGE style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    }];
    UIAlertAction *gallery = [UIAlertAction actionWithTitle:CHOSSE_GALLERY_MESSAGE style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self chooseFromGallery];
    }];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:TAKE_PHOTO_MESSAGE style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self takePhoto];
    }];
    [alert addAction:camera];
    [alert addAction:gallery];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)chooseFromGallery {
    self.avatarPicker = [[UIImagePickerController alloc] init];
    self.avatarPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.avatarPicker.delegate = self;
    [self presentViewController:self.avatarPicker animated:YES completion:nil];
}

- (void)takePhoto {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertController *cameraErrorAlert = [UIAlertController alertControllerWithTitle:ERROR_CAMERA_TITLE message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cameraNotFound = [UIAlertAction actionWithTitle:ERROR_CAMERA_MESSAGE style:UIAlertActionStyleDestructive handler:nil];
        [cameraErrorAlert addAction:cameraNotFound];
        [self presentViewController:cameraErrorAlert animated:YES completion:nil];
    } else {
        self.avatarPicker = [[UIImagePickerController alloc] init];
        self.avatarPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.avatarPicker.delegate = self;
        [self presentViewController:self.avatarPicker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    CGFloat x0 = self.imgAvatar.frame.size.width * 5.f;
    CGFloat y0 = self.imgAvatar.frame.size.height * 5.f;
    CGFloat x1 = chosenImage.size.width;
    CGFloat y1 = chosenImage.size.height;
    CGFloat x2 = 0.f;
    CGFloat y2 = 0.f;
    if (x1 > y1) {
        x2 = x0;
        y2 = (x2 * y1) / x1;
    } else {
        y2 = y0;
        x2 = (y2 * x1) / y1;
    }
    CGSize viewSize = CGSizeMake(x2, y2);
    UIGraphicsBeginImageContext(viewSize);
    [chosenImage drawInRect:CGRectMake(0, 0, viewSize.width, viewSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    self.imgAvatar.image = newImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
    _isUpdate = YES;
    _isAvatarChanged = YES;
}

#pragma mark - UpdateProfileManagerDelegate
- (void)didResponseWithMessage:(NSString *)message withError:(NSError *)error {
    CGFloat height = CGRectGetHeight(self.lblAlert.frame);
    self.scrollView.contentOffset = CGPointMake(0.f, height);
    [self.loadingView removeFromSuperview];
    self.loadingView = nil;
    self.lblAlert.text = message;
    if ([message isEqualToString:UPDATE_PROFILE_SUCCESS]) {
        if (_isAvatarChanged) {
            User *user = [StoreData getUser];
            [[SDImageCache sharedImageCache] removeImageForKey:user.avatar fromDisk:YES];
        }
        [StoreData setShowUser:TRUE];
    }
}

#pragma mark - Open other screen
- (void)goHome {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
