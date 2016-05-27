//
//  LessonViewController.m
//  Elearning
//
//  Created by Văn Tiến Tú on 5/20/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "LessonViewController.h"
#import "WordItem.h"
#import "iOSRequest.h"
#import "DBUtil.h"
#import "AnswerItem.h"
#import "ResultViewController.h"
#import "LessonCategoryManager.h"
#import "LessonCategoryItem.h"
#import "LoadingView.h"

@interface LessonViewController ()<UIScrollViewDelegate,LessonCategoryManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelTotalWords;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *btnAnswer1;
@property (weak, nonatomic) IBOutlet UIButton *btnAnswer2;
@property (weak, nonatomic) IBOutlet UIButton *btnAnswer3;
@property (weak, nonatomic) IBOutlet UIButton *btnAnswer4;


@property (nonatomic, strong) NSMutableArray *arrAnswers;
@property (nonatomic, strong) NSMutableArray *arrWords;
@property (nonatomic, strong) NSMutableArray *arrLearnedWords;

@property (nonatomic, strong) LessonCategoryItem *lesson;
@property (nonatomic, strong) LoadingView *loadingView;
//@property (nonatomic, strong) NSDictionary *lesson;
@end

@implementation LessonViewController
{
    int pagingAtScrollView;
    int numberOfLearnedWords;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.categoryItem.name;
    [self setupLoadingView];
    
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(btnResultView:)];
    [self getLessonWithCategoryID:self.categoryItem.ID
                        authToken:@"-Kx03yy94NhYc81Shz63_g"];
}

#pragma mark - LoadingView

- (void) setupLoadingView {
    
    self.loadingView = [[LoadingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.loadingView];
}

- (void) animateDismissLoadingView {
    [UIView animateWithDuration:0.1 animations:^{
        self.loadingView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.loadingView removeFromSuperview];
    }];
}
- (IBAction)btnResultView:(id)sender {
    
    UIStoryboard *st = [UIStoryboard storyboardWithName:@"SecondStoryboard" bundle:nil];
    ResultViewController *revc = [st instantiateViewControllerWithIdentifier:@"resultviewcontroller"];
    
    revc.arrLearnedWords = self.arrLearnedWords;
    revc.arrWords = self.arrWords;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:revc];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nav animated:YES completion:nil];
    
}

#pragma mark - LessonCategoryManagerDelegate

- (void) getLessonWithCategoryID:(NSString*) categoryID
                       authToken:(NSString*) authToken{
    LessonCategoryManager *lessManager = [[LessonCategoryManager alloc] init];
    lessManager.delegate = self;
    [lessManager doGetLessonWithCategoryId:categoryID
                                 authToken:authToken];
}

- (void)didReceiveLessonObject:(LessonCategoryItem *)lesson
                         error:(NSError *)error {
    
    if (error) {
        [self turnOnAlertWhenDisconneted];
    } else {
        [self animateDismissLoadingView];
        self.lesson = lesson;
        [self loadData];
    }
}

- (void)didReceiveUpdateLessonWithBool:(BOOL)success {
    if (success) {
        NSLog(@"Update Success");
    } else {
        NSLog(@"Update Fail");
        [self turnOnAlertWhenDisconneted];
    }
}
#pragma mark - AlertController

- (void) turnOnAlertWhenDisconneted {
    UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"Reminder"
                                                                            message:@"Check internet network,please"
                                                                     preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Reload"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         [self getLessonWithCategoryID:self.categoryItem.ID
                                                                             authToken:@"-Kx03yy94NhYc81Shz63_g"];
                                                     }];
    UIAlertAction *quitAction = [UIAlertAction actionWithTitle:@"Quit"
                                                       style:UIAlertActionStyleDestructive
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         exit(0);
                                                     }];
    [alerController addAction:okAction];
    [alerController addAction:quitAction];
    [self presentViewController:alerController
                       animated:YES
                     completion:nil];
}
- (void) loadData {
    
            self.arrWords = self.lesson.arrWords;
            self.arrLearnedWords = [[NSMutableArray alloc] init];
            
            //Label learnedwords/totalword
            
            self.labelTotalWords.text = [NSString stringWithFormat:@"0/%lu",(unsigned long)self.arrWords.count];
            
            // Init arrLearnedWords is blank
            for (int i = 0; i < self.arrWords.count; i ++) {
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                [arr addObject:@""];
                [arr addObject:@""];
                [self.arrLearnedWords addObject:arr];
            }
            
            CGSize size = self.scrollView.frame.size;
            
            // setup content size for scrollview
            for (int i = 0; i < self.arrWords.count; i ++) {
                
                self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.arrWords.count, self.scrollView.frame.size.height);
                UIView *viewWords = [[UIView alloc] initWithFrame:CGRectMake(i * size.width, 0,size.width, size.height)];
                [self.scrollView addSubview:viewWords];
                
                WordItem *wordItem = [DBUtil dbItemToWordItem:self.arrWords[i]];
                
                UILabel *labelWord = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, size.width, 40)];
                labelWord.textAlignment = NSTextAlignmentCenter;
                labelWord.text = wordItem.content;
                labelWord.textColor = [UIColor blackColor];
                [viewWords addSubview:labelWord];
            }
            
            // set up button
            WordItem *newWord = [WordItem new];
            newWord = [DBUtil dbItemToWordItem:self.arrWords[0]];
            self.arrAnswers = newWord.arrAnswers;

            [self.btnAnswer1 setTitle:self.arrAnswers[0][@"content"] forState:UIControlStateNormal];
            [self.btnAnswer2 setTitle:self.arrAnswers[1][@"content"] forState:UIControlStateNormal];
            [self.btnAnswer3 setTitle:self.arrAnswers[2][@"content"] forState:UIControlStateNormal];
            [self.btnAnswer4 setTitle:self.arrAnswers[3][@"content"] forState:UIControlStateNormal];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    pagingAtScrollView = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    
    // Setup button when change question
    WordItem *newWord = [WordItem new];
    newWord = [DBUtil dbItemToWordItem:self.arrWords[pagingAtScrollView]];
    self.arrAnswers = newWord.arrAnswers;
    
    [self.btnAnswer1 setTitle:self.arrAnswers[0][@"content"] forState:UIControlStateNormal];
    [self.btnAnswer2 setTitle:self.arrAnswers[1][@"content"] forState:UIControlStateNormal];
    [self.btnAnswer3 setTitle:self.arrAnswers[2][@"content"] forState:UIControlStateNormal];
    [self.btnAnswer4 setTitle:self.arrAnswers[3][@"content"] forState:UIControlStateNormal];
    
    // setup background color vs title color question answered and question have not answer
    
    if (![self.arrLearnedWords[pagingAtScrollView][0] isEqualToString:@""]) {
        
        if ([self.arrLearnedWords[pagingAtScrollView][1] isEqualToString:@"1"]) {
            
            [self.btnAnswer1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.btnAnswer1 setBackgroundColor:[UIColor blueColor]];
            
            [self.btnAnswer2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer2 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            [self.btnAnswer3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer3 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            [self.btnAnswer4 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer4 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
        } else if ([self.arrLearnedWords[pagingAtScrollView][1] isEqualToString:@"2"]) {
            
            [self.btnAnswer1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer1 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            [self.btnAnswer2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.btnAnswer2 setBackgroundColor:[UIColor blueColor]];
            
            [self.btnAnswer3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer3 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            [self.btnAnswer4 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer4 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        } else if ([self.arrLearnedWords[pagingAtScrollView][1] isEqualToString:@"3"]) {
            
            [self.btnAnswer1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer1 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            [self.btnAnswer2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer2 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            [self.btnAnswer3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.btnAnswer3 setBackgroundColor:[UIColor blueColor]];
            
            [self.btnAnswer4 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer4 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        } else if ([self.arrLearnedWords[pagingAtScrollView][1] isEqualToString:@"4"]) {
            
            [self.btnAnswer1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer1 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            [self.btnAnswer2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer2 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            [self.btnAnswer3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer3 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            [self.btnAnswer4 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.btnAnswer4 setBackgroundColor:[UIColor blueColor]];
        }
    } else {
        [self.btnAnswer1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.btnAnswer2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.btnAnswer3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.btnAnswer4 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        [self.btnAnswer1 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [self.btnAnswer2 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [self.btnAnswer3 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [self.btnAnswer4 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    }

    
}
#pragma mark - Implement all buttons

- (IBAction)btnPre:(id)sender {
    pagingAtScrollView --;
    if (pagingAtScrollView < 0) {
        pagingAtScrollView = 0;
    }
    self.scrollView.contentOffset = CGPointMake(pagingAtScrollView * self.scrollView.frame.size.width, 0);
    
    // Setup button when changed question
    WordItem *newWord = [WordItem new];
    newWord = [DBUtil dbItemToWordItem:self.arrWords[pagingAtScrollView]];
    self.arrAnswers = newWord.arrAnswers;
    
    [self.btnAnswer1 setTitle:self.arrAnswers[0][@"content"] forState:UIControlStateNormal];
    [self.btnAnswer2 setTitle:self.arrAnswers[1][@"content"] forState:UIControlStateNormal];
    [self.btnAnswer3 setTitle:self.arrAnswers[2][@"content"] forState:UIControlStateNormal];
    [self.btnAnswer4 setTitle:self.arrAnswers[3][@"content"] forState:UIControlStateNormal];
    
    // setup background color vs title color question answered and question have not answer
    
    if (![self.arrLearnedWords[pagingAtScrollView][0] isEqualToString:@""]) {
        
        if ([self.arrLearnedWords[pagingAtScrollView][1] isEqualToString:@"1"]) {
            
            [self.btnAnswer1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.btnAnswer1 setBackgroundColor:[UIColor blueColor]];
            
            [self.btnAnswer2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer2 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            [self.btnAnswer3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer3 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            [self.btnAnswer4 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer4 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
        } else if ([self.arrLearnedWords[pagingAtScrollView][1] isEqualToString:@"2"]) {
            
            [self.btnAnswer1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer1 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            [self.btnAnswer2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.btnAnswer2 setBackgroundColor:[UIColor blueColor]];
            
            [self.btnAnswer3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer3 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            [self.btnAnswer4 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer4 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        } else if ([self.arrLearnedWords[pagingAtScrollView][1] isEqualToString:@"3"]) {
            
            [self.btnAnswer1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer1 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            [self.btnAnswer2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer2 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            [self.btnAnswer3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.btnAnswer3 setBackgroundColor:[UIColor blueColor]];
            
            [self.btnAnswer4 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer4 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        } else if ([self.arrLearnedWords[pagingAtScrollView][1] isEqualToString:@"4"]) {
            
            [self.btnAnswer1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer1 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            [self.btnAnswer2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer2 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            [self.btnAnswer3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer3 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            [self.btnAnswer4 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.btnAnswer4 setBackgroundColor:[UIColor blueColor]];
        }
    } else {
        [self.btnAnswer1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.btnAnswer2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.btnAnswer3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.btnAnswer4 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        [self.btnAnswer1 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [self.btnAnswer2 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [self.btnAnswer3 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [self.btnAnswer4 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    }

}
- (IBAction)btnNext:(id)sender {
    pagingAtScrollView ++;
    if (pagingAtScrollView >= self.arrWords.count) {
        pagingAtScrollView = (int)self.arrWords.count - 1;
    }
    
    self.scrollView.contentOffset = CGPointMake(pagingAtScrollView * self.scrollView.frame.size.width, 0);
    
     // Setup button when changed question
    WordItem *newWord = [WordItem new];
    newWord = [DBUtil dbItemToWordItem:self.arrWords[pagingAtScrollView]];
    self.arrAnswers = newWord.arrAnswers;
    
    [self.btnAnswer1 setTitle:self.arrAnswers[0][@"content"] forState:UIControlStateNormal];
    [self.btnAnswer2 setTitle:self.arrAnswers[1][@"content"] forState:UIControlStateNormal];
    [self.btnAnswer3 setTitle:self.arrAnswers[2][@"content"] forState:UIControlStateNormal];
    [self.btnAnswer4 setTitle:self.arrAnswers[3][@"content"] forState:UIControlStateNormal];
    
    
    // setup background color vs title color question answered and question have not answer
    
    if (![self.arrLearnedWords[pagingAtScrollView][0] isEqualToString:@""]) {
        
        if ([self.arrLearnedWords[pagingAtScrollView][1] isEqualToString:@"1"]) {
            
            [self.btnAnswer1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.btnAnswer1 setBackgroundColor:[UIColor blueColor]];
            
            [self.btnAnswer2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer2 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            [self.btnAnswer3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer3 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            [self.btnAnswer4 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer4 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
        } else if ([self.arrLearnedWords[pagingAtScrollView][1] isEqualToString:@"2"]) {
            
            [self.btnAnswer1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer1 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            [self.btnAnswer2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.btnAnswer2 setBackgroundColor:[UIColor blueColor]];
            
            [self.btnAnswer3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer3 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            [self.btnAnswer4 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer4 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        } else if ([self.arrLearnedWords[pagingAtScrollView][1] isEqualToString:@"3"]) {
            
            [self.btnAnswer1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer1 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            [self.btnAnswer2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer2 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            [self.btnAnswer3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.btnAnswer3 setBackgroundColor:[UIColor blueColor]];
            
            [self.btnAnswer4 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer4 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        } else if ([self.arrLearnedWords[pagingAtScrollView][1] isEqualToString:@"4"]) {
            
            [self.btnAnswer1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer1 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            [self.btnAnswer2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer2 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            [self.btnAnswer3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.btnAnswer3 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            [self.btnAnswer4 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.btnAnswer4 setBackgroundColor:[UIColor blueColor]];
        }
    } else {
        [self.btnAnswer1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.btnAnswer2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.btnAnswer3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.btnAnswer4 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        [self.btnAnswer1 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [self.btnAnswer2 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [self.btnAnswer3 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [self.btnAnswer4 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    }
    
    
}


- (IBAction)btnAnswer1:(id)sender {
    
    if ([self.arrLearnedWords[pagingAtScrollView][0] isEqualToString:@""]) {
        numberOfLearnedWords ++;
        
        self.labelTotalWords.text = [NSString stringWithFormat:@"%d/%lu",numberOfLearnedWords,(unsigned long)self.arrWords.count];
    }
    // Get answer of word
    
    AnswerItem *answerItem = [DBUtil dbAnswerItem:self.arrAnswers[0]];
    BOOL isCorrect = answerItem.isCorrect;
    NSMutableArray *arr = self.arrLearnedWords[pagingAtScrollView];
    
    if (isCorrect) {
        arr[0] = @"true";
        arr[1] = @"1";
    } else {
        arr[0]= @"false";
        arr[1] = @"1";
    }
    self.arrLearnedWords[pagingAtScrollView] = arr;
    
    [self.btnAnswer1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.btnAnswer2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.btnAnswer3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.btnAnswer4 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [self.btnAnswer1 setBackgroundColor:[UIColor blueColor]];
    [self.btnAnswer2 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.btnAnswer3 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.btnAnswer4 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    LessonCategoryManager *lessCategoryManager = [LessonCategoryManager new];
    lessCategoryManager.delegate = self;
    
    WordItem *wordItem = [WordItem new];
    wordItem = [DBUtil dbItemToWordItem:self.arrWords[pagingAtScrollView]];
                
    [lessCategoryManager doUpdateLessonWithAuthToken:@"-Kx03yy94NhYc81Shz63_g"
                                            lessonID:self.lesson.ID
                                            resultID:wordItem.resultID
                                            answerID:answerItem.ID];
    
    
}
- (IBAction)btnAnswer2:(id)sender {
    
    if ([self.arrLearnedWords[pagingAtScrollView][0] isEqualToString:@""]) {
        numberOfLearnedWords ++;
        
        self.labelTotalWords.text = [NSString stringWithFormat:@"%d/%lu",numberOfLearnedWords,(unsigned long)self.arrWords.count];
    }
    AnswerItem *answerItem = [DBUtil dbAnswerItem:self.arrAnswers[1]];
    BOOL isCorrect = answerItem.isCorrect;
    
    NSMutableArray *arr = self.arrLearnedWords[pagingAtScrollView];
    
    if (isCorrect) {
        arr[0] = @"true";
        arr[1] = @"2";
    } else {
        arr[0]= @"false";
        arr[1] = @"2";
    }
    self.arrLearnedWords[pagingAtScrollView] = arr;
    
    [self.btnAnswer1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.btnAnswer2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.btnAnswer3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.btnAnswer4 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [self.btnAnswer1 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.btnAnswer2 setBackgroundColor:[UIColor blueColor]];
    [self.btnAnswer3 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.btnAnswer4 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    LessonCategoryManager *lessCategoryManager = [LessonCategoryManager new];
    lessCategoryManager.delegate = self;
    
    WordItem *wordItem = [WordItem new];
    wordItem = [DBUtil dbItemToWordItem:self.arrWords[pagingAtScrollView]];
    
    [lessCategoryManager doUpdateLessonWithAuthToken:@"-Kx03yy94NhYc81Shz63_g"
                                            lessonID:self.lesson.ID
                                            resultID:wordItem.resultID
                                            answerID:answerItem.ID];
}
- (IBAction)btnAnswer3:(id)sender {
    
    if ([self.arrLearnedWords[pagingAtScrollView][0] isEqualToString:@""]) {
        numberOfLearnedWords ++;
        
        self.labelTotalWords.text = [NSString stringWithFormat:@"%d/%lu",numberOfLearnedWords,(unsigned long)self.arrWords.count];
    }
    AnswerItem *answerItem = [DBUtil dbAnswerItem:self.arrAnswers[2]];
    BOOL isCorrect = answerItem.isCorrect;
    NSMutableArray *arr = self.arrLearnedWords[pagingAtScrollView];
    
    if (isCorrect) {
        arr[0] = @"true";
        arr[1] = @"3";
    } else {
        arr[0]= @"false";
        arr[1] = @"3";
    }
    self.arrLearnedWords[pagingAtScrollView] = arr;
    
    [self.btnAnswer1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.btnAnswer2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.btnAnswer3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.btnAnswer4 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [self.btnAnswer1 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.btnAnswer2 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.btnAnswer3 setBackgroundColor:[UIColor blueColor]];
    [self.btnAnswer4 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    LessonCategoryManager *lessCategoryManager = [LessonCategoryManager new];
    lessCategoryManager.delegate = self;
    
    WordItem *wordItem = [WordItem new];
    wordItem = [DBUtil dbItemToWordItem:self.arrWords[pagingAtScrollView]];
    
    [lessCategoryManager doUpdateLessonWithAuthToken:@"-Kx03yy94NhYc81Shz63_g"
                                            lessonID:self.lesson.ID
                                            resultID:wordItem.resultID
                                            answerID:answerItem.ID];
}
- (IBAction)btnAnswer4:(id)sender {
    
    if ([self.arrLearnedWords[pagingAtScrollView][0] isEqualToString:@""]) {
        numberOfLearnedWords ++;
        
        self.labelTotalWords.text = [NSString stringWithFormat:@"%d/%lu",numberOfLearnedWords,(unsigned long)self.arrWords.count];
    }
    
    AnswerItem *answerItem = [DBUtil dbAnswerItem:self.arrAnswers[3]];
    BOOL isCorrect = answerItem.isCorrect;
    NSMutableArray *arr = self.arrLearnedWords[pagingAtScrollView];
    
    if (isCorrect) {
        arr[0] = @"true";
        arr[1] = @"4";
    } else {
        arr[0]= @"false";
        arr[1] = @"4";
    }
    self.arrLearnedWords[pagingAtScrollView] = arr;
    
    [self.btnAnswer1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.btnAnswer2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.btnAnswer3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.btnAnswer4 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [self.btnAnswer1 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.btnAnswer2 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.btnAnswer3 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.btnAnswer4 setBackgroundColor:[UIColor blueColor]];
    
    LessonCategoryManager *lessCategoryManager = [LessonCategoryManager new];
    lessCategoryManager.delegate = self;
    
    WordItem *wordItem = [WordItem new];
    wordItem = [DBUtil dbItemToWordItem:self.arrWords[pagingAtScrollView]];
    
    [lessCategoryManager doUpdateLessonWithAuthToken:@"-Kx03yy94NhYc81Shz63_g"
                                            lessonID:self.lesson.ID
                                            resultID:wordItem.resultID
                                            answerID:answerItem.ID];
}

@end
