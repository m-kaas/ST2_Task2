//
//  ContactsTableViewController.m
//  ContactsTable
//
//  Created by Liubou Sakalouskaya on 6/7/19.
//  Copyright © 2019 Liubou Sakalouskaya. All rights reserved.
//

#import <Contacts/Contacts.h>
#import "ContactsTableViewController.h"
#import "UIColor+ColorFromHex.h"
#import "AddressBook.h"

NSString * const cellReuseId = @"reuseId";

@interface ContactsTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *contactsTableView;
@property (strong, nonatomic) AddressBook *addressBook;

@end

@implementation ContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Контакты";
    self.addressBook = [AddressBook new];
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) {
        [self fetchContacts];
    } else {
        CNContactStore *store = [CNContactStore new];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                [self fetchContacts];
            } else {
                [self showAccessDeniedScreen];
            }
        }];
    }
    [self.contactsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReuseId];
    self.contactsTableView.tableFooterView = [UIView new];
    self.contactsTableView.delegate = self;
    self.contactsTableView.dataSource = self;
    self.contactsTableView.rowHeight = 70;
}

- (void)fetchContacts {
    CNContactStore *contactStore = [CNContactStore new];
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactImageDataAvailableKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    [contactStore enumerateContactsWithFetchRequest:fetchRequest
                                              error:nil
                                         usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                                             [self.addressBook addContact:contact];
                                         }];
}

- (void)showAccessDeniedScreen {
    self.contactsTableView.hidden = YES;
    self.view.backgroundColor = [UIColor colorFromHex:0xF9F9F9];
    UILabel *accessDeniedLabel = [UILabel new];
    UIFont *system17RegularFont = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    accessDeniedLabel.textColor = [UIColor colorFromHex:0x000000];
    accessDeniedLabel.font = system17RegularFont;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CNContact *contact = [self.addressBook contactAtIndexPath:indexPath];
    NSMutableString *contactDetails = [NSMutableString stringWithString:@"Контакт"];
    if (contact.givenName.length != 0) {
        [contactDetails appendString:[NSString stringWithFormat:@" %@", contact.givenName]];
    }
    if (contact.familyName.length != 0) {
        [contactDetails appendString:[NSString stringWithFormat:@" %@", contact.familyName]];
    }
    if (contact.phoneNumbers.count != 0) {
        [contactDetails appendString:[NSString stringWithFormat:@", номер телефона %@", contact.phoneNumbers.firstObject.value.stringValue]];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:contactDetails preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.addressBook removeContactAtIndexPath:indexPath];
    [self.contactsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.addressBook numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.addressBook numberOfContactsInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.addressBook letterForSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId forIndexPath:indexPath];
    CNContact *contact = [self.addressBook contactAtIndexPath:indexPath];
    NSMutableString *fullName = [NSMutableString string];
    if (contact.familyName.length != 0) {
        [fullName appendString:[NSString stringWithFormat:@"%@ ", contact.familyName]];
    }
    if (contact.givenName.length != 0) {
        [fullName appendString:[NSString stringWithFormat:@"%@", contact.givenName]];
    }
    cell.textLabel.text = fullName;
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info"]];
    UIView *selectedColorBackgroundView = [UIView new];
    selectedColorBackgroundView.backgroundColor = [UIColor colorFromHex:0xFEF6E6];
    cell.selectedBackgroundView = selectedColorBackgroundView;
    cell.backgroundColor = [UIColor colorFromHex:0xFFFFFF];
    UIFont *system17RegularFont = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    cell.textLabel.font = system17RegularFont;
    cell.textLabel.textColor = [UIColor colorFromHex:0x000000];
    return cell;
}

@end
