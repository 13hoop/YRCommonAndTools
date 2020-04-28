//
//  YRNetworkTools.m
//  NTreat
//
//  Created by Naton on 2019/3/13.
//  Copyright © 2019 Áî∞ÊôìÈπè. All rights reserved.
//

#import "YRNetworkTools.h"
#import "AFNetworking.h"
#import "NTAFNetworkingManager.h"

@interface YRNetworkTools ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, assign) BOOL isOpenLog;

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *userid;

@end
@implementation YRNetworkTools
+ (instancetype) shared {
    static YRNetworkTools *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YRNetworkTools alloc] initInstance];
    });
    return instance;
}

- (instancetype)initInstance {
    self = [super init];
    if(self) {
        NSURL *baseUrl = [NSURL URLWithString:BASIC_URL];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
        
        AFHTTPRequestSerializer *reqSer = [[AFHTTPRequestSerializer alloc] init];
        [reqSer setStringEncoding:(NSUTF8StringEncoding)];
        [reqSer setTimeoutInterval:40.0];
        [manager setRequestSerializer: reqSer];
        
        AFHTTPResponseSerializer *rspoSer = [AFJSONResponseSerializer serializer];
        [rspoSer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil]];
        [manager setResponseSerializer:rspoSer];
        
        // 证书验证 -- 暂不开启
        AFSecurityPolicy *security = [AFSecurityPolicy defaultPolicy];
        security.allowInvalidCertificates = YES;
        security.validatesDomainName = NO;
        [manager setSecurityPolicy:security];
        
//#ifdef YRDEBUGTAG
        self.isOpenLog = YES;
//#else
//        self.isOpenLog = NO;
//#endif
        
        self.manager = manager;
    }
    return self;
}

+ (void)getURL:(NSString *_Nonnull)url WithPamars:(id _Nullable )Pamars success:(YRSuccess _Nullable )success failure:(YRFailure _Nullable)failure {
    [[YRNetworkTools shared] getURL:url WithPamars:Pamars success:success failure:failure];
}

+ (void)getURL:(NSString *_Nonnull)url WithPamars:(id _Nullable)Pamars success:(void(^_Nullable)(id _Nullable resp)) success exception:(void(^_Nonnull)(id _Nullable resp)) exception {
    [[YRNetworkTools shared] getURL:url WithPamars:Pamars success:success exception:exception];
}

+ (void)postURL:(NSString *_Nonnull)url WithPamars:(id _Nullable )Pamars success:(YRSuccess _Nullable )success failure:(YRFailure _Nullable)failure {
    [[YRNetworkTools shared] postURL:url WithPamars:Pamars success:success failure:failure];
}

+ (void)netWorkDataBuryingPointWith:(NSDictionary *)pamar {
    [NTAFNetworkingManager postBuryingPointWithParameter: [NSMutableDictionary dictionaryWithDictionary: pamar]];
}

- (void)getURL:(NSString *_Nonnull)url WithPamars:(id _Nullable)Pamars success:(void(^_Nullable)(id _Nullable resp)) success exception:(void(^_Nonnull)(id _Nullable resp)) exception {
    [self.manager.requestSerializer setValue:self.token forHTTPHeaderField:@"token"];
    [self.manager.requestSerializer setValue:self.userid forHTTPHeaderField:@""];

    NSMutableDictionary *headDict = [NSMutableDictionary dictionary];
    if(self.token) {
        [headDict setValue:self.token forKey:@"token"];
    }
    if(self.userid) {
        [headDict setValue:self.userid forKey:@"userid"];
    }

    __weak typeof(self) weakSelf = self;
    [self.manager GET:url parameters:Pamars headers:headDict.copy progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(weakSelf.isOpenLog) {
                NSLog(@" \n [req]-> %@%@ \n [Header]--> %@\n [Pamars]->> %@\n [resp]-- >> %@", weakSelf.manager.baseURL, url, headDict.debugDescription,Pamars, responseObject);
            }
            if(success) {
                success(responseObject);
            }
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(exception) {
                success(error);
            }
        });
    }];
}

- (void)getURL:(NSString *)url WithPamars:(id)Pamars success:(YRSuccess)success failure:(YRFailure)failure {
    
    NSMutableDictionary *headDict = [NSMutableDictionary dictionary];
    if(self.token) {
        [headDict setValue:self.token forKey:@"token"];
    }
    if(self.userid) {
        [headDict setValue:self.userid forKey:@"userid"];
    }
    __weak typeof(self) weakSelf = self;
    [self.manager GET:url parameters:Pamars headers:headDict.copy progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(weakSelf.isOpenLog) {
                NSLog(@" \n [req]-> %@%@ \n [Header]--> %@\n [Pamars]->> %@\n [resp]-- >> %@", weakSelf.manager.baseURL, url, headDict.debugDescription,Pamars, responseObject);
            }
            
            NSDictionary *respDict = (NSDictionary *)responseObject;
            id data = respDict[@"result_data"];
            if([respDict[@"code"] integerValue] == 1) {
                
                if(data) {
                    if(success) {
                        success(data, NULL);
                    }
                }else {
                    if(success) {
                        success(data, respDict);
                    }
                }
            }else if([respDict[@"code"] integerValue] == 2001) {
                if(success) {
                    success(data, respDict);
                }
            }else {
                if(failure) {
                    NSString *str = respDict[@"message"];
                    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:121 userInfo:@{NSLocalizedDescriptionKey:str}];
                    failure(error, respDict);
                }
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(failure) {
                failure(error, NULL);
            }
        });
    }];
}

- (void)postURL:(NSString *)url WithPamars:(id)Pamars success:(YRSuccess)success failure:(YRFailure)failure {
    NSMutableDictionary *headDict = [NSMutableDictionary dictionary];
    if(self.token) {
        [headDict setValue:self.token forKey:@"token"];
    }
    if(self.userid) {
        [headDict setValue:self.userid forKey:@"userid"];
    }

    __weak typeof(self) weakSelf = self;
    [self.manager POST:url parameters:Pamars headers:headDict.copy progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(weakSelf.isOpenLog) {
                NSLog(@" \n [req]-> %@%@ \n [Header]--> %@\n [Pamars]->> %@\n [resp]-- >> %@", weakSelf.manager.baseURL, url, headDict.debugDescription,Pamars, responseObject);
            }
            
            NSDictionary *respDict = (NSDictionary *)responseObject;
            id data = respDict[@"result_data"];
            if([respDict[@"code"] integerValue] == 1) {
                if(data && ![data isKindOfClass:[NSNull class]]) {
                    if(success) {
                        success(data, nil);
                    }
                }else {
                    if(success) {
                        success(data, respDict);
                    }
                }
            }else {
                if(failure) {
                    NSString *str = respDict[@"message"];
                    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:121 userInfo:@{NSLocalizedDescriptionKey: str?:@"返回数据格式有误"}];
                    failure(error, respDict);
                }
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(failure) {
                failure(error, NULL);
            }
        });
    }];
}

- (NSString *)token {
    AuthManager *am = [[AuthManager alloc] init];
    _token = am.accessToken.token;
    return _token;
}

- (NSString *)userid {
    AuthManager *am = [[AuthManager alloc] init];
    _userid = am.accessToken.userId;
    return _userid;
}
@end
