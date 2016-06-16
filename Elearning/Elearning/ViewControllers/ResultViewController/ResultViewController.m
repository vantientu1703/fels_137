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
#import "Constants.h"

@interface ResultViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStylePlain target:self action:@selector(popViewController:)];
}
- (IBAction)popViewController:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:KEY_POPVIEW object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrLearnedWords.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellResult";
    ResultTableViewCell *cell = (ResultTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    WordItem *wordItem = [DBUtil dbItemToWordItem:self.arrWords[indexPath.row]];
    cell.labelContent.text = wordItem.content;
    NSString *answer = self.arrLearnedWords[indexPath.row][0];
    if ([answer isEqualToString:@"false"]) {
        cell.imageViewResult.image = [UIImage imageNamed:@"false.png"];
    } else if ([answer isEqualToString:@"true"]) {
        cell.imageViewResult.image = [UIImage imageNamed:@"true.png"];
    } else {
        cell.imageViewResult.image = [UIImage imageNamed:@"hoicham.png"];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
@end
