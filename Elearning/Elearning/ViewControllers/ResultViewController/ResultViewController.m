//
//  ResultViewController.m
//  Elearning
//
//  Created by Văn Tiến Tú on 5/20/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "ResultViewController.h"
#import "HomeViewController.h"
#import "CategoriesViewController.h"
#import "ResultTableViewCell.h"
#import "WordItem.h"
#import "DBUtil.h"
@interface ResultViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(popViewController:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(backView:)];
}

- (IBAction)backView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)popViewController:(id)sender {
    
//    UIStoryboard *st = [UIStoryboard storyboardWithName:@"SecondStoryboard" bundle:nil];
//    CategoriesViewController *catvc = [st instantiateViewControllerWithIdentifier:@"categoriesviewcontroller"];
//    HomeViewController *homeViewController = [HomeViewController new];
//    [self.navigationController popToViewController:catvc animated:YES];
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrWords.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"CellIdentifier";
    
    ResultTableViewCell *cell = (ResultTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"ResultTableViewCell" owner:self options:nil];
        cell = xib[0];
    }
    
    WordItem *wordItem = [DBUtil dbItemToWordItem:self.arrWords[indexPath.row]];
    
    cell.labelContent.text = wordItem.content;
    if ([self.arrLearnedWords[indexPath.row][0] isEqualToString:@"false"]) {
        
        cell.image.image = [UIImage imageNamed:@"false.png"];
    } else if ([self.arrLearnedWords[indexPath.row][0] isEqualToString:@"true"]) {
        
        cell.image.image = [UIImage imageNamed:@"true.png"];
    } else {
        
        cell.image.image = [UIImage imageNamed:@"hoicham.png"];
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}
@end




















