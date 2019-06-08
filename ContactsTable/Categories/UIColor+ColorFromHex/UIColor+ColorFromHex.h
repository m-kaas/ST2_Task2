//
//  UIColor+ColorFromHex.h
//  ContactsTable
//
//  Created by Liubou Sakalouskaya on 6/8/19.
//  Copyright © 2019 Liubou Sakalouskaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (ColorFromHex)

+ (UIColor *)colorFromHex:(int)hexValue;

@end

NS_ASSUME_NONNULL_END
