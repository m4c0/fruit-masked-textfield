//
//  FMTMaskedFormatter.m
//  FruitMaskedTextfield
//
//  Created by Eduardo Costa on 25/04/14.
//  Copyright (c) 2014 Eduardo Mauricio da Costa. All rights reserved.
//

#import "FMTMaskedFormatter.h"

@implementation FMTMaskedFormatter {
    NSString * mask;
    NSString * maskSymbols;
}

@synthesize mask;

+ (instancetype)formatterWithMask:(NSString *)mask {
    return [[self alloc] initWithMask:mask];
}
- (instancetype)initWithMask:(NSString *)m {
    self = [super init];
    if (self) {
        self->mask = m;
        self->maskSymbols = [m stringByReplacingOccurrencesOfString:@"" withString:@""];
    }
    return self;
}

- (NSString *)stringForObjectValue:(id)obj {
    NSString * str = [obj description];
    if (!str.length) return @"";
    
    NSMutableString * res = [NSMutableString new];
    __block NSRange rng = NSMakeRange(0, 1);
    [mask enumerateSubstringsInRange:NSMakeRange(0, [mask length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              if ([substring isEqualToString:@""]) {
                                  [res appendString:[str substringWithRange:rng]];
                                  rng.location++;
                                  if (rng.location >= [str length]) {
                                      *stop = YES;
                                  }
                              } else {
                                  [res appendString:substring];
                              }
                          }];
    return [res copy];
}

- (BOOL)getObjectValue:(out __autoreleasing id *)obj forString:(NSString *)str errorDescription:(out NSString *__autoreleasing *)error {
    __block NSString * res = str;
    [maskSymbols enumerateSubstringsInRange:NSMakeRange(0, [maskSymbols length])
                                    options:NSStringEnumerationByComposedCharacterSequences
                                 usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                     res = [res stringByReplacingOccurrencesOfString:substring withString:@""];
                                 }];
    *obj = res;
    return YES;
}

- (NSString *)objectValueForString:(NSString *)str {
    NSString * res, * err;
    return [self getObjectValue:&res forString:str errorDescription:&err] ? res : nil;
}

@end
