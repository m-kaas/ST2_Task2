//
//  ContactTableViewCell.m
//  ContactsTable
//
//  Created by Liubou Sakalouskaya on 6/9/19.
//  Copyright © 2019 Liubou Sakalouskaya. All rights reserved.
//

#import "ContactTableViewCell.h"
#import "UIColor+ColorFromHex.h"

@interface ContactTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *infoImageView;

@end

@implementation ContactTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIView *selectedColorBackgroundView = [UIView new];
    selectedColorBackgroundView.backgroundColor = [UIColor colorFromHex:0xFEF6E6];
    self.selectedBackgroundView = selectedColorBackgroundView;
    self.infoImageView.image = [UIImage imageNamed:@"info"];
}

@end
