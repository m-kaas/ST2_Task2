//
//  ContactsTableViewController.m
//  ContactsTable
//
//  Created by Liubou Sakalouskaya on 6/7/19.
//  Copyright © 2019 Liubou Sakalouskaya. All rights reserved.
//

#import "ContactsTableViewController.h"

NSString * const cellReuseId = @"reuseId";

@interface ContactsTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *contactsTableView;

@end

@implementation ContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Contacts";
    [self.contactsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReuseId];
    self.contactsTableView.delegate = self;
    self.contactsTableView.dataSource = self;
    self.contactsTableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDelegate



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId forIndexPath:indexPath];
    cell.textLabel.text = @"tmp";
    return cell;
}

@end
