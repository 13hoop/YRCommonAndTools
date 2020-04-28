//
//  UIButton+YRButton.h
//  SDBoneRecovery
//
//  Created by Naton on 2018/8/6.
//  Copyright © 2018年 13hoop. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionBlock)();
@interface UIButton (YRButton)

@property (readonly) NSMutableDictionary *event;
- (void) handleControlEvent:(UIControlEvents)controlEvent withBlock:(ActionBlock)action;

@end
