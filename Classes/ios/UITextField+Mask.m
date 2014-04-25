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

+ (void)load {
    [self masklySwizzle:@selector(paste:) with:@selector(maskPaste:)];
    [self masklySwizzle:@selector(deleteBackward) with:@selector(maskDeleteBackward)];
    [self masklySwizzle:@selector(insertText:) with:@selector(maskInsertText:)];
}
+ (void)masklySwizzle:(SEL)as with:(SEL)ms {
    Method am = class_getInstanceMethod(self, as);
    Method mm = class_getInstanceMethod(self, ms);
    IMP a = method_getImplementation(am);
    IMP m = method_getImplementation(mm);
    method_setImplementation(am, m);
    method_setImplementation(mm, a);
}

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

- (void)maskInsertText:(NSString *)text {
    [self maskInsertText:text];
    [self insertMask];
}
- (void)maskDeleteBackward {
    [self maskDeleteBackward];
    [self insertMask];
}
- (void)maskPaste:(id)sender {
    [self maskPaste:sender];
    [self insertMask];
}

- (void)insertMask {
    if (!self.formatter) {
        return;
    }
    NSString * str = self.text;
    str = [self.formatter objectValueForString:str];
    self.text = [self.formatter stringForObjectValue:str];
}

@end
