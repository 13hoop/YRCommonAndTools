//
//  YRModel.m
//  NTreat
//
//  Created by Naton on 2019/4/11.
//  Copyright © 2019 Áî∞ÊôìÈπè. All rights reserved.
//

#import "YRModel.h"

@implementation YRModel
+ (instancetype) modelWithDict: (NSDictionary *) dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype) initWithDict: (NSDictionary *) dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
#ifdef YRDEBUGTAG
    NSLog(@"⚠️ Model instancetype UndefinedKey is: %@", key);
#endif
}

- (void)setNilValueForKey:(NSString *)key {
#ifdef YRDEBUGTAG
    NSLog(@"⚠️ Model nil key: %@", key);
#endif
}
@end

@implementation YRBannerModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
#ifdef YRDEBUGTAG
    NSLog(@"⚠️ YRBannerModel instancetype UndefinedKey is: %@", key);
#endif
}

- (void)setNilValueForKey:(NSString *)key {
#ifdef YRDEBUGTAG
    NSLog(@"⚠️ YRBannerModel nil key: %@", key);
#endif
}
@end
