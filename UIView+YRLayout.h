//
//  UIView+YRLayout.h
//  NTreat
//
//  Created by Naton on 2019/4/15.
//  Copyright © 2019 Áî∞ÊôìÈπè. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (YRLayout)
@property (nonatomic, assign) CGFloat   x;
@property (nonatomic, assign) CGFloat   y;
@property (nonatomic, assign) CGFloat   width;
@property (nonatomic, assign) CGFloat   height;


@property (nonatomic, assign) CGPoint   origin;
@property (nonatomic, assign) CGSize    size;


@property (nonatomic, assign) CGFloat   top;
@property (nonatomic, assign) CGFloat   left;
@property (nonatomic, assign) CGFloat   bottom;
@property (nonatomic, assign) CGFloat   right;
@property (nonatomic, assign) CGFloat   centerX;
@property (nonatomic, assign) CGFloat   centerY;
@end

NS_ASSUME_NONNULL_END
