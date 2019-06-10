//
//  AddressBook.m
//  ContactsTable
//
//  Created by Liubou Sakalouskaya on 6/8/19.
//  Copyright © 2019 Liubou Sakalouskaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AddressBook.h"

@interface AddressBook ()

@property (strong, nonatomic) NSMutableDictionary *contactsByLetter;
@property (copy, nonatomic) NSArray *sortedKeyLetters;

@end

@implementation AddressBook

- (void)addContact:(CNContact *)contact {
    if (!self.contactsByLetter) {
        self.contactsByLetter = [NSMutableDictionary dictionary];
    }
    NSString *stringToCompare = contact.familyName.length != 0 ? contact.familyName : contact.givenName;
    NSString *sectionKey = [[stringToCompare substringToIndex:1] lowercaseString];
    NSString *letters = @"абвгдеёжзиклмнопрстуфхцчшщъыьэюяabcdefghijklmnopqrstuvwxyz";
    if (!sectionKey || [letters rangeOfString:sectionKey].location == NSNotFound) {
        sectionKey = @"#";
    }
    NSMutableArray *section;
    if (![self.contactsByLetter.allKeys containsObject:sectionKey]) {
        section = [NSMutableArray array];
        [section addObject:contact];
        [self.contactsByLetter addEntriesFromDictionary:@{sectionKey: section}];
        [self updateSortedKeyLetters];
        return;
    }
    section = self.contactsByLetter[sectionKey];
    __block NSInteger sortedIndex = 0;
    [section enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CNContact *aContact = (CNContact *)obj;
        NSString *contactString = aContact.familyName.length != 0 ? aContact.familyName : aContact.givenName;
        if ([contactString localizedCaseInsensitiveCompare:stringToCompare] == NSOrderedDescending) {
            sortedIndex = idx;
            *stop = YES;
        }
    }];
    [section insertObject:contact atIndex:sortedIndex];
}

- (void)removeContactAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionKey = self.sortedKeyLetters[indexPath.section];
    NSMutableArray *section = self.contactsByLetter[sectionKey];
    [section removeObjectAtIndex:indexPath.row];
    if (section.count == 0) {
        [self.contactsByLetter removeObjectForKey:sectionKey];
        [self updateSortedKeyLetters];
    }
}

- (NSInteger)numberOfSections {
    return self.contactsByLetter.count;
}

- (NSInteger)numberOfContactsInSection:(NSInteger)section {
    NSString *sectionKey = self.sortedKeyLetters[section];
    NSInteger numberOfContacts = [(NSArray *)self.contactsByLetter[sectionKey] count];
    return numberOfContacts;
}

- (CNContact *)contactAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionKey = self.sortedKeyLetters[indexPath.section];
    NSArray *section = self.contactsByLetter[sectionKey];
    CNContact *contact = section[indexPath.row];
    return contact;
}

- (NSString *)letterForSection:(NSInteger)section {
    return [self.sortedKeyLetters[section] uppercaseString];
}

- (void)updateSortedKeyLetters {
    NSString *letters = @"абвгдеёжзиклмнопрстуфхцчшщъыьэюяabcdefghijklmnopqrstuvwxyz#";
    NSArray *keyLetters = self.contactsByLetter.allKeys;
    NSArray *sortedKeyLetters = [keyLetters sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [letters rangeOfString:obj1].location > [letters rangeOfString:obj2].location;
    }];
    self.sortedKeyLetters = sortedKeyLetters;
}

@end
