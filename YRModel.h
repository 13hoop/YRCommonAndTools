//
//  YRModel.h
//  NTreat
//
//  Created by Naton on 2019/4/11.
//  Copyright © 2019 Áî∞ÊôìÈπè. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YRModel : NSObject
+ (instancetype) modelWithDict: (NSDictionary *) dict;
@end

@interface YRBannerModel : YRModel
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *logintype;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, strong) NSString *sequence;
@property (nonatomic, strong) NSString *inuse;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *gid;
@property (nonatomic, strong) NSString *url;
@end

NS_ASSUME_NONNULL_END
