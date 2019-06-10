//
//  ContactTableViewCell.m
//  ContactsTable
//
//  Created by Liubou Sakalouskaya on 6/9/19.
//  Copyright © 2019 Liubou Sakalouskaya. All rights reserved.
//

#import "ContactTableViewCell.h"
#import "UIColor+ColorFromHex.h"

@implementation ContactTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *selectedColorBackgroundView = [UIView new];
        selectedColorBackgroundView.backgroundColor = [UIColor colorFromHex:0xFEF6E6];
        self.selectedBackgroundView = selectedColorBackgroundView;
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [infoButton setImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
        [infoButton addTarget:self action:@selector(onInfoButton:) forControlEvents:UIControlEventTouchUpInside];
        self.accessoryView = infoButton;
        self.accessoryView.hidden = YES;
    }
    return self;
}

- (void)setShowsInfoButton:(BOOL)showsInfoButton {
    if (_showsInfoButton != showsInfoButton) {
        _showsInfoButton = showsInfoButton;
    }
    self.accessoryView.hidden = !showsInfoButton;
}

- (void)onInfoButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didTapOnInfoButtonInCell:)]) {
        [self.delegate didTapOnInfoButtonInCell:self];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.showsInfoButton) {
        self.accessoryView.frame = CGRectMake(self.accessoryView.superview.bounds.size.width - 45, (self.accessoryView.superview.bounds.size.height - 25) / 2, 25, 25);
    }
    self.textLabel.frame = CGRectMake(25, self.textLabel.frame.origin.y, self.textLabel.frame.size.width - (self.showsInfoButton ? 25 : 0), self.textLabel.frame.size.height);
}

@end
