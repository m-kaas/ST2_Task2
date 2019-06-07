//
//  ContactsTableViewController.m
//  ContactsTable
//
//  Created by Liubou Sakalouskaya on 6/7/19.
//  Copyright © 2019 Liubou Sakalouskaya. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "Contacts/Contacts.h"

NSString * const cellReuseId = @"reuseId";

@interface ContactsTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *contactsTableView;
@property (strong, nonatomic) NSMutableArray *contacts;

@end

@implementation ContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Contacts";
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) {
        self.contacts = [NSMutableArray new];
        [self loadContacts];
        [self.contactsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReuseId];
        self.contactsTableView.delegate = self;
        self.contactsTableView.dataSource = self;
        self.contactsTableView.tableFooterView = [UIView new];
    } else {
        [self showAccessDeniedScreen];
    }
}

- (void)loadContacts {
    CNContactStore *contactStore = [CNContactStore new];
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    [contactStore enumerateContactsWithFetchRequest:fetchRequest
                                              error:nil
                                         usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                                             [self.contacts addObject:contact];
                                         }];
}

- (void)showAccessDeniedScreen {
    self.contactsTableView.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
    UILabel *accessDeniedLabel = [UILabel new];
    UIFont *font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    accessDeniedLabel.textColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0];
    accessDeniedLabel.font = font;
    accessDeniedLabel.text = @"Доступ к списку контактов запрещен. Войдите в Settings и разрешите доступ";
    accessDeniedLabel.numberOfLines = 0;
    accessDeniedLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:accessDeniedLabel];
    accessDeniedLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[[accessDeniedLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
                                              [accessDeniedLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
                                              [accessDeniedLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
                                              [self.view.trailingAnchor constraintEqualToAnchor:accessDeniedLabel.trailingAnchor constant:20]]];
}

- (void)viewDidLayoutSubviews {
    if (self.contactsTableView.contentSize.height <= self.contactsTableView.bounds.size.height) {
        self.contactsTableView.scrollEnabled = NO;
    } else {
        self.contactsTableView.scrollEnabled = YES;
    }
}

#pragma mark - UITableViewDelegate



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId forIndexPath:indexPath];
    CNContact *contact = self.contacts[indexPath.row];
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", contact.givenName, contact.familyName];
    cell.textLabel.text = fullName;
    return cell;
}

@end
