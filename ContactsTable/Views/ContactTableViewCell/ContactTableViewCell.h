//
//  ContactTableViewCell.h
//  ContactsTable
//
//  Created by Liubou Sakalouskaya on 6/9/19.
//  Copyright © 2019 Liubou Sakalouskaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ContactTableViewCell;

@protocol ContactTableViewCellDelegate <NSObject>

- (void)didTapOnInfoButtonInCell:(ContactTableViewCell *)cell;

@end

@interface ContactTableViewCell : UITableViewCell

@property (weak, nonatomic) id<ContactTableViewCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (assign, nonatomic) BOOL showsInfoButton;

@end

NS_ASSUME_NONNULL_END
