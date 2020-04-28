//
//  YRViews.m
//  NTreat
//
//  Created by Naton on 2019/3/13.
//  Copyright © 2019 Áî∞ÊôìÈπè. All rights reserved.
//

#import "YRViews.h"
#import "UIButton+YRButton.h"
#import "UIView+YRLayout.h"

@implementation YRViews
+ (UIImage *)convertToImage:(UIView *)view {
    CGSize s = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end

@interface YRGradientTypeButton()
@property (nonatomic, strong)CAGradientLayer *gradientLayer;
@property (nonatomic, assign)BOOL isBordered;
@end
@implementation YRGradientTypeButton
+ (instancetype)buttonCreateWithBorder:(BOOL)isBorder {
    YRGradientTypeButton *btn = [[YRGradientTypeButton alloc] initWithBorder: isBorder];
    btn.translatesAutoresizingMaskIntoConstraints = YES;
    return btn;
}

+ (instancetype)buttonCreate {
    YRGradientTypeButton *btn = [[YRGradientTypeButton alloc] init];
    return btn;
}
+ (instancetype)buttonCreateWithFrame: (CGRect)frame {
    YRGradientTypeButton *btn = [[YRGradientTypeButton alloc] init];
    btn.translatesAutoresizingMaskIntoConstraints = YES;
    btn.frame = frame;
    return btn;
}

- (instancetype)initWithBorder:(BOOL)isBorder {
    self.isBordered = isBorder;
    return [self init];
}

- (instancetype)init {
    self = [super init];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    if(self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    if(self.isBordered) {
        UIColor *color = [UIColor colorWhthHexString:@"#1FB5D8"];
        [self.layer setBorderColor:[color CGColor]];
        [self.layer setBorderWidth:1.0f];
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:6];
        [self setTitleColor:color forState:(UIControlStateNormal)];
        [self setTitleColor:color forState:(UIControlStateHighlighted)];
    }else {
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.startPoint = CGPointMake(0.5, -0.14);
        gradientLayer.endPoint = CGPointMake(0.5, 1);
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:2/255.0 green:208/255.0 blue:190/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:59/255.0 green:158/255.0 blue:240/255.0 alpha:1.0].CGColor];
        gradientLayer.locations = @[@(0), @(1.0f)];
//        [self.layer insertSublayer:gradientLayer atIndex:0];
        [self.layer insertSublayer:gradientLayer below:self.imageView.layer];
        self.gradientLayer = gradientLayer;
        
        self.layer.cornerRadius = 6;
        self.layer.shadowColor = [UIColor colorWithRed:194/255.0 green:225/255.0 blue:251/255.0 alpha:1.0].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,5);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 10;
        self.layer.masksToBounds = YES;
    }
}

- (void)setBlock:(BtnEventBlock)block {
    if(block) {
        __block YRGradientTypeButton *btn = self;
        [self handleControlEvent:(UIControlEventTouchUpInside) withBlock:^{
            block(btn);
        }];
    }
    _block = block;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if(self.gradientLayer) {
        self.gradientLayer.frame = self.bounds;
    }
}

- (void)setDisableStyle:(BOOL)disableStyle {
    _disableStyle = disableStyle;
    self.userInteractionEnabled = !disableStyle;
    if(disableStyle) {
        self.backgroundColor = kGrayDisabled;
        if(self.gradientLayer) {
            [self.gradientLayer removeFromSuperlayer];
        }
    }else {
        if(self.gradientLayer) {
            [self.layer insertSublayer:self.gradientLayer atIndex:0];
        }

    }
}
@end

@interface YRButton ()
@end
@implementation YRButton
#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _interTitleImageSpacing = 4;
    _imagePosition = YRCustomButtonImagePositionLeft;
    _imageCornerRadius = 0;
}

#pragma mark - Setter
- (void)setImagePosition:(YRCustomButtonImagePosition)imagePosition {
    _imagePosition = imagePosition;
    [self setNeedsLayout];
}

- (void)setInterTitleImageSpacing:(CGFloat)interTitleImageSpacing {
    _interTitleImageSpacing = interTitleImageSpacing;
    [self setNeedsLayout];
}

- (void)setImageCornerRadius:(CGFloat)imageCornerRadius {
    _imageCornerRadius = imageCornerRadius;
    
    self.imageView.layer.cornerRadius = imageCornerRadius;
    self.imageView.layer.masksToBounds = YES;
}

#pragma mark - Layout subviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (CGRectIsEmpty(self.bounds)) {
        return;
    }
    
    [self p_resizeSubviews];
    if (self.imagePosition == YRCustomButtonImagePositionLeft) { // 图片在左侧：🏝+文字
        [self p_layoutSubViewsForImagePositionLeft];
    } else if (self.imagePosition == YRCustomButtonImagePositionRight) { // 图片在右侧：文字+🏔
        [self p_layoutSubViewsForImagePositionRight];
    } else if (self.imagePosition == YRCustomButtonImagePositionTop) { // 图片在顶部
        [self p_layoutSubViewsForImagePositionTop];
    } else if (self.imagePosition == YRCustomButtonImagePositionBottom) { // 图片在底部
        [self p_layoutSubViewsForImagePositionBottom];
    }
}

/// 计算尺寸
- (void)p_resizeSubviews {
    
    self.imageView.size = self.imageView.image.size;
    [self.titleLabel sizeToFit];
    
    if (self.imagePosition == YRCustomButtonImagePositionRight ||   // 图片在右侧：文字+🏔
        self.imagePosition == YRCustomButtonImagePositionLeft) {    // 图片在左侧：🏝+文字
        if (self.titleLabel.width > (self.width - self.interTitleImageSpacing - self.imageView.width)) {
            self.titleLabel.width = self.width;
        }
    } else if (self.imagePosition == YRCustomButtonImagePositionTop ||      // 图片在顶部
               self.imagePosition == YRCustomButtonImagePositionBottom) {   // 图片在底部
        if (self.titleLabel.width > self.width) {
            self.titleLabel.width = self.width;
        }
    }
}

/// 图片在左侧
- (void)p_layoutSubViewsForImagePositionLeft {
    if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight) {   // 整体靠右
        
        self.titleLabel.x = self.width - self.titleLabel.width;
        self.titleLabel.y = (self.height - self.titleLabel.height) * 0.5;
        
        self.imageView.x = self.width - self.titleLabel.width - self.interTitleImageSpacing - self.imageView.width;
        self.imageView.y = (self.height - self.imageView.height) * 0.5;
        
    } else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft) { // 整体靠左
        self.imageView.x = 0;
        self.imageView.y = (self.height - self.imageView.height) * 0.5;
        
        self.titleLabel.x = self.imageView.right + self.interTitleImageSpacing;
        self.titleLabel.y = (self.height - self.titleLabel.height) * 0.5;
        
    } else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentCenter) { // 整体居中
        self.imageView.x = self.width * 0.5 - (self.titleLabel.width + self.interTitleImageSpacing + self.imageView.width) * 0.5;
        self.imageView.y = (self.height - self.imageView.height) * 0.5;
        
        self.titleLabel.x = self.interTitleImageSpacing + self.imageView.right;
        self.titleLabel.y = (self.height - self.titleLabel.height) * 0.5;
    }
}

/// 图片在右侧
- (void)p_layoutSubViewsForImagePositionRight {
    if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight) {   // 整体靠右
        
        self.imageView.x = self.width - self.imageView.width;
        self.imageView.y = (self.height - self.imageView.height) * 0.5;
        
        self.titleLabel.x = self.width - self.imageView.width - self.interTitleImageSpacing - self.titleLabel.width;
        self.titleLabel.y = (self.height - self.titleLabel.height) * 0.5;
        
    } else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft) { // 整体靠左
        self.titleLabel.x = 0;
        self.titleLabel.y = (self.height - self.titleLabel.height) * 0.5;
        
        self.imageView.x = self.interTitleImageSpacing + self.titleLabel.width;
        self.imageView.y = (self.height - self.imageView.height) * 0.5;
        
    } else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentCenter) { // 整体居中
        self.titleLabel.x = self.width * 0.5 - (self.titleLabel.width + self.interTitleImageSpacing + self.imageView.width) * 0.5;
        self.titleLabel.y = (self.height - self.titleLabel.height) * 0.5;
        
        self.imageView.x = self.titleLabel.x + self.titleLabel.width + self.interTitleImageSpacing;
        self.imageView.y = (self.height - self.imageView.height) * 0.5;
    }
}

/// 图片在顶部
- (void)p_layoutSubViewsForImagePositionTop {
    if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentTop) {  // 整体靠顶部
        
        self.imageView.y = 0;
        self.imageView.centerX = self.width * 0.5;
        
        self.titleLabel.y = self.imageView.bottom + self.interTitleImageSpacing;
        self.titleLabel.centerX = self.width * 0.5;
        
    } else if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentBottom) { // 整体靠底部
        
        self.titleLabel.y = self.height - self.titleLabel.height;
        self.titleLabel.centerX = self.width * 0.5;
        
        self.imageView.y = self.height - (self.imageView.height + self.titleLabel.height + self.interTitleImageSpacing);
        self.imageView.centerX = self.width * 0.5;
        
    } else if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentCenter) { // 整体居中
        self.imageView.y = self.height * 0.5 - (self.imageView.height + self.titleLabel.height + self.interTitleImageSpacing) * 0.5;
        self.imageView.centerX = self.width * 0.5;
        
        self.titleLabel.y = self.imageView.bottom + self.interTitleImageSpacing;
        self.titleLabel.centerX = self.width * 0.5;
    }
}

/// 图片在底部
- (void)p_layoutSubViewsForImagePositionBottom {
    if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentTop) {  // 整体靠顶部
        
        self.titleLabel.y = 0;
        self.titleLabel.centerX = self.width * 0.5;
        
        self.imageView.y = self.titleLabel.bottom + self.interTitleImageSpacing;
        self.imageView.centerX = self.width * 0.5;
        
    } else if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentBottom) { // 整体靠底部
        
        self.imageView.y = self.height - self.imageView.height;
        self.imageView.centerX = self.width * 0.5;
        
        self.titleLabel.y = self.height - (self.titleLabel.height + self.interTitleImageSpacing + self.imageView.height);
        self.titleLabel.centerX = self.width * 0.5;
        
    } else if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentCenter) { // 整体居中
        
        self.titleLabel.y = self.height * 0.5 - (self.imageView.height + self.titleLabel.height + self.interTitleImageSpacing) * 0.5;
        self.titleLabel.centerX = self.width * 0.5;
        
        self.imageView.y = self.titleLabel.bottom + self.interTitleImageSpacing;
        self.imageView.centerX = self.width * 0.5;
        
    }
}

@end


@interface YRCustomInputView ()
@property (nonatomic, strong) UIButton *countBtn;
@property (nonatomic, assign) NSInteger countNum;
@property (nonatomic, assign) YRInputType type;
@end
@implementation YRCustomInputView
- (instancetype)initWithType: (YRInputType)type {
    YRCustomInputView *instance = [self init];
    self.type = type;
    [self layout];
    return instance;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        [self setUpViews];
        self.countNum = 10;
    }
    return self;
}

- (void)layout {
    
    if (self.type == InputForCountdown) {
        self.textFiled.rightViewMode = UITextFieldViewModeAlways;
        UIView *view = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 100, 50))];
        self.countBtn.frame = view.frame;
        [view addSubview:self.countBtn];
        [self.countBtn addTarget:self action:@selector(textFiledRightBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        self.textFiled.rightView = view;
    }else {
        BOOL isPwd = self.type == InputForPassword;
        self.textFiled.secureTextEntry = isPwd;
        self.textFiled.rightViewMode = UITextFieldViewModeAlways;
    }
    [self addDoneButtonOnKeyboardIn:self.textFiled];
}

- (void)setUpViews {
    
    UIView *bgView = [[UIView alloc] init];
    bgView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview: bgView];
    [bgView.topAnchor constraintEqualToAnchor:self.topAnchor constant:0].active = YES;
    [bgView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:0].active = YES;
    [bgView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0].active = YES;
    [bgView.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:0].active = YES;
    [self layoutIfNeeded];
    
    UITextField *textFiled = [[UITextField alloc] init];
    textFiled.translatesAutoresizingMaskIntoConstraints = NO;
    textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [bgView addSubview:textFiled];
    self.textFiled = textFiled;
    
    [self.textFiled.topAnchor constraintEqualToAnchor:bgView.topAnchor constant:0].active = YES;
    [self.textFiled.leftAnchor constraintEqualToAnchor:bgView.leftAnchor constant:16].active = YES;
    [self.textFiled.bottomAnchor constraintEqualToAnchor:bgView.bottomAnchor constant:0].active = YES;
    [self.textFiled.rightAnchor constraintEqualToAnchor:bgView.rightAnchor constant:0].active = YES;
}

// NumPad add done btn
- (void) addDoneButtonOnKeyboardIn: (UITextField *)textFiled {
    
    UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    doneToolbar.barStyle = UIBarStyleDefault;
    
    // iOS 11 上，UIBarButtonItem width 被废弃
    //    UIBarButtonItem *cancleItemBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStyleDone) target:self action:@selector(keybordDoneBtnClicked)];
    //    UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    fixedItem.width = doneToolbar.bounds.size.width - 2 * 120;
    UIBarButtonItem *doneItemBtn = [[UIBarButtonItem alloc] initWithTitle:@"收起" style:(UIBarButtonItemStyleDone) target:self action:@selector(keybordDoneBtnClicked)];
    //    doneToolbar.items = @[ cancleItemBtn, fixedItem, doneItemBtn];
    doneToolbar.items = @[doneItemBtn];
    [doneToolbar sizeToFit];
    
    textFiled.inputAccessoryView = doneToolbar;
}

- (void)keybordDoneBtnClicked {
    [self.textFiled resignFirstResponder];
}

- (void)textFiledRightBtnClicked: (id) sender {
    __weak typeof(self) weakSelf = self;
    if([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        BOOL isValid = [self validatPhoneNum: self.textFiled.text];
        if(isValid == YES) {
            self.countNum = 60;
            [[NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
                NSString *str;
                weakSelf.countNum = weakSelf.countNum - 1;
                if(weakSelf.countNum > 0) {
                    btn.userInteractionEnabled = NO;
                    str = [NSString stringWithFormat:@"%ld s", (long)self.countNum];
                    btn.backgroundColor = [UIColor grayColor];
                }else {
                    str = @"获取验证码";
                    btn.userInteractionEnabled = YES;
                    btn.backgroundColor = kOrangeColor;
                    [timer invalidate];
                }
                [btn setTitle:str forState:(UIControlStateNormal)];
                [btn setTitle:str forState:(UIControlStateHighlighted)];
            }] fire];
        }else {
            
        }
        
        if(self.rightViewCallBack) {
            self.rightViewCallBack(btn, isValid);
        }
    }
}

- (BOOL)validatPhoneNum: (NSString *)str {
    NSString * MOBILE = @"^[1][3456789]\\d{9}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject: str];
}

- (UIButton *)countBtn {
    if(_countBtn == nil) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        [btn setTitle:@"获取验证码" forState:(UIControlStateHighlighted)];
        [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateHighlighted)];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        btn.backgroundColor = kOrangeColor;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        _countBtn = btn;
    }
    return _countBtn;
}

- (void)setHolderStr:(NSString *)holderStr {
    _holderStr = holderStr;
    self.textFiled.placeholder = holderStr;
}
@end

@implementation YRTapGestureRecognizer
@end



@implementation YRColoredImage
+ (UIImage *)yr_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *imgae = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imgae;
}


+ (UIImage *)yr_imageWithColor:(UIColor *)color andSize:(CGSize)size {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGContextAddEllipseInRect(context, rect);
    UIGraphicsEndImageContext();
    return image;
}
@end

// MARK:   -------- -------- YRSegmentSwapView --------------
@interface YRSegmentSwapView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *tagScrollView;
@property (nonatomic, strong) UIView *decorationView;
@property (nonatomic, strong) UIView *topBgView;
@property (nonatomic, strong) NSArray *btnArr;
@property (nonatomic, strong) NSArray *tagArr;

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIView *contentBgView;
@property (nonatomic, strong) NSArray *viewArr;

@property (nonatomic, assign) NSInteger lastSelectIdx;

@property (nonatomic, assign) CGFloat tagItemWidth;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGPoint lastContentOffset;

@property (nonatomic, strong) NSArray *childControllerArr;

@end
@implementation YRSegmentSwapView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self setupTagViews];
    [self setupContentViews];
}

- (void)setupContentViews {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:scrollView];
    UIView *scrollSubView = [[UIView alloc] init];
    scrollSubView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [scrollView addSubview:scrollSubView];
    self.contentScrollView = scrollView;
    self.contentScrollView.bounces = NO;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.delegate = self;
    
    [scrollView.topAnchor constraintEqualToAnchor:self.tagScrollView.bottomAnchor constant:2].active = YES;
    [scrollView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:0].active = YES;
    [scrollView.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:0].active = YES;
    [scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0].active = YES;
    [scrollSubView.topAnchor constraintEqualToAnchor:scrollView.topAnchor constant:0].active = YES;
    [scrollSubView.leftAnchor constraintEqualToAnchor:scrollView.leftAnchor constant:0].active = YES;
    [scrollSubView.rightAnchor constraintEqualToAnchor:scrollView.rightAnchor constant:0].active = YES;
    [scrollSubView.bottomAnchor constraintEqualToAnchor:scrollView.bottomAnchor constant:0].active = YES;
    [scrollSubView.centerYAnchor constraintEqualToAnchor:scrollView.centerYAnchor constant:0].active = YES;
}

- (void)setupTagViews {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:scrollView];
    UIView *scrollSubView = [[UIView alloc] init];
    scrollSubView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [scrollView addSubview:scrollSubView];
    self.tagScrollView = scrollView;
    
    [scrollView.topAnchor constraintEqualToAnchor:self.topAnchor constant:0].active = YES;
    [scrollView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:0].active = YES;
    [scrollView.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:0].active = YES;
    [scrollView.heightAnchor constraintEqualToConstant:44.0].active = YES;
    [scrollSubView.topAnchor constraintEqualToAnchor:scrollView.topAnchor constant:0].active = YES;
    [scrollSubView.leftAnchor constraintEqualToAnchor:scrollView.leftAnchor constant:0].active = YES;
    [scrollSubView.rightAnchor constraintEqualToAnchor:scrollView.rightAnchor constant:0].active = YES;
    [scrollSubView.bottomAnchor constraintEqualToAnchor:scrollView.bottomAnchor constant:0].active = YES;
    [scrollSubView.centerYAnchor constraintEqualToAnchor:scrollView.centerYAnchor constant:0].active = YES;
}

// MARK: -------- configChildrenVCArr
- (void)configChildrenVCArr:(NSArray *)childControllerArr inParent:(UIViewController *)parentVC{
    self.childControllerArr = childControllerArr;
    NSInteger sum = childControllerArr.count;
    self.childControllerArr = childControllerArr;
    if(sum > 0) {
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:sum];
        NSMutableArray *tempV = [NSMutableArray arrayWithCapacity:sum];

        CGFloat width = 100;
        if(sum <= 4) {
            width = CGRectGetWidth(self.bounds) / sum;
        }
        CGFloat viewWidth = CGRectGetWidth(self.contentScrollView.frame);
        self.tagItemWidth = width;
        self.viewWidth = viewWidth;
        
        __block YRButton *lastBtn;
        __block UIView *lastView;
        [childControllerArr enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YRButton *btn = [[YRButton alloc] init];
            btn.translatesAutoresizingMaskIntoConstraints = NO;
            btn.tagIdx = (int)idx;
            [btn setTitle:obj.title forState:(UIControlStateNormal)];
            [btn setTitle:obj.title forState:(UIControlStateHighlighted)];
            [btn setTitle:obj.title forState:(UIControlStateSelected)];
            [btn setTitleColor:self.colorNormal forState:(UIControlStateNormal)];
            [btn setTitleColor:self.colorSelected forState:(UIControlStateHighlighted)];
            [btn setTitleColor:self.colorSelected forState:(UIControlStateSelected)];
            [btn addTarget:self action:@selector(tagBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.topBgView addSubview:btn];
            [temp addObject:btn];
            
            [btn.topAnchor constraintEqualToAnchor:self.topBgView.topAnchor constant:0].active = YES;
            [btn.bottomAnchor constraintEqualToAnchor:self.topBgView.bottomAnchor constant:0].active = YES;

            UIView *view = [[UIView alloc] init];
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentBgView addSubview:view];
            [view.topAnchor constraintEqualToAnchor:self.contentBgView.topAnchor constant:0].active = YES;
            [view.bottomAnchor constraintEqualToAnchor:self.contentBgView.bottomAnchor constant:0].active = YES;
            [tempV addObject:view];
                        
            if(idx == 0) {
                self.lastSelectIdx = 0;
                btn.selected = YES;
                [btn.leftAnchor constraintEqualToAnchor:self.topBgView.leftAnchor constant:0].active = YES;
                lastBtn = btn;
                
                [view.leftAnchor constraintEqualToAnchor:self.contentBgView.leftAnchor constant:0].active = YES;
                lastView = view;
                
                [self.topBgView addSubview:self.decorationView];
                [self.decorationView.bottomAnchor constraintEqualToAnchor:self.topBgView.bottomAnchor constant:0].active = YES;
                [self.decorationView.centerXAnchor constraintEqualToAnchor:btn.centerXAnchor constant:0].active = YES;
                [self.decorationView.widthAnchor constraintEqualToConstant:40].active = YES;
                [self.decorationView.heightAnchor constraintEqualToConstant:2].active = YES;
                self.decorationView.backgroundColor = self.colorSelected;
            }else {
                [btn.leftAnchor constraintEqualToAnchor:lastBtn.rightAnchor constant:0].active = YES;
                lastBtn = btn;
                
                [view.leftAnchor constraintEqualToAnchor:lastView.rightAnchor constant:0].active = YES;
                lastView = view;
            }
            
            if (idx == sum - 1) {
                [btn.rightAnchor constraintEqualToAnchor:self.topBgView.rightAnchor constant:0].active = YES;
                [view.rightAnchor constraintEqualToAnchor:self.contentBgView.rightAnchor constant:0].active = YES;
            }
            [btn.widthAnchor constraintEqualToConstant:width].active = YES;
            [view.widthAnchor constraintEqualToConstant:viewWidth].active = YES;
        }];
        [self.topBgView bringSubviewToFront:self.decorationView];
        self.btnArr = temp.copy;
        self.viewArr = tempV.copy;
        [self layoutIfNeeded];

        [childControllerArr enumerateObjectsUsingBlock:^(UIViewController *childeVC, NSUInteger idx, BOOL * _Nonnull stop) {
            UIView *baseView = self.viewArr[idx];
            [parentVC addChildViewController:childeVC];
            childeVC.view.frame = baseView.bounds;
            [baseView addSubview: childeVC.view];
            [childeVC didMoveToParentViewController:parentVC];
        }];
    }
}

- (void)tagBtnClicked: (id)sender {
    YRButton *btn = (YRButton *)sender;
    [self changeTagBtnStatus:btn];
    
    CGPoint offset = self.contentScrollView.contentOffset;
    offset.x = self.viewWidth * btn.tagIdx;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentScrollView.contentOffset = offset;
    }];

    if(self.tagClicked) {
        self.tagClicked(btn.tagIdx, btn);
    }
}

- (void)changeTagBtnStatus: (YRButton *)btn {
    btn.selected = YES;
    int idx = btn.tagIdx;
    if(self.lastSelectIdx != idx) {
        btn.selected = YES;
        YRButton *lastBtn = self.btnArr[self.lastSelectIdx];
        lastBtn.selected = NO;
        
        CGRect frame = btn.frame;
        CGFloat scale = self.lastSelectIdx >= idx ? -1 : 1;
        CGFloat margin =  frame.size.width / 3;
        frame = CGRectMake(frame.origin.x + margin * scale, frame.origin.y, frame.size.width, frame.size.height);
        [self.tagScrollView scrollRectToVisible:frame animated:YES];
        
        self.lastSelectIdx = btn.tagIdx;
    }
}

// MARK:  -------- ----- ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView == self.contentScrollView) {
        CGFloat offX = scrollView.contentOffset.x;
        CGFloat addX = offX / self.viewWidth * self.tagItemWidth;
        
        CGFloat pageWidth = self.viewWidth;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        //    NSLog(@" [%d]-- > addX %0.2f : offX %0.2f <%d>", page, addX, offX, self.lastSelectIdx);
        
        if(self.lastSelectIdx != page) {
            [self changeTagBtnStatus:self.btnArr[page]];
        }
        self.decorationView.center = CGPointMake(self.tagItemWidth / 2 + addX, self.decorationView.center.y);
    }
}

// MARK: ------- ------------- getter && setter
- (UIView *)topBgView {
    if(_topBgView == nil) {
        UIView *view = [[UIView alloc] init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.tagScrollView addSubview:view];
        [view.topAnchor constraintEqualToAnchor:self.tagScrollView.topAnchor constant:0].active = YES;
        [view.bottomAnchor constraintEqualToAnchor:self.tagScrollView.bottomAnchor constant:0].active = YES;
        [view.leftAnchor constraintEqualToAnchor:self.tagScrollView.leftAnchor constant:0].active = YES;
        [view.rightAnchor constraintEqualToAnchor:self.tagScrollView.rightAnchor constant:0].active = YES;
        [view.widthAnchor constraintGreaterThanOrEqualToAnchor:self.tagScrollView.widthAnchor constant:0].active = YES;
        _topBgView = view;
    }
    return _topBgView;
}

- (UIView *)contentBgView {
    if(_contentBgView == nil) {
        UIView *view = [[UIView alloc] init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentScrollView addSubview:view];
        [view.topAnchor constraintEqualToAnchor:self.contentScrollView.topAnchor constant:0].active = YES;
        [view.bottomAnchor constraintEqualToAnchor:self.contentScrollView.bottomAnchor constant:0].active = YES;
        [view.leftAnchor constraintEqualToAnchor:self.contentScrollView.leftAnchor constant:0].active = YES;
        [view.rightAnchor constraintEqualToAnchor:self.contentScrollView.rightAnchor constant:0].active = YES;
        [view.widthAnchor constraintGreaterThanOrEqualToAnchor:self.contentScrollView.widthAnchor constant:0].active = YES;
        _contentBgView = view;
    }
    return _contentBgView;
}

- (UIColor *)colorNormal {
    if (_colorNormal == nil) {
        _colorNormal = [UIColor colorWhthHexString:@"#B0B0B0"];
        _colorSelected = [UIColor colorWhthHexString:@"#1FB5D8"];
    }
    return _colorNormal;
}

- (UIView *)decorationView {
    if(_decorationView == nil) {
        UIView *view = [[UIView alloc] init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        _decorationView = view;
    }
    return _decorationView;
}
@end
