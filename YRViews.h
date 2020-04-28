//
//  YRViews.h
//  NTreat
//
//  Created by Naton on 2019/3/13.
//  Copyright © 2019 Áî∞ÊôìÈπè. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^BtnEventBlock)(id sender);
@interface YRViews : UIView
+ (UIImage *)convertToImage:(UIView *)view;
@end

/**
 自定义按钮，可控制图片文字间距
 使用方法：
 @code
    YRButton *button = [[YRButton alloc] initWithFrame:CGRectMake(50, 50, 50, 30)];
    button.imagePosition = SCCustomButtonImagePositionLeft;                         // 图文布局方式
    button.interTitleImageSpacing = 5;                                              // 图文间距
    button.imageCornerRadius = 15;                                                  // 图片圆角半径
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;  // 内容对齐方式
    [self addSubview:button];
 @endcode
 */
typedef NS_ENUM(NSInteger, YRCustomButtonImagePosition) {
    YRCustomButtonImagePositionTop,     // 图片在文字顶部
    YRCustomButtonImagePositionLeft,    // 图片在文字左侧
    YRCustomButtonImagePositionBottom,  // 图片在文字底部
    YRCustomButtonImagePositionRight    // 图片在文字右侧
};
@interface YRButton : UIButton
@property (assign, nonatomic) int tagIdx;
@property (assign, nonatomic) CGFloat interTitleImageSpacing;  // 图片文字间距
@property (assign, nonatomic) YRCustomButtonImagePosition imagePosition; // 图片和文字的相对位置
@property (assign, nonatomic) CGFloat imageCornerRadius;
@end


// MARK: --- GradientType / border Button
@interface YRGradientTypeButton : YRButton
@property (nonatomic, copy) BtnEventBlock block;
@property (nonatomic, assign) BOOL disableStyle;
+ (instancetype)buttonCreate;
+ (instancetype)buttonCreateWithBorder:(BOOL)isBorder;
+ (instancetype)buttonCreateWithFrame: (CGRect)frame;

@end


// MARK: -------- Customed InputView
typedef enum : NSUInteger {
    InputForDefault,
    InputForPassword,
    InputForCountdown,
} YRInputType;
typedef void (^RightViewEvent)(UIButton *sender, BOOL isValid);
@interface YRCustomInputView : UIView
@property (nonatomic, strong) NSString *holderStr;
@property (nonatomic, strong) UITextField *textFiled;
@property (nonatomic, copy) RightViewEvent rightViewCallBack;
- (instancetype)initWithType: (YRInputType)type;
@end

@interface YRTapGestureRecognizer : UITapGestureRecognizer
@property (nonatomic, assign) NSInteger identifierNum;
@end

@interface YRColoredImage : UIImage
+ (UIImage *)yr_imageWithColor:(UIColor *)color andSize:(CGSize)size;
+ (UIImage *)yr_imageWithColor:(UIColor *)color;
@end


@interface YRSegmentSwapView : UIView
@property (nonatomic, strong) UIColor *colorNormal;
@property (nonatomic, strong) UIColor *colorSelected;
@property (nonatomic, strong, readonly) NSArray *childControllerArr;
@property (nonatomic, copy) void (^tagClicked)(int idx, UIButton *sender);
- (void)configChildrenVCArr:(NSArray *)childControllerArr inParent:(UIViewController *)parentVC;
@end
NS_ASSUME_NONNULL_END
