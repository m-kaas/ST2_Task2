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

@end

@implementation AddressBook

- (NSInteger)numberOfSections {
    return self.contactsByLetter.count;
}

- (NSInteger)numberOfContactsInSection:(NSInteger)section {
    NSArray *sortedLetters = [self.contactsByLetter.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *sectionKey = sortedLetters[section];
    NSInteger numberOfContacts = [(NSArray *)self.contactsByLetter[sectionKey] count];
    return numberOfContacts;
}

- (void)addContact:(CNContact *)contact {
    if (!self.contactsByLetter) {
        self.contactsByLetter = [NSMutableDictionary dictionary];
    }
    NSArray *sortedLetters = [self.contactsByLetter.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *stringToCompare = contact.familyName.length != 0 ? contact.familyName : contact.givenName;
    NSString *sectionKey = [[stringToCompare substringToIndex:1] lowercaseString];
    if (!sectionKey || ![@"abcdefghijklmnopqrstuvwxyzабвгдеёжзиклмнопрстуфхцчшщъыьэюя" containsString:sectionKey]) {
        sectionKey = @"#";
    }
    NSMutableArray *section;
    if (![sortedLetters containsObject:sectionKey]) {
        section = [NSMutableArray array];
        [section addObject:contact];
        [self.contactsByLetter addEntriesFromDictionary:@{sectionKey: section}];
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
    NSArray *sortedLetters = [self.contactsByLetter.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *sectionKey = sortedLetters[indexPath.section];
    NSMutableArray *section = self.contactsByLetter[sectionKey];
    [section removeObjectAtIndex:indexPath.row];
    if (section.count == 0) {
        [self.contactsByLetter removeObjectForKey:sectionKey];
    }
}

- (CNContact *)contactAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sortedLetters = [self.contactsByLetter.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *sectionKey = sortedLetters[indexPath.section];
    NSArray *section = self.contactsByLetter[sectionKey];
    CNContact *contact = section[indexPath.row];
    return contact;
}

- (NSString *)letterForSection:(NSInteger)section {
    NSArray *sortedLetters = [self.contactsByLetter.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *letter = [sortedLetters[section] uppercaseString];
    return letter;
}

@end
