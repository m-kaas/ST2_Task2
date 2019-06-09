//
//  ContactDetailsHeaderView.m
//  ContactsTable
//
//  Created by Liubou Sakalouskaya on 6/9/19.
//  Copyright © 2019 Liubou Sakalouskaya. All rights reserved.
//

#import "ContactDetailsHeaderView.h"

@implementation ContactDetailsHeaderView

- (void)loadXibFile {
    UIView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    [self addSubview:headerView];
    headerView.frame = self.bounds;
    self.photoImageView.layer.cornerRadius = 75;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadXibFile];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self loadXibFile];
    }
    return self;
}

@end
