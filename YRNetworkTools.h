//
//  YRNetworkTools.h
//  NTreat
//
//  Created by Naton on 2019/3/13.
//  Copyright © 2019 Áî∞ÊôìÈπè. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^YRSuccess)(id _Nullable data, id __nullable info);
typedef void(^YRFailure)(NSError * _Nullable error, id __nullable info);

@interface YRNetworkTools : NSObject
+ (instancetype _Nullable ) shared;
+ (void)getURL:(NSString *_Nonnull)url WithPamars:(id _Nullable)Pamars success:(void(^_Nullable)(id _Nullable resp)) success exception:(void(^_Nonnull)(id _Nullable resp)) exception;
+ (void)getURL:(NSString *_Nonnull)url WithPamars:(id _Nullable)Pamars success:(YRSuccess _Nullable )success failure:(YRFailure _Nullable)failure;
+ (void)postURL:(NSString *_Nonnull)url WithPamars:(id _Nullable)Pamars success:(YRSuccess _Nullable )success failure:(YRFailure _Nullable)failure;
+ (void)netWorkDataBuryingPointWith:(NSDictionary *_Nullable)pamar;
@end
