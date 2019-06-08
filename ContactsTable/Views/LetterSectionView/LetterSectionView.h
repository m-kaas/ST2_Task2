//
//  LetterSectionView.h
//  ContactsTable
//
//  Created by Liubou Sakalouskaya on 6/8/19.
//  Copyright © 2019 Liubou Sakalouskaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LetterSectionView;

@protocol LetterSectionViewDelegate <NSObject>

- (void)didTapOnHeader:(LetterSectionView *)sectionView;

@end


@interface LetterSectionView : UITableViewHeaderFooterView

@property (assign, nonatomic, getter=isExpanded) BOOL expanded;
@property (weak, nonatomic) IBOutlet UILabel *letterLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactsCountLabel;
@property (assign, nonatomic) NSInteger section;
@property (weak, nonatomic) id<LetterSectionViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
