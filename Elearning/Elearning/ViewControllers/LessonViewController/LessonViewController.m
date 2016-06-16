//
//  LessonViewController.m
//  Elearning
//
//  Created by Văn Tiến Tú on 5/20/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "LessonViewController.h"
#import "WordItem.h"
#import "DBUtil.h"
#import "AnswerItem.h"
#import "ResultViewController.h"
#import "LessonCategoryManager.h"
#import "LessonCategoryItem.h"
#import "LoadingView.h"
#import "Constants.h"

@interface LessonViewController ()<UIScrollViewDelegate,LessonCategoryManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelTotalWords;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnAnswer1;
@property (weak, nonatomic) IBOutlet UIButton *btnAnswer2;
@property (weak, nonatomic) IBOutlet UIButton *btnAnswer3;
@property (weak, nonatomic) IBOutlet UIButton *btnAnswer4;
@property (strong, nonatomic) NSMutableArray *arrAnswers;
@property (strong, nonatomic) NSMutableArray *arrWords;
@property (strong, nonatomic) NSMutableArray *arrLearnedWords;
@property (strong, nonatomic) LessonCategoryItem *lesson;
@property (strong, nonatomic) LoadingView *loadingView;
@property (strong, nonatomic) User *user;

@end

@implementation LessonViewController
{
    NSInteger _pagingAtScrollView;
    NSInteger _numberOfLearnedWords;
}

NSString *const TITLER_REMINDER_CONTROLLER = @"Reminder";
NSString *const RELOAD_ACT_CONTROLLER = @"Reload";
NSString *const QUIT_ACT_CONTROLLER = @"Quit";
NSString *const CHECK_INTERNET = @"Check internet network,please";
NSInteger const NUMBER_OF_PAGE_SCROLLVIEW = 5;
NSInteger const NUMBER_OF_TAG = 4;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.categoryItem.name;
    self.user = [StoreData getUser];
    [self setupLoadingView];
    _pagingAtScrollView = 0;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnResultView:)];
    [self getLessonWithCategoryID:self.categoryItem.ID authToken:self.user.authToken];
}

#pragma mark - LoadingView

- (void)setupLoadingView {
    self.loadingView = [[LoadingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.loadingView];
}
- (void)animateDismissLoadingView {
    [UIView animateWithDuration:0.1f animations:^{
        self.loadingView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.loadingView removeFromSuperview];
    }];
}
- (IBAction)btnResultView:(id)sender {

//    UIStoryboard *st = [UIStoryboard storyboardWithName:@"SecondStoryboard" bundle:nil];
//    ResultViewController *revc = [st instantiateViewControllerWithIdentifier:@"resultviewcontroller"];
//    
//    revc.arrLearnedWords = self.arrLearnedWords;
//    revc.arrWords = self.arrWords;
//    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:revc];
//    nav.modalPresentationStyle = UIModalPresentationFormSheet;
//    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - LessonCategoryManagerDelegate

- (void)getLessonWithCategoryID:(NSString *)categoryID
                       authToken:(NSString *)authToken{
    LessonCategoryManager *lessManager = [[LessonCategoryManager alloc] init];
    lessManager.delegate = self;
    [lessManager getLessonWithCategoryId:categoryID authToken:authToken];
}
- (void)didReceiveLessonObject:(LessonCategoryItem *)lesson
                       message:(NSString *)message
                         error:(NSError *)error {
    if (error) {
        [self turnOnAlertWithMessage:message];
    } else {
        if (!message.length) {
            [self animateDismissLoadingView];
            self.lesson = lesson;
            [self loadData];
        } else {
            [self turnOnAlertWithMessage:message];
        }
    }
}
- (void)didReceiveUpdateLessonWithBool:(BOOL)success withMessage:(NSString *)message{
    if (success) {
        if (message.length) {
            [self turnOnAlertWithMessage:message];
        }
    } else {
        [self turnOnAlertWithMessage:message];
    }
}
#pragma mark - AlertController

- (void)turnOnAlertWithMessage:(NSString *)message {
    UIAlertController *alerController;
    if (!message.length) {
        alerController = [UIAlertController alertControllerWithTitle:TITLER_REMINDER_CONTROLLER message:CHECK_INTERNET preferredStyle:UIAlertControllerStyleActionSheet];
    } else {
        alerController = [UIAlertController alertControllerWithTitle:TITLER_REMINDER_CONTROLLER message:message preferredStyle:UIAlertControllerStyleActionSheet];
    }
    UIAlertAction *reloadAction = [UIAlertAction actionWithTitle:RELOAD_ACT_CONTROLLER style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *quitAction = [UIAlertAction actionWithTitle:QUIT_ACT_CONTROLLER style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        exit(0);
    }];
    [alerController addAction:reloadAction];
    [alerController addAction:quitAction];
    [self presentViewController:alerController
                       animated:YES
                     completion:nil];
}
- (void)loadData {
    self.arrWords = self.lesson.arrWords;
    self.arrLearnedWords = [[NSMutableArray alloc] init];
    //Label learnedwords/totalword
    self.labelTotalWords.text = [NSString stringWithFormat:@"0/%lu",NUMBER_OF_PAGE_SCROLLVIEW];
    // Init arrLearnedWords is blank
    for (int i = 0; i < NUMBER_OF_PAGE_SCROLLVIEW; i ++) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        arr = [@[@"",@""] mutableCopy];
        [self.arrLearnedWords addObject:arr];
    }
    CGSize size = self.scrollView.frame.size;
    // setup content size for scrollview
    [self.arrWords enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * NUMBER_OF_PAGE_SCROLLVIEW, self.scrollView.frame.size.height);
        UIView *viewWords = [[UIView alloc] initWithFrame:CGRectMake(idx * size.width, 0.f,size.width, size.height)];
        [self.scrollView addSubview:viewWords];
        WordItem *wordItem = [DBUtil dbItemToWordItem:obj];
        UILabel *labelWord = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 10.f, size.width, 40.f)];
        labelWord.backgroundColor = [UIColor whiteColor];
        labelWord.textAlignment = NSTextAlignmentCenter;
        labelWord.text = wordItem.content;
        labelWord.textColor = [UIColor blackColor];
        [viewWords addSubview:labelWord];
    }];
    // set up button
    WordItem *newWord = [WordItem new];
    if (self.arrWords.count > 0) {
        newWord = [DBUtil dbItemToWordItem:self.arrWords[0]];
        self.arrAnswers = newWord.arrAnswers;
        [self.arrLearnedWords enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *title = obj[@"content"];
            [self setTitleForButtonNoSelect:title withTag:idx + 1];
        }];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _pagingAtScrollView = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    // Setup button when change question
    WordItem *newWord = [WordItem new];
    newWord = [DBUtil dbItemToWordItem:self.arrWords[_pagingAtScrollView]];
    self.arrAnswers = newWord.arrAnswers;
    // setup background color vs title color question answered and question have not answer
    [self.arrAnswers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = obj[@"content"];
        NSInteger tag = [self.arrLearnedWords[_pagingAtScrollView][1] integerValue];
        if (tag == idx + 1) {
            [self setTitleForButtonSelected:title withTag:tag];
        } else {
            [self setTitleForButtonNoSelect:title withTag:idx + 1];
        }
    }];
}
#pragma mark - Implement all buttons

- (IBAction)btnPre:(id)sender {
    _pagingAtScrollView--;
    if (_pagingAtScrollView < 0) {
        _pagingAtScrollView = 0;
    }
    [self setTitleColorForButton];
}
- (IBAction)btnNext:(id)sender {
    if (_pagingAtScrollView < NUMBER_OF_PAGE_SCROLLVIEW - 1) {
        _pagingAtScrollView++;
    }
    [self setTitleColorForButton];
}
- (IBAction)btnAnswerPress:(id)sender {
    NSInteger tag = [sender tag];
    if ([sender isMemberOfClass:[UIButton class]]) {
        for (NSInteger i = 1; i <= NUMBER_OF_TAG; i++) {
            if (i == tag) {
                [self setTitleForButtonSelected:[sender titleLabel].text withTag:i];
            } else {
                [self setColorForButtonNoSelectWithTag:i];
            }
        }
        if (![self.arrLearnedWords[_pagingAtScrollView][0] length]) {
            _numberOfLearnedWords++;
            self.labelTotalWords.text = [NSString stringWithFormat:@"%ld/%lu", _numberOfLearnedWords, NUMBER_OF_PAGE_SCROLLVIEW];
        }
        // Get answer of word
        AnswerItem *answerItem;
        if (self.arrAnswers.count > tag - 1) {
            NSDictionary *dicAnswer = self.arrAnswers[tag -1];
            answerItem = [DBUtil dbAnswerItem:dicAnswer];
            BOOL isCorrect = answerItem.isCorrect;
            NSMutableArray *arr = self.arrLearnedWords[_pagingAtScrollView];
            if (isCorrect) {
                arr[0] = @"true";
                arr[1] = [NSString stringWithFormat:@"%ld",tag];
            } else {
                arr[0] = @"false";
                arr[1] = [NSString stringWithFormat:@"%ld",tag];
            }
            self.arrLearnedWords[_pagingAtScrollView] = arr;
        }
        LessonCategoryManager *lessCategoryManager = [LessonCategoryManager new];
        lessCategoryManager.delegate = self;
        WordItem *wordItem = [WordItem new];
        wordItem = [DBUtil dbItemToWordItem:self.arrWords[_pagingAtScrollView]];
        [lessCategoryManager updateLessonWithAuthToken:self.user.authToken
                                              lessonID:self.lesson.ID
                                              resultID:wordItem.resultID
                                              answerID:answerItem.ID];
    }
}
- (void)setColorForButtonNoSelectWithTag:(NSInteger)tag {
    UIView *view = [self.view viewWithTag:tag];
    if (view && [view isMemberOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)view;
        button.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
}
- (void)setTitleForButtonSelected:(NSString *)title withTag:(NSInteger)tag {
    UIView *view = [self.view viewWithTag:tag];
    if (view && [view isMemberOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)view;
        [button setTitle:title forState:UIControlStateNormal];
        button.backgroundColor = [UIColor blueColor];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}
- (void)setTitleForButtonNoSelect:(NSString *)title withTag:(NSInteger)tag {
    UIView *view = [self.view viewWithTag:tag];
    if (view && [view isMemberOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)view;
        [button setTitle:title forState:UIControlStateNormal];
        button.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
}
- (void)setTitleColorForButton {
    self.scrollView.contentOffset = CGPointMake(_pagingAtScrollView * self.scrollView.frame.size.width, 0.f);
    WordItem *newWord = [WordItem new];
    newWord = [DBUtil dbItemToWordItem:self.arrWords[_pagingAtScrollView]];
    self.arrAnswers = newWord.arrAnswers;
    // setup background color vs title color question answered and question have not answer
    [self.arrAnswers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = obj[@"content"];
        NSInteger tag = [self.arrLearnedWords[_pagingAtScrollView][1] integerValue];
        if (tag != 0 && tag == idx + 1) {
            [self setTitleForButtonSelected:title withTag:tag];
        } else {
            [self setTitleForButtonNoSelect:title withTag:idx + 1];
        }
    }];
}
@end
