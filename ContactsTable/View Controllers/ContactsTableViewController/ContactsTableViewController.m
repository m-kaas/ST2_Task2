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
#import "LetterSectionView.h"
#import "ContactTableViewCell.h"
#import "ContactDetailsViewController.h"

NSString * const cellReuseId = @"cellReuseId";
NSString * const sectionHeaderReuseId = @"sectionHeaderReuseId";

@interface ContactsTableViewController () <UITableViewDelegate, UITableViewDataSource, LetterSectionViewDelegate, ContactTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *contactsTableView;
@property (strong, nonatomic) AddressBook *addressBook;
@property (strong, nonatomic) NSMutableArray *sectionsExpanded;

@end

@implementation ContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Контакты";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.addressBook = [AddressBook new];
    self.sectionsExpanded = [NSMutableArray array];
    [self setupContactsTableView];
    CNContactStore *store = [CNContactStore new];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            [self fetchContacts];
            dispatch_async(dispatch_get_main_queue(), ^{ [self.contactsTableView reloadData]; });
        } else {
            [self showAccessDeniedScreen];
        }
    }];
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
    for (int i = 0; i < self.addressBook.numberOfSections; i++) {
        [self.sectionsExpanded addObject:@YES];
    }
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

- (void)setupContactsTableView {
    [self.contactsTableView registerClass:[ContactTableViewCell class] forCellReuseIdentifier:cellReuseId];
    [self.contactsTableView registerClass:[LetterSectionView class] forHeaderFooterViewReuseIdentifier:sectionHeaderReuseId];
    self.contactsTableView.tableFooterView = [UIView new];
    self.contactsTableView.rowHeight = 70;
    self.contactsTableView.separatorColor = [UIColor colorFromHex:0xDFDFDF];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CNContact *contact = [self.addressBook contactAtIndexPath:indexPath];
    NSMutableString *contactDetails = [NSMutableString stringWithString:@"Контакт"];
    if (contact.familyName.length != 0) {
        [contactDetails appendString:[NSString stringWithFormat:@" %@", contact.familyName]];
    }
    if (contact.givenName.length != 0) {
        [contactDetails appendString:[NSString stringWithFormat:@" %@", contact.givenName]];
    }
    if (contact.phoneNumbers.count != 0) {
        [contactDetails appendString:[NSString stringWithFormat:@", номер телефона %@", contact.phoneNumbers.firstObject.value.stringValue]];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:contactDetails preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.addressBook removeContactAtIndexPath:indexPath];
        if ([self.contactsTableView numberOfRowsInSection:indexPath.section] == 1) {
            [self.sectionsExpanded removeObjectAtIndex:indexPath.section];
            NSIndexSet *sectionIndex = [NSIndexSet indexSetWithIndex:indexPath.section];
            [self.contactsTableView deleteSections:sectionIndex withRowAnimation:UITableViewRowAnimationTop];
        } else {
            [self.contactsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.contactsTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.addressBook numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sectionsExpanded[section] boolValue] ? [self.addressBook numberOfContactsInSection:section] : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LetterSectionView *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionHeaderReuseId];
    NSString *letter = [self.addressBook letterForSection:section];
    sectionView.letterLabel.text = letter;
    NSString *numberOfContacts = [NSString stringWithFormat:@"контактов: %ld", (long)[self.addressBook numberOfContactsInSection:section]];
    sectionView.contactsCountLabel.text = numberOfContacts;
    sectionView.expanded = [self.sectionsExpanded[section] boolValue];
    sectionView.section = section;
    sectionView.delegate = self;
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId forIndexPath:indexPath];
    CNContact *contact = [self.addressBook contactAtIndexPath:indexPath];
    NSMutableString *fullName = [NSMutableString string];
    if (contact.familyName.length != 0) {
        [fullName appendString:[NSString stringWithFormat:@"%@ ", contact.familyName]];
    }
    if (contact.givenName.length != 0) {
        [fullName appendString:[NSString stringWithFormat:@"%@", contact.givenName]];
    }
    cell.textLabel.text = fullName;
    cell.showsInfoButton = YES;
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

#pragma mark - LetterSectionViewDelegate

- (void)didTapOnHeader:(LetterSectionView *)sectionView {
    BOOL wasExpanded = [self.sectionsExpanded[sectionView.section] boolValue];
    self.sectionsExpanded[sectionView.section] = @(!wasExpanded);
    sectionView.expanded = !wasExpanded;
    if (wasExpanded) {
        NSMutableArray *indexPathsToDelete = [NSMutableArray array];
        for (int i = 0; i < [self.addressBook numberOfContactsInSection:sectionView.section]; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionView.section]];
        }
        [self.contactsTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    } else {
        NSMutableArray *indexPathsToInsert = [NSMutableArray array];
        for (int i = 0; i < [self.addressBook numberOfContactsInSection:sectionView.section]; i++) {
            [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionView.section]];
        }
        [self.contactsTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
}

#pragma mark - ContactTableViewCellDelegate

- (void)didTapOnInfoButtonInCell:(ContactTableViewCell *)cell {
    CNContact *contact = [self.addressBook contactAtIndexPath:cell.indexPath];
    ContactDetailsViewController *detailsVC = [ContactDetailsViewController new];
    detailsVC.contact = contact;
    [self.navigationController pushViewController:detailsVC animated:YES];
}

@end
