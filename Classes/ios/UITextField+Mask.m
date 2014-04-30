//
//  UITextField+Mask.m
//  FruitMaskedTextfield
//
//  Created by Eduardo Costa on 25/04/14.
//  Copyright (c) 2014 Eduardo Mauricio da Costa. All rights reserved.
//

#import "UITextField+Mask.h"

#import <objc/runtime.h>
#import "FMTMaskedFormatter.h"

static char UITextFieldMaskFormatter;

@interface UITextField (_Mask)
@property (nonatomic, strong) FMTMaskedFormatter * formatter;
@end

@implementation UITextField (_Mask)

- (FMTMaskedFormatter *)formatter {
    return objc_getAssociatedObject(self, &UITextFieldMaskFormatter);
}
- (void)setFormatter:(FMTMaskedFormatter *)formatter {
    objc_setAssociatedObject(self, &UITextFieldMaskFormatter, formatter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UITextField (Mask)

#pragma mark - Swizzling swizzles

+ (void)load {
    [self masklySwizzle:@selector(paste:) with:@selector(__maskPaste:)];
    [self masklySwizzle:@selector(deleteBackward) with:@selector(__maskDeleteBackward)];
    [self masklySwizzle:@selector(insertText:) with:@selector(__maskInsertText:)];
    [self masklySwizzle:@selector(text) with:@selector(__maskText)];
    [self masklySwizzle:@selector(setText:) with:@selector(__maskSetText:)];
}
+ (void)masklySwizzle:(SEL)as with:(SEL)ms {
    Method am = class_getInstanceMethod(self, as);
    Method mm = class_getInstanceMethod(self, ms);
    IMP a = method_getImplementation(am);
    IMP m = method_getImplementation(mm);
    method_setImplementation(am, m);
    method_setImplementation(mm, a);
}

#pragma mark - Public interface

- (NSString *)mask {
    return self.formatter.mask;
}
- (void)setMask:(NSString *)mask {
    if (!mask) {
        self.formatter = nil;
    } else {
        self.formatter = [FMTMaskedFormatter formatterWithMask:mask];
    }
}

- (NSString *)maskedText {
    return [self __maskText];
}

#pragma mark - Swizzled messages

- (NSString *)__maskText {
    if (self.formatter) {
        return [self.formatter objectValueForString:[self __maskText]];
    } else {
        return [self __maskText];
    }
}
- (void)__maskSetText:(NSString *)text {
    if (self.formatter) {
        [self __maskSetText:[self.formatter stringForObjectValue:text]];
    } else {
        [self __maskSetText:text];
    }
}

- (void)__maskInsertText:(NSString *)text {
    [self __maskInsertText:text];
    [self __insertMask];
}
- (void)__maskDeleteBackward {
    [self __maskDeleteBackward];
    [self __insertMask];
}
- (void)__maskPaste:(id)sender {
    [self __maskPaste:sender];
    [self __insertMask];
}

- (void)__insertMask {
    if (!self.formatter) {
        return;
    }
    NSString * str = [self __maskText];
    str = [self.formatter objectValueForString:str];
    [self __maskSetText:[self.formatter stringForObjectValue:str]];
}

@end
