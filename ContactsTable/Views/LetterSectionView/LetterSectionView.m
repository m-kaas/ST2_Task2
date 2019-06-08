//
//  LetterSectionView.m
//  ContactsTable
//
//  Created by Liubou Sakalouskaya on 6/8/19.
//  Copyright © 2019 Liubou Sakalouskaya. All rights reserved.
//

#import "LetterSectionView.h"
#import "UIColor+ColorFromHex.h"

@interface LetterSectionView ()

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

@implementation LetterSectionView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *sectionView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
        [self.contentView addSubview:sectionView];
        sectionView.frame = self.contentView.bounds;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [sectionView addGestureRecognizer:tap];
    }
    return self;
}

- (void)onTap:(UITapGestureRecognizer *)recognizer {
    if ([self.delegate respondsToSelector:@selector(didTapOnHeader:)]) {
        self.expanded = !self.expanded;
        [self.delegate didTapOnHeader:self];
    }
}

- (void)setExpanded:(BOOL)expanded {
    if (_expanded != expanded) {
        _expanded = expanded;
        if (expanded) {
            self.letterLabel.textColor = [UIColor colorFromHex:0x000000];
            self.contactsCountLabel.textColor = [UIColor colorFromHex:0x999999];
            self.arrowImageView.image = [UIImage imageNamed:@"arrow_down"];
        } else {
            self.letterLabel.textColor = [UIColor colorFromHex:0xD99100];
            self.contactsCountLabel.textColor = [UIColor colorFromHex:0xD99100];
            self.arrowImageView.image = [UIImage imageNamed:@"arrow_up"];
        }
    }
}

@end
