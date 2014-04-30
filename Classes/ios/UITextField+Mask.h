//
//  UITextField+Mask.h
//  FruitMaskedTextfield
//
//  Created by Eduardo Costa on 25/04/14.
//  Copyright (c) 2014 Eduardo Mauricio da Costa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Mask)
@property (nonatomic, strong) NSString * mask;

- (NSString *)maskedText;
@end
