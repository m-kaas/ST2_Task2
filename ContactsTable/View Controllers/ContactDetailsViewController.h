//
//  ContactDetailsViewController.h
//  ContactsTable
//
//  Created by Liubou Sakalouskaya on 6/9/19.
//  Copyright © 2019 Liubou Sakalouskaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactDetailsViewController : UIViewController

@property (strong, nonatomic) CNContact *contact;

@end

NS_ASSUME_NONNULL_END
