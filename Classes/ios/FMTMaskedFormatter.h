//
//  FMTMaskedFormatter.h
//  FruitMaskedTextfield
//
//  Created by Eduardo Costa on 25/04/14.
//  Copyright (c) 2014 Eduardo Mauricio da Costa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMTMaskedFormatter : NSFormatter
@property (nonatomic, readonly) NSString * mask;

+ (instancetype)formatterWithMask:(NSString *)mask;
- (instancetype)initWithMask:(NSString *)mask;

- (NSString *)objectValueForString:(NSString *)str;

@end
