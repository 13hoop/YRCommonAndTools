//
//  UIButton+YRButton.m
//  SDBoneRecovery
//
//  Created by Naton on 2018/8/6.
//  Copyright © 2018年 13hoop. All rights reserved.
//

#import "UIButton+YRButton.h"
#import <objc/runtime.h>


@implementation UIButton (YRButton)
static char overviewKey;
@dynamic event;
- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)block {
    objc_setAssociatedObject(self, &overviewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}


- (void)callActionBlock:(id)sender {
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &overviewKey);
    if (block) {
        block();
    }
}
@end
