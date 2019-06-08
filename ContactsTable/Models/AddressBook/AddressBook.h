//
//  AddressBook.h
//  ContactsTable
//
//  Created by Liubou Sakalouskaya on 6/8/19.
//  Copyright © 2019 Liubou Sakalouskaya. All rights reserved.
//

#ifndef AddressBook_h
#define AddressBook_h

#import <Contacts/Contacts.h>

@interface AddressBook : NSObject

- (NSInteger)numberOfSections;
- (NSInteger)numberOfContactsInSection:(NSInteger)section;
- (void)addContact:(CNContact *)contact;
- (CNContact *)contactAtIndexPath:(NSIndexPath *)indexPath;
- (void)removeContactAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)letterForSection:(NSInteger)section;

@end

#endif /* AddressBook_h */
