//
//  ContactDetailsViewController.m
//  ContactsTable
//
//  Created by Liubou Sakalouskaya on 6/9/19.
//  Copyright © 2019 Liubou Sakalouskaya. All rights reserved.
//

#import "ContactDetailsViewController.h"
#import "ContactDetailsHeaderView.h"
#import "UIColor+ColorFromHex.h"

NSString * const phoneCellReuseId = @"phoneCellReuseId";

@interface ContactDetailsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *detailsTableView;
@property (weak, nonatomic) IBOutlet ContactDetailsHeaderView *headerView;

@end

@implementation ContactDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Контакты";
    [self setupHeaderView];
    [self setupDetailsTableView];
}

- (void)setupHeaderView {
    NSMutableString *fullName = [NSMutableString string];
    if (self.contact.familyName.length != 0) {
        [fullName appendString:[NSString stringWithFormat:@"%@ ", self.contact.familyName]];
    }
    if (self.contact.givenName.length != 0) {
        [fullName appendString:[NSString stringWithFormat:@"%@", self.contact.givenName]];
    }
    self.headerView.nameLabel.text = fullName;
    if (self.contact.imageDataAvailable) {
        self.headerView.photoImageView.image = [UIImage imageWithData:self.contact.imageData];
    }
}

- (void)setupDetailsTableView {
    self.detailsTableView.tableFooterView = [UIView new];
    self.detailsTableView.rowHeight = 70;
    self.detailsTableView.separatorColor = [UIColor colorFromHex:0xDFDFDF];
    [self.detailsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:phoneCellReuseId];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGSize size = [self.headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    if (self.headerView.bounds.size.height != size.height) {
        self.headerView.frame = CGRectMake(0, 0, self.headerView.frame.size.width, size.height);
        self.detailsTableView.tableHeaderView = self.headerView;
        
    }
    if (self.detailsTableView.contentSize.height <= self.detailsTableView.bounds.size.height) {
        self.detailsTableView.scrollEnabled = NO;
    } else {
        self.detailsTableView.scrollEnabled = YES;
    }
}

#pragma mark - UITableViewDelegate



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contact.phoneNumbers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:phoneCellReuseId forIndexPath:indexPath];
    cell.textLabel.text = self.contact.phoneNumbers[indexPath.row].value.stringValue;
    return cell;
}

@end
