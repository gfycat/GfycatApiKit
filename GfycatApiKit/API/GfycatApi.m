//
//  GfycatApi.m
//  GfycatApiKit
//
//  Created by Yin Zhu on 1/23/17.
//  Copyright 2017 Gfycat
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "GfycatApi.h"
#import "GfycatMedia.h"
#import "GfycatExtendedMedia.h"
#import "GfycatCategory.h"
#import "GfycatCollection.h"
#import "GfycatPaginationInfo.h"
#import "GfycatUploadKey.h"
#import "GfycatConfigurationObject.h"
#import <AFNetworking/AFNetworking.h>
#import <UICKeyChainStore/UICKeyChainStore.h>

NS_ASSUME_NONNULL_BEGIN

const GfycatAgeRating GfycatAgeRatingG = @"G";
const GfycatAgeRating GfycatAgeRatingPG = @"PG";
const GfycatAgeRating GfycatAgeRatingPG13 = @"PG13";
const GfycatAgeRating GfycatAgeRatingR = @"R";

NSString *const kKeychainUsernameKey = @"username";
NSString *const kKeychainPasswordKey = @"password";

NSString *const kKeychainAccessTokenKey = @"accessToken";
NSString *const kKeychainAccessTokenExpirationDateKey = @"tokenExpirationDate";
NSString *const kKeychainRefreshTokenKey = @"refreshToken";
NSString *const kKeychainRefreshTokenExpirationDateKey = @"refreshTokenExpirationDate";

@interface GfycatApi() {
@private
    NSURL *_baseURL;
    NSString * _Nullable _overrideDomain;
    NSNumber * _Nullable _overridePort;
    dispatch_semaphore_t _authenticationSemaphore;
}

@property (nonatomic, copy, nonnull) NSString *appClientID;
@property (nonatomic, copy, nonnull) NSString *appClientSecret;
@property (nonatomic, assign) BOOL gfycatCategoryManagementEnabled;
@property (nonatomic, strong, nonnull) AFHTTPSessionManager *httpManager;
@property (nonatomic, strong, nonnull) AFHTTPSessionManager *httpRedirectManager;
@property (nonatomic, strong, nonnull) AFHTTPSessionManager *httpUploadManager;

@property (nonatomic, strong, nonnull) UICKeyChainStore *keychainStore;

@property (nonatomic, copy, nullable) NSString *username;
@property (nonatomic, copy, nullable) NSString *password;

@property (nonatomic, copy, nullable) NSString *accessToken;
@property (nonatomic, nullable) NSDate *accessTokenExpirationDate;
@property (nonatomic, copy, nullable) NSString *refreshToken;
@property (nonatomic, nullable) NSDate *refreshTokenExpirationDate;

@property (nonatomic) NSDateFormatter *dateFormatter;

@property (nonatomic) dispatch_queue_t authenticationQueue;

@end

@implementation GfycatSearchOptions
@end

@implementation GfycatApi

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [NSDateFormatter new];
        [_dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
    }
    
    return _dateFormatter;
}

#pragma mark - Initializers -

+ (instancetype)shared {
    static GfycatApi *_shared = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _shared = [[GfycatApi alloc] init];
    });
    return _shared;
}

- (dispatch_queue_t)authenticationQueue {
    if (!_authenticationQueue) {
        _authenticationQueue = dispatch_queue_create("com.gfycatapi.queue", DISPATCH_QUEUE_SERIAL);
    }
    
    return _authenticationQueue;
}

- (instancetype)init
{
    if (self = [super init]) {
        _authenticationSemaphore = dispatch_semaphore_create(1);
        [self setBaseURL:[NSURL URLWithString:kGfycatApiKitBaseURL]];
        [self configureCredentials];
    }
    
    return self;
}

- (void)configureHTTPManagersWithBaseURL:(NSURL *)baseURL
{
    self.httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    self.httpManager.responseSerializer = [AFJSONResponseSerializer new];
    self.httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
    self.httpManager.requestSerializer = [AFJSONRequestSerializer new];
    
    self.httpRedirectManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
    self.httpRedirectManager.responseSerializer = [AFHTTPResponseSerializer new];
    self.httpRedirectManager.requestSerializer = [AFHTTPRequestSerializer new];
    
    self.httpUploadManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    self.httpUploadManager.responseSerializer = [AFHTTPResponseSerializer new];
    self.httpUploadManager.requestSerializer = [AFHTTPRequestSerializer new];
}

- (void)configureCredentials
{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    
    self.appClientID = info[kGfycatAppClientIdConfigurationKey];
    self.appClientSecret = info[kGfycatAppClientSecretConfigurationKey];
    self.keychainStore = [UICKeyChainStore keyChainStoreWithService:GfycatApiKitKeychainStore accessGroup:info[kGfycatApiKitKeychainAccessGroupConfigurationKey]];
    self.accessToken = self.keychainStore[kKeychainAccessTokenKey];
    self.sharedContainerIdentifier = info[kGfycatApiKitSharedContainerIdentifierConfigurationKey];
    self.gfycatCategoryManagementEnabled = info[kGfycatCategoryManagementEnabled] != nil ? ((NSNumber *)info[kGfycatCategoryManagementEnabled]).boolValue : YES;
    _username = self.keychainStore[kKeychainUsernameKey];
    _password = self.keychainStore[kKeychainPasswordKey];
    _refreshToken = self.keychainStore[kKeychainRefreshTokenKey];
    _refreshTokenExpirationDate = [self.dateFormatter dateFromString:self.keychainStore[kKeychainRefreshTokenExpirationDateKey]];
    _accessTokenExpirationDate = [self.dateFormatter dateFromString:self.keychainStore[kKeychainAccessTokenExpirationDateKey]];
}

- (void)setAppClientID:(NSString *)appClientID withSecret:(NSString *)appClientSecret
{
    self.appClientID = appClientID;
    self.appClientSecret = appClientSecret;
}

- (void)setBaseURL:(NSURL *)baseURL
{
    baseURL = baseURL ?: [NSURL URLWithString:kGfycatApiKitBaseURL];
    if (_baseURL && [_baseURL isEqual:baseURL]) {
        return;
    }
    _baseURL = [baseURL copy];
    [self configureHTTPManagersWithBaseURL:[self URLByApplyingOverrideDomain:baseURL]];
}

- (void)setOverrideDomain:(NSString *)overrideDomain port:(nullable NSNumber *)port
{
    BOOL isSameDomain   = (_overrideDomain == overrideDomain) || (_overrideDomain && [_overrideDomain isEqualToString:overrideDomain]);
    BOOL isSamePort     = (_overridePort == port) || (_overridePort && [_overridePort isEqualToNumber:port]);
    if (isSameDomain && isSamePort) {
        return;
    }
    _overrideDomain = [overrideDomain copy];
    _overridePort = port;
    
    NSURL *baseURL = _baseURL ?: [NSURL URLWithString:kGfycatApiKitBaseURL];
    [self configureHTTPManagersWithBaseURL:[self URLByApplyingOverrideDomain:baseURL]];
}

- (NSMutableDictionary *)searchParametersForOptions:(nullable GfycatSearchOptions *)options
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];

    if (options.maxLength) {
        [result setObject:[options.maxLength copy] forKey:@"maxLength"];
    }
    if (options.minLength) {
        [result setObject:[options.minLength copy] forKey:@"minLength"];
    }
    if (options.maxAspectRatio) {
        [result setObject:[options.maxAspectRatio copy] forKey:@"maxAspectRatio"];
    }
    if (options.minAspectRatio) {
        [result setObject:[options.minAspectRatio copy] forKey:@"minAspectRatio"];
    }
    if (options.rating.length) {
        [result setObject:[options.rating copy] forKey:@"rating"];
    }

    return result;
}

#pragma mark -

- (void)setAccessToken:(nullable NSString *)accessToken {
    _accessToken = [accessToken copy];
    
    self.keychainStore[kKeychainAccessTokenKey] = accessToken;
    
    if (accessToken) {
        NSString *accessTokenString = [NSString stringWithFormat:@"Bearer %@", accessToken];
        [self.httpManager.requestSerializer setValue:accessTokenString forHTTPHeaderField:kKeyAuthorization];
    } else {
        self.httpManager.requestSerializer = [AFJSONRequestSerializer new];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GfycatApiKitUserAuthenticationChangedNotification object:nil];
}

- (void)setUsername:(nullable NSString *)username {
    _username = [username copy];
    
    self.keychainStore[kKeychainUsernameKey] = username;
}

- (void)setPassword:(nullable NSString *)password {
    _password = [password copy];
    
    self.keychainStore[kKeychainPasswordKey] = password;
}

- (void)setRefreshToken:(nullable NSString *)refreshToken {
    _refreshToken = [refreshToken copy];
    
    self.keychainStore[kKeychainRefreshTokenKey] = refreshToken;
}

- (void)setAccessTokenExpirationDate:(nullable NSDate *)accessTokenExpirationDate {
    _accessTokenExpirationDate = accessTokenExpirationDate;
    
    self.keychainStore[kKeychainAccessTokenExpirationDateKey] = [self.dateFormatter stringFromDate:accessTokenExpirationDate];
}

- (void)setRefreshTokenExpirationDate:(nullable NSDate *)refreshTokenExpirationDate {
    _refreshTokenExpirationDate = refreshTokenExpirationDate;
    
    self.keychainStore[kKeychainRefreshTokenExpirationDateKey] = [self.dateFormatter stringFromDate:refreshTokenExpirationDate];
}

#pragma mark - Authentication -

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
                  success:(GfycatResponseBlock)success
                  failure:(nullable GfycatFailureBlock)failure {

    NSParameterAssert(username);
    NSParameterAssert(password);
    
    dispatch_async(self.authenticationQueue, ^{
        
        dispatch_semaphore_wait(self->_authenticationSemaphore, DISPATCH_TIME_FOREVER);
        self.accessToken = nil;
        
        NSDictionary *params = @{
                                 kKeyUsername: username,
                                 kKeyPassword: password,
                                 kKeyGrantType: @"password"
                                 };
        
        __weak __typeof(self) weakSelf = self;
        [self postPath:self.authorizationEndpointURL.absoluteString
            parameters:params
               success:^(NSDictionary *response) {
                   __strong __typeof(weakSelf) strongSelf = weakSelf;
                   strongSelf.username = username;
                   strongSelf.password = password;
                   [strongSelf saveCredentialsForResponse:response];
                   dispatch_semaphore_signal(self->_authenticationSemaphore);
                   GfySafeExecute(success, response);
               } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
                   dispatch_semaphore_signal(self->_authenticationSemaphore);
                   GfySafeExecute(failure, error, serverStatusCode);
               }];
    });
}

- (void)loginWithFacebook:(NSString *)facebookToken
                  success:(GfycatResponseBlock)success
                  failure:(nullable GfycatFailureBlock)failure {
    
    NSParameterAssert(facebookToken);
    
    dispatch_async(self.authenticationQueue, ^{
        
        dispatch_semaphore_wait(self->_authenticationSemaphore, DISPATCH_TIME_FOREVER);
        self.accessToken = nil;
        
        NSDictionary *params = @{
            kKeyGrantType: @"convert_token",
            kKeyProvider: @"facebook",
            kKeyToken: facebookToken ?: @"",
        };
        
        __weak __typeof(self) weakSelf = self;
        [self postPath:self.authorizationEndpointURL.absoluteString
            parameters:params
               success:^(NSDictionary *response) {
                   __strong __typeof(weakSelf) strongSelf = weakSelf;
                   strongSelf.username = response[@"resource_owner"];
                   [strongSelf saveCredentialsForResponse:response];
                   dispatch_semaphore_signal(self->_authenticationSemaphore);
                   GfySafeExecute(success, response);
               } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
                   dispatch_semaphore_signal(self->_authenticationSemaphore);
                   GfySafeExecute(failure, error, serverStatusCode);
               }];
    });
}

- (void)requestPasswordResetWithUsername:(NSString *)username
                                 success:(GfycatSuccessBlock)success
                                 failure:(nullable GfycatFailureBlock)failure {
    
    NSParameterAssert(username);
    
    __weak __typeof(self) weakSelf = self;
    [self refreshSession:^(NSDictionary *serverResponse) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSString *path = [strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:@"me/send_verification_email"].absoluteString;
        NSDictionary *params = [self dictionaryWithClientKeysAndParameters:@{}];
        [self.httpManager POST:path parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSInteger serverStatusCode = ((NSHTTPURLResponse*)[task response]).statusCode;
            if (serverStatusCode / 100 == 2) {
                GfySafeExecute(success);
            } else {
                GfySafeExecute(failure, [NSError errorWithDomain:@"com.gfycat" code:0 userInfo:nil], serverStatusCode);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSInteger serverStatusCode = ((NSHTTPURLResponse*)[task response]).statusCode;
            if (serverStatusCode / 100 == 2) {
                GfySafeExecute(success);
            } else {
                GfySafeExecute(failure, error, serverStatusCode);
            }
        }];
    } failure:failure];
}

- (void)checkUsername:(NSString *)username
              success:(void(^)(BOOL))success
              failure:(nullable GfycatFailureBlock)failure {
    
    NSParameterAssert(username);

    __weak __typeof(self) weakSelf = self;
    [self refreshSession:^(NSDictionary *serverResponse) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSString *path = [[strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:@"users"] URLByAppendingPathComponent:username].absoluteString;
        [self headPath:path parameters:@{} result:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
            if (serverStatusCode == 404) {
                GfySafeExecute(success, YES);
            } else if (serverStatusCode == 422 || serverStatusCode / 100 == 2) {
                GfySafeExecute(success, NO);
            } else {
                GfySafeExecute(failure, error, serverStatusCode);
            }
        }];
    } failure:failure];
}

- (void)getUserProfile:(NSString *)username
               success:(GfycatUserProfileBlock)success
               failure:(nullable GfycatFailureBlock)failure {
    
    NSParameterAssert(username);
    
    __weak __typeof(self) weakSelf = self;
    [self refreshSession:^(NSDictionary *serverResponse) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSString *path = [[strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:@"users"] URLByAppendingPathComponent:username].absoluteString;
        [self getPath:path parameters:@{} responseModel:[GfycatUserProfile class] success:success failure:failure];
    } failure:failure];
}

- (void)createAccountWithUsername:(NSString *)username
                         password:(NSString *)password
                            email:(nullable NSString *)email
                          success:(GfycatResponseBlock)success
                          failure:(nullable GfycatFailureBlock)failure {
    
    NSParameterAssert(username);
    NSParameterAssert(password);
    
    __weak __typeof(self) weakSelf = self;
    [self refreshSession:^(NSDictionary *serverResponse) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        dispatch_semaphore_wait(strongSelf->_authenticationSemaphore, DISPATCH_TIME_FOREVER);

        NSMutableDictionary *params = [@{
            @"username": username,
            @"password": password
        } mutableCopy];

        if (email) {
            params[@"email"] = email;
        }
        
        NSString *path = [strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:@"users"].absoluteString;
        [strongSelf postPath:path parameters:params success:^(NSDictionary *response) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.username = username;
            strongSelf.password = password;
            [strongSelf saveCredentialsForResponse:response];
            dispatch_semaphore_signal(strongSelf->_authenticationSemaphore);
            GfySafeExecute(success, response);
        } failure:^(NSError *error, NSInteger serverStatusCode) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            dispatch_semaphore_signal(strongSelf->_authenticationSemaphore);
            GfySafeExecute(failure, error, serverStatusCode);
        }];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

- (void)createAccountWithUsername:(NSString *)username
                    facebookToken:(NSString *)facebookToken
                          success:(GfycatResponseBlock)success
                          failure:(nullable GfycatFailureBlock)failure
{
    
    NSParameterAssert(username);
    NSParameterAssert(facebookToken);
    
    __weak __typeof(self) weakSelf = self;
    [self refreshSession:^(NSDictionary *serverResponse) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        dispatch_semaphore_wait(strongSelf->_authenticationSemaphore, DISPATCH_TIME_FOREVER);

        NSMutableDictionary *params = [@{
            @"username": username,
            @"provider": @"facebook",
            @"access_token": facebookToken
        } mutableCopy];
        
        NSString *path = [strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:@"users"].absoluteString;
        [strongSelf postPath:path parameters:params success:^(NSDictionary *response) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.username = username;
            [strongSelf saveCredentialsForResponse:response];
            dispatch_semaphore_signal(strongSelf->_authenticationSemaphore);
            GfySafeExecute(success, response);
        } failure:^(NSError *error, NSInteger serverStatusCode) {
            dispatch_semaphore_signal(strongSelf->_authenticationSemaphore);
            GfySafeExecute(failure, error, serverStatusCode);
        }];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

- (void)saveCredentialsForResponse:(NSDictionary *)response {
    
    self.accessToken = response[kKeyAccessToken];
    NSNumber *tokenExpirationInterval = response[kKeyAccessTokenExpiration];
    self.accessTokenExpirationDate = GfyNotNull(tokenExpirationInterval) ? [NSDate dateWithTimeIntervalSinceNow:tokenExpirationInterval.integerValue] : [NSDate date];
    self.refreshToken = response[kKeyRefreshToken];
    NSNumber *refreshExpirationInterval = response[kKeyRefreshTokenExpiration];
    self.refreshTokenExpirationDate = GfyNotNull(refreshExpirationInterval) ? [NSDate dateWithTimeIntervalSinceNow:refreshExpirationInterval.integerValue] : [NSDate date];
}

- (void)validateSession:(GfycatResponseBlock)success
                failure:(nullable GfycatFailureBlock)failure {
    
    dispatch_semaphore_wait(self->_authenticationSemaphore, DISPATCH_TIME_FOREVER);
    self.accessToken = nil;
    
    NSDictionary *params = @{ kKeyGrantType: @"client_credentials"};
    
    __weak __typeof(self) weakSelf = self;
    [self postPath:self.authorizationEndpointURL.absoluteString
        parameters:params
           success:^(NSDictionary *response) {
               __strong __typeof(weakSelf) strongSelf = weakSelf;
               
               NSDictionary *modelDictionary = response;
               strongSelf.accessToken = modelDictionary[kKeyAccessToken];
               NSNumber *tokenExpirationInterval = modelDictionary[kKeyAccessTokenExpiration];
               strongSelf.accessTokenExpirationDate = GfyNotNull(tokenExpirationInterval) ? [NSDate dateWithTimeIntervalSinceNow:tokenExpirationInterval.integerValue] : [NSDate date];
               
               dispatch_semaphore_signal(strongSelf->_authenticationSemaphore);
               GfySafeExecute(success, response);
           } failure:^(NSError *error, NSInteger serverStatusCode) {
               __strong __typeof(weakSelf) strongSelf = weakSelf;
               dispatch_semaphore_signal(strongSelf->_authenticationSemaphore);
               GfySafeExecute(failure, error, serverStatusCode);
           }];
}

NSInteger const kTokenExpirationThreshold = 30;
- (void)refreshSession:(GfycatResponseBlock)success
               failure:(nullable GfycatFailureBlock)failure {
    
    __weak __typeof(self) weakSelf = self;
    dispatch_async(self.authenticationQueue, ^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        dispatch_semaphore_wait(strongSelf->_authenticationSemaphore, DISPATCH_TIME_FOREVER);
        
        if ([strongSelf isSessionValid]) {
            NSDictionary *modelDictionary = @{
                                              kKeyAccessToken : strongSelf.accessToken,
                                              kKeyAccessTokenExpiration : @([strongSelf.accessTokenExpirationDate timeIntervalSinceNow])
                                              };
            dispatch_semaphore_signal(strongSelf->_authenticationSemaphore);
            GfySafeExecute(success, modelDictionary);
            return;
        }
        
        if (strongSelf.refreshToken && strongSelf.refreshTokenExpirationDate &&
            [strongSelf.refreshTokenExpirationDate timeIntervalSinceNow] > kTokenExpirationThreshold) {
            
            strongSelf.accessToken = nil;
            NSDictionary *params = @{
                                     kKeyRefreshToken : strongSelf.refreshToken,
                                     kKeyGrantType : @"refresh"
                                     };
            strongSelf.refreshToken = nil; // Refresh tokens can only be used once
            
            [strongSelf postPath:strongSelf.authorizationEndpointURL.absoluteString
                    parameters:params
                       success:^(NSDictionary *response) {
                           __strong __typeof(weakSelf) strongSelf = weakSelf;
                           
                           NSDictionary *modelDictionary = response;
                           strongSelf.accessToken = modelDictionary[kKeyAccessToken];
                           NSNumber *tokenExpirationInterval = modelDictionary[kKeyAccessTokenExpiration];
                           strongSelf.accessTokenExpirationDate = GfyNotNull(tokenExpirationInterval) ? [NSDate dateWithTimeIntervalSinceNow:tokenExpirationInterval.integerValue] : [NSDate date];
                           
                           dispatch_semaphore_signal(strongSelf->_authenticationSemaphore);
                           GfySafeExecute(success, response);
                       } failure:^(NSError *error, NSInteger serverStatusCode) {
                           // The refresh token didn't work for some reason, we'll just try to refresh again
                           // with the other options.
                           dispatch_semaphore_signal(strongSelf->_authenticationSemaphore);
                           [weakSelf refreshSession:success failure:failure];
                       }];
            return;
        }
        
        if (strongSelf.username && strongSelf.password) {
            strongSelf.accessToken = nil;
            
            NSDictionary *params = @{
                                     kKeyUsername : strongSelf.username,
                                     kKeyPassword : strongSelf.password,
                                     kKeyGrantType : @"password"
                                     };
            [strongSelf postPath:strongSelf.authorizationEndpointURL.absoluteString
                    parameters:params
                       success:^(NSDictionary *response) {
                           [weakSelf saveCredentialsForResponse:response];
                           
                           dispatch_semaphore_signal(strongSelf->_authenticationSemaphore);
                           GfySafeExecute(success, response);
                       } failure:^(NSError *error, NSInteger serverStatusCode) {
                           // Username/password didn't work for some reason, we'll just forget the password
                           // to refresh again with the other options.
                           strongSelf.password = nil;
                           dispatch_semaphore_signal(strongSelf->_authenticationSemaphore);
                           GfySafeExecute(failure, error, serverStatusCode);
                       }];
            return;
        }
        
        dispatch_semaphore_signal(strongSelf->_authenticationSemaphore);
        [strongSelf validateSession:success failure:failure];
    });
}

- (BOOL)isSessionValid {
    return (self.accessToken != nil) && ([self.accessTokenExpirationDate timeIntervalSinceNow] > kTokenExpirationThreshold);
}

- (BOOL)isLoggedIn {
    return (self.username != nil) && [self isSessionValid];
}

- (void)logout {
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [[storage cookies] enumerateObjectsUsingBlock:^(NSHTTPCookie *cookie, NSUInteger idx, BOOL *stop) {
        [storage deleteCookie:cookie];
    }];

    self.username = nil;
    self.password = nil;
    self.accessToken = nil;
}

- (NSDictionary *)dictionaryWithClientKeysAndParameters:(NSDictionary *)params { // TODO - Rename
    
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:params];
    if (!self.accessToken) {
        [mutableDictionary addEntriesFromDictionary:@{
                                                      kKeyClientID : self.appClientID,
                                                      kKeyClientSecret : self.appClientSecret
                                                      }];
    }
    return [NSDictionary dictionaryWithDictionary:mutableDictionary];
}

#pragma mark - Base Calls -


- (void)headPath:(NSString *)path
      parameters:(NSDictionary *)parameters
          result:(nullable GfycatFailureBlock)result {
    
    NSDictionary *params = [self dictionaryWithClientKeysAndParameters:parameters];
    NSString *percentageEscapedPath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.httpManager GET:percentageEscapedPath
               parameters:params
                 progress:nil
                  success:^(NSURLSessionDataTask *task, id responseObject) {
                      GfySafeExecute(result, [NSError errorWithDomain:@"com.gfycat" code:0 userInfo:nil], ((NSHTTPURLResponse *)[task response]).statusCode);
                  }
                  failure:^(NSURLSessionDataTask *task, NSError *error) {
                      NSInteger statusCode = ((NSHTTPURLResponse *)[task response]).statusCode;
                      if (statusCode == 401) {
                          self.accessToken = nil;
                      }
                      GfySafeExecute(result, error, statusCode);
                  }];
}

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
  responseModel:(Class)modelClass
        success:(GfycatObjectBlock)success
        failure:(nullable GfycatFailureBlock)failure {
    
    NSDictionary *params = [self dictionaryWithClientKeysAndParameters:parameters];
    NSString *percentageEscapedPath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.httpManager GET:percentageEscapedPath
               parameters:params
                 progress:nil
                  success:^(NSURLSessionDataTask *task, id responseObject) {
                      if (!success) return;
                      NSDictionary *responseDictionary = (NSDictionary *)responseObject;
                      
                      if (responseDictionary[@"errorMessage"]) {
                          NSError *error = [[NSError alloc] initWithDomain:GfycatApiKitErrorDomain code:GfycatApiKitJSONResponseError userInfo:responseObject];
                          GfySafeExecute(failure, error, ((NSHTTPURLResponse *)[task response]).statusCode);
                          return;
                      }
                      
                      id modelObject =  (modelClass == [NSDictionary class]) ? [responseDictionary copy] : [[modelClass alloc] initWithInfo:responseDictionary];
                      GfySafeExecute(success, modelObject);
                  }
                  failure:^(NSURLSessionDataTask *task, NSError *error) {
                      NSInteger statusCode = ((NSHTTPURLResponse *)[task response]).statusCode;
                      if (statusCode == 401) {
                          self.accessToken = nil;
                      }
                      GfySafeExecute(failure, error, statusCode);
                  }];
}

- (void)getPaginatedPath:(NSString *)path
              parameters:(NSDictionary *)parameters
           responseModel:(Class)modelClass
                 success:(GfycatPaginatiedResponseBlock)success
                 failure:(nullable GfycatFailureBlock)failure {
    
    NSDictionary *params = [self dictionaryWithClientKeysAndParameters:parameters];
    NSString *percentageEscapedPath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.httpManager GET:percentageEscapedPath
               parameters:params
                 progress:nil
                  success:^(NSURLSessionDataTask *task, id responseObject) {
                      if (!success) return;
                      NSDictionary *responseDictionary = (NSDictionary *)responseObject;
                      
                      if (responseDictionary[@"errorMessage"]) {
                          NSError *error = [[NSError alloc] initWithDomain:GfycatApiKitErrorDomain code:GfycatApiKitJSONResponseError userInfo:responseObject];
                          GfySafeExecute(failure, error, ((NSHTTPURLResponse *)[task response]).statusCode);
                          return;
                      }
                      
                      GfycatPaginationInfo *paginationInfo = GfyNotNull(responseDictionary)?[[GfycatPaginationInfo alloc] initWithInfo:responseDictionary path:path parameters:parameters andObjectType:modelClass]: nil;
                      
                      id modelObject = [[modelClass alloc] initWithInfo:responseDictionary];
                      
                      if ([path rangeOfString:@"reactions/populated"].location != NSNotFound && [modelObject isKindOfClass:[GfycatCategories class]]) {
                          for (id item in [modelObject array]) {
                              [item setLocalizedTitle:[[item localizedTitle] uppercaseString]];
                          }
                      }

                      GfySafeExecute(success, modelObject, paginationInfo);
                  }
                  failure:^(NSURLSessionDataTask *task, NSError *error) {
                      NSInteger statusCode = ((NSHTTPURLResponse *)[task response]).statusCode;
                      if (statusCode == 401) {
                          self.accessToken = nil;
                      }
                      GfySafeExecute(failure, error, statusCode);
                  }];
}


- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
         success:(GfycatResponseBlock)success
         failure:(nullable GfycatFailureBlock)failure {
    
    NSDictionary *params = [self dictionaryWithClientKeysAndParameters:parameters];
    [self.httpManager POST:path
                parameters:params
                  progress:nil
                   success:^(NSURLSessionDataTask *task, id responseObject) {
                       GfySafeExecute(success, (NSDictionary *)responseObject);
                   }
                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                       NSInteger statusCode = ((NSHTTPURLResponse *)[task response]).statusCode;
                       if (statusCode == 401) {
                           self.accessToken = nil;
                       }
                       GfySafeExecute(failure, error, statusCode);
                   }];
}


- (void)deletePath:(NSString *)path
        parameters:(NSDictionary *)parameters
           success:(GfycatResponseBlock)success
           failure:(nullable GfycatFailureBlock)failure {
    
    NSDictionary *params = [self dictionaryWithClientKeysAndParameters:parameters];
    [self.httpManager DELETE:path
                  parameters:params
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         GfySafeExecute(success, (NSDictionary *)responseObject);
                     }
                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                         NSInteger statusCode = ((NSHTTPURLResponse *)[task response]).statusCode;
                         if (statusCode == 401) {
                             self.accessToken = nil;
                         }
                         GfySafeExecute(failure, error, statusCode);
                     }];
}

- (void)putPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        success:(GfycatResponseBlock)success
        failure:(nullable GfycatFailureBlock)failure {
    
    NSDictionary *params = [self dictionaryWithClientKeysAndParameters:parameters];
    [self.httpManager PUT:path
               parameters:params
                  success:^(NSURLSessionDataTask *task, id responseObject) {
                      GfySafeExecute(success, (NSDictionary *)responseObject);
                  }
                  failure:^(NSURLSessionDataTask *task, NSError *error) {
                      NSInteger statusCode = ((NSHTTPURLResponse *)[task response]).statusCode;
                      if (statusCode == 401) {
                          self.accessToken = nil;
                      }
                      GfySafeExecute(failure, error, statusCode);
                  }];
    
}

#pragma mark - Collections -

- (void)getUserCollections:(NSString *)username
                     count:(NSInteger)count
                   success:(GfycatCollectionArrayBlock)success
                   failure:(nullable GfycatFailureBlock)failure {

    NSParameterAssert(username.length);

    __weak __typeof(self) weakSelf = self;
    [self refreshSession:^(NSDictionary *serverResponse) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;

        NSString *paginatedPath = [[[strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:@"users"] URLByAppendingPathComponent:username] URLByAppendingPathComponent:@"collections"].absoluteString;
        [strongSelf getPaginatedPath:paginatedPath
                          parameters:@{ kLocale: [self currentLanguageCode],  @"count" : @(count) }
                       responseModel:[GfycatCollections class]
                             success:success
                             failure:failure];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

- (void)getUserCollectionMedia:(NSString *)username
                      folderId:(NSString *)folderId
                         count:(NSInteger)count
                   withSuccess:(GfycatMediaBlock)success
                       failure:(nullable GfycatFailureBlock)failure {

    NSParameterAssert(username.length);
    NSParameterAssert(folderId.length);

    __weak __typeof(self) weakSelf = self;
    [self refreshSession:^(NSDictionary *serverResponse) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSString *paginatedPath = [[[[[strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:@"users"] URLByAppendingPathComponent:username] URLByAppendingPathComponent:@"collections"] URLByAppendingPathComponent:folderId] URLByAppendingPathComponent:@"gfycats"].absoluteString;
        [strongSelf getPaginatedPath:paginatedPath
                          parameters:@{ @"count": @(1), }
                       responseModel:[GfycatMediaCollection class]
                             success:success
                             failure:failure];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

- (void)getCurrentUserCollectionsCount:(NSInteger)count
                               success:(GfycatCollectionArrayBlock)success
                               failure:(nullable GfycatFailureBlock)failure {

    __weak __typeof(self) weakSelf = self;
    [self refreshSession:^(NSDictionary *serverResponse) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;

        NSString *paginatedPath = [strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:@"me/collections"].absoluteString;
        [strongSelf getPaginatedPath:paginatedPath
                          parameters:@{ kLocale: [self currentLanguageCode],  @"count" : @(count) }
                       responseModel:[GfycatCollections class]
                             success:success
                             failure:failure];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}


- (void)getCurrentUserCollectionMedia:(NSString *)folderId
                                count:(NSInteger)count
                          withSuccess:(GfycatMediaBlock)success
                              failure:(nullable GfycatFailureBlock)failure {

    NSParameterAssert(folderId.length);

    __weak __typeof(self) weakSelf = self;
    [self refreshSession:^(NSDictionary *serverResponse) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSString *paginatedPath = [[[strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:@"me/collections"] URLByAppendingPathComponent:folderId] URLByAppendingPathComponent:@"gfycats"].absoluteString;
        [strongSelf getPaginatedPath:paginatedPath
                          parameters:@{ @"count": @(1), }
                       responseModel:[GfycatMediaCollection class]
                             success:success
                             failure:failure];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

#pragma mark - Media -

- (void)getMedia:(NSString *)mediaId
     withSuccess:(GfycatMediaObjectBlock)success
         failure:(nullable GfycatFailureBlock)failure {
    
    __weak __typeof(self) weakSelf = self;
    [self refreshSession:^(NSDictionary *serverResponse) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSString *getPath = [strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"gfycats/%@", mediaId]].absoluteString;
        [strongSelf getPath:getPath
               parameters:@{}
            responseModel:[GfycatMedia class]
                  success:success
                  failure:failure];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

- (void)_parseReferencedMedia:(NSURL *)mediaURL withSuccess:(GfycatReferencedMediaObjectBlock)success failure:(nullable GfycatFailureBlock)failure {
    GfycatReferencedMedia *media = [[GfycatReferencedMedia alloc] initWithMessageURL:mediaURL];
    if (media) {
        GfySafeExecute(success, (GfycatReferencedMedia * _Nonnull)media);
    } else {
        NSError *error = [[NSError alloc] initWithDomain:GfycatApiKitErrorDomain code:GfycatApiKitInvalidMediaReferenceURL userInfo:@{
            NSURLErrorFailingURLErrorKey: mediaURL,
            NSURLErrorFailingURLStringErrorKey: mediaURL.absoluteString,
        }];
        GfySafeExecute(failure, error, 0);
    }
}

- (void)getReferencedMedia:(NSURL *)mediaURL withSuccess:(GfycatReferencedMediaObjectBlock)success failure:(nullable GfycatFailureBlock)failure {
    if ([mediaURL.host hasSuffix:@"gfycat.com"]) {
        [self _parseReferencedMedia:mediaURL withSuccess:success failure:failure];
        return;
    }
    [self.httpRedirectManager GET:mediaURL.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self _parseReferencedMedia:task.currentRequest.URL withSuccess:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        GfySafeExecute(failure, error, 0);
    }];
}

- (void)getExtendedMedia:(NSString *)mediaId withSuccess:(GfycatExtendedMediaObjectBlock)success failure:(nullable GfycatFailureBlock)failure {
    __weak __typeof(self) weakSelf = self;
    [self refreshSession:^(NSDictionary *serverResponse) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSString *getPath = [strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"me/gfycats/%@/full", mediaId]].absoluteString;
        [strongSelf getPath:getPath
               parameters:@{}
            responseModel:[GfycatExtendedMedia class]
                  success:success
                  failure:failure];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

- (void)getLikeStateForMedia:(GfycatMedia *)media withSuccess:(GfycatMediaLikeStateBlock)success failure:(nullable GfycatFailureBlock)failure; {
    __weak __typeof(self) weakSelf = self;
    [self refreshSession:^(NSDictionary *serverResponse) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        NSString *getPath = [strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"me/gfycats/%@/like", media.gfyName]].absoluteString;
        NSString *percentageEscapedPath = [getPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *params = [self dictionaryWithClientKeysAndParameters:@{}];

        void(^responseProcessor)(NSInteger) = ^(NSInteger statusCode) {
            BOOL isLiked = (statusCode >= 200 && statusCode < 300);
            GfySafeExecute(success, media, isLiked);
        };
        
        [self.httpManager GET:percentageEscapedPath
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask *task, id responseObject) {
                          if (!success) return;
                          NSDictionary *responseDictionary = (NSDictionary *)responseObject;
                          NSInteger statusCode = ((NSHTTPURLResponse *)[task response]).statusCode;
                          
                          if (responseDictionary[@"errorMessage"]) {
                              NSError *error = [[NSError alloc] initWithDomain:GfycatApiKitErrorDomain code:GfycatApiKitJSONResponseError userInfo:responseObject];
                              GfySafeExecute(failure, error, statusCode);
                              return;
                          }
                          responseProcessor(statusCode);
                      }
                      failure:^(NSURLSessionDataTask *task, NSError *error) {
                          responseProcessor(((NSHTTPURLResponse *)[task response]).statusCode);
                      }];
        
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

- (void)getCategoriesCount:(NSInteger)count
               withSuccess:(GfycatCategoryArrayBlock)success
                   failure:(nullable GfycatFailureBlock)failure {
    
    __weak __typeof(self) weakSelf = self;
    [self refreshSession:^(NSDictionary *serverResponse) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        GfycatCategoryArrayBlock wrappedSuccess = ^(GfycatCategories *categories, GfycatPaginationInfo * _Nullable paginationInfo, BOOL isFromCache) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.gfycatCategoryManagementEnabled) {
                [strongSelf getConfigurationObjectsSuccess:^(NSArray<GfycatConfigurationObject *> * _Nonnull configurationObjects) {
                    success([weakSelf categoriesByApplyingConfigurations:configurationObjects toCategories:categories], paginationInfo, isFromCache);
                } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
                    success(categories, paginationInfo, isFromCache);
                }];
            } else {
                success(categories, paginationInfo, isFromCache);
            }
        };
        
        NSString *paginatedPath = [strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:@"reactions/populated"].absoluteString;
        [strongSelf getPaginatedPath:paginatedPath
                          parameters:@{ kLocale: [self currentLanguageCode],  @"count" : @(count),  @"gfyCount" : @(1) }
                       responseModel:[GfycatCategories class]
                             success:^(id paginatedObjects, GfycatPaginationInfo * _Nullable paginationInfo) {
                                 if (success != nil) {
                                     wrappedSuccess(paginatedObjects, paginationInfo, NO);
                                 }
                             }
                             failure:failure];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

- (void)getGamingCategoriesCount:(NSInteger)count
                     withSuccess:(GfycatCategoryArrayBlock)success
                         failure:(nullable GfycatFailureBlock)failure {
    
    __weak __typeof(self) weakSelf = self;
    [self refreshSession:^(NSDictionary *serverResponse) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        GfycatCategoryArrayBlock wrappedSuccess = ^(GfycatCategories *categories, GfycatPaginationInfo * _Nullable paginationInfo, BOOL isFromCache) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            
            if (strongSelf.gfycatCategoryManagementEnabled) {
                [strongSelf getConfigurationObjectsSuccess:^(NSArray<GfycatConfigurationObject *> * _Nonnull configurationObjects) {
                    success([weakSelf categoriesByApplyingConfigurations:configurationObjects toCategories:categories], paginationInfo, isFromCache);
                } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
                    success(categories, paginationInfo, isFromCache);
                }];
            } else {
                success(categories, paginationInfo, isFromCache);
            }
        };
        
        NSString *paginatedPath = [strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:@"tags/gaming/populated"].absoluteString;
        [strongSelf getPaginatedPath:paginatedPath
                          parameters:@{ @"count" : @(count),  @"gfyCount" : @(1) }
                       responseModel:[GfycatCategories class]
                             success:^(id paginatedObjects, GfycatPaginationInfo * _Nullable paginationInfo) {
                                 if (success != nil) {
                                     wrappedSuccess(paginatedObjects, paginationInfo, NO);
                                 }
                             }
                             failure:failure];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

- (BOOL)isAppStoreBuild
{
#ifdef DEBUG
    return NO;
#else
    return ([self isTestFlightBuild] == NO);
#endif
}

- (BOOL)isTestFlightBuild
{
#ifdef DEBUG
    return NO;
#else
    NSURL *appStoreReceiptURL = NSBundle.mainBundle.appStoreReceiptURL;
    NSString *appStoreReceiptLastComponent = appStoreReceiptURL.lastPathComponent;
    BOOL isSandboxReceipt = [appStoreReceiptLastComponent isEqualToString:@"sandboxReceipt"];
    
    return isSandboxReceipt;
#endif
}

- (void)getConfigurationObjectsSuccess:(GfycatConfigurationsArrayBlock)success failure:(nullable GfycatFailureBlock)failure {
    NSURL *urlToUse = nil;
    
    if ([self isAppStoreBuild]) {
        urlToUse = [NSURL URLWithString:kGfycatConfigurationReleaseFileURL];
    } else {
        urlToUse = [NSURL URLWithString:kGfycatConfigurationDebugFileURL];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:urlToUse];
    NSURLSessionDataTask *dataTask = [self.httpManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error != nil) {
            GfySafeExecute(failure, error, 0);
        } else {
            if (!success || ![responseObject isKindOfClass:[NSArray class]]) return;
            NSArray *responseArray = (NSArray *)responseObject;
            
            NSMutableArray<GfycatConfigurationObject *> *retValue = [@[] mutableCopy];
            
            for (NSDictionary *dict in responseArray) {
                GfycatConfigurationObject *configObject = [[GfycatConfigurationObject alloc] initWithDictionary:dict];
                [retValue addObject:configObject];
            }
            
            success(retValue);
        }
    }];
    [dataTask resume];
}

- (void)getTrendingMediaCount:(NSInteger)count
                  withSuccess:(GfycatMediaCacheableBlock)success
                      failure:(nullable GfycatFailureBlock)failure {
    
    __weak __typeof(self) weakSelf = self;
    GfycatMediaBlock successWrapper = ^(GfycatMediaCollection *mediaCollection, GfycatPaginationInfo * _Nullable paginationInfo) {
        GfySafeExecute(success, mediaCollection, paginationInfo, NO);
    };
    [self refreshSession:^(NSDictionary *serverResponse) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSString *paginatedPath = [strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:@"gfycats/trending"].absoluteString;
        [strongSelf getPaginatedPath:paginatedPath
                          parameters:@{ @"gfyCount" : @(count) }
                       responseModel:[GfycatMediaCollection class]
                             success:successWrapper
                             failure:failure];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

- (void)getSoundMediaCount:(NSInteger)count
               withSuccess:(GfycatMediaCacheableBlock)success
                   failure:(nullable GfycatFailureBlock)failure {
    [self getSoundMediaCount:count options:nil withSuccess:success failure:failure];
}

- (void)getSoundMediaCount:(NSInteger)count
                   options:(nullable GfycatSearchOptions *)options
               withSuccess:(GfycatMediaCacheableBlock)success
                   failure:(nullable GfycatFailureBlock)failure {

    NSMutableDictionary *params = [self searchParametersForOptions:options];
    [params setObject:@(count) forKey:@"gfyCount"];

    __weak __typeof(self) weakSelf = self;
    GfycatMediaBlock successWrapper = ^(GfycatMediaCollection *mediaCollection, GfycatPaginationInfo * _Nullable paginationInfo) {
        GfySafeExecute(success, mediaCollection, paginationInfo, NO);
    };
    [self refreshSession:^(NSDictionary *serverResponse) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSString *paginatedPath = [strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:@"sound"].absoluteString;
        [strongSelf getPaginatedPath:paginatedPath
                          parameters:params
                       responseModel:[GfycatMediaCollection class]
                             success:successWrapper
                             failure:failure];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

- (void)getUserMedia:(NSString *)userName
               count:(NSInteger)count
         withSuccess:(GfycatMediaCacheableBlock)success
             failure:(nullable GfycatFailureBlock)failure {
    
    __weak __typeof(self) weakSelf = self;
    GfycatMediaBlock successWrapper = ^(GfycatMediaCollection *mediaCollection, GfycatPaginationInfo * _Nullable paginationInfo) {
        GfySafeExecute(success, mediaCollection, paginationInfo, NO);
    };
    [self refreshSession:^(NSDictionary *serverResponse) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSString *path = [NSString stringWithFormat:@"users/%@/gfycats", userName];
        NSString *paginatedPath = [strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:path].absoluteString;
        [strongSelf getPaginatedPath:paginatedPath
                          parameters:@{
                                       @"count":  @(count)
                                       }
                       responseModel:[GfycatMediaCollection class]
                             success:successWrapper
                             failure:failure];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}
- (void)getCategoryMedia:(NSString *)categoryTitle
                   count:(NSInteger)count
             withSuccess:(GfycatMediaCacheableBlock)success
                 failure:(nullable GfycatFailureBlock)failure {
    
    __weak __typeof(self) weakSelf = self;
    GfycatMediaBlock successWrapper = ^(GfycatMediaCollection *mediaCollection, GfycatPaginationInfo * _Nullable paginationInfo) {
        GfySafeExecute(success, mediaCollection, paginationInfo, NO);
    };
    [self refreshSession:^(NSDictionary *serverResponse) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSString *paginatedPath = [strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:@"reactions/populated"].absoluteString;
        [strongSelf getPaginatedPath:paginatedPath
                    parameters:@{
                                 kTagName : categoryTitle,
                                 @"count": @(1),
                                 @"gfyCount" : @(count)
                                 }
                 responseModel:[GfycatMediaCollection class]
                       success:successWrapper
                       failure:failure];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

- (void)getGamingCategoryMedia:(NSString *)categoryTitle
                         count:(NSInteger)count
                   withSuccess:(GfycatMediaCacheableBlock)success
                       failure:(nullable GfycatFailureBlock)failure {
    
    __weak __typeof(self) weakSelf = self;
    GfycatMediaBlock successWrapper = ^(GfycatMediaCollection *mediaCollection, GfycatPaginationInfo * _Nullable paginationInfo) {
        GfySafeExecute(success, mediaCollection, paginationInfo, NO);
    };
    [self refreshSession:^(NSDictionary *serverResponse) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSString *paginatedPath = [strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:@"gfycats/trending"].absoluteString;
        [strongSelf getPaginatedPath:paginatedPath
                          parameters:@{
                                       kTagName: categoryTitle,
                                       @"count": @(count)
                                       }
                       responseModel:[GfycatMediaCollection class]
                             success:successWrapper
                             failure:failure];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

- (void)searchMediaWithString:(NSString *)searchString
                        count:(NSInteger)count
                  withSuccess:(GfycatMediaBlock)success
                      failure:(nullable GfycatFailureBlock)failure {
    [self searchMediaWithString:searchString count:count options:nil withSuccess:success failure:failure];
}

- (void)searchMediaWithString:(NSString *)searchString
                        count:(NSInteger)count
                      options:(nullable GfycatSearchOptions *)options
                  withSuccess:(GfycatMediaBlock)success
                      failure:(nullable GfycatFailureBlock)failure {

    NSMutableDictionary *params = [self searchParametersForOptions:options];
    [params setObject:@(count) forKey:@"count"];
    [params setObject:searchString forKey:@"search_text"];

    __weak __typeof(self) weakSelf = self;
    [self refreshSession:^(NSDictionary *serverResponse) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSString *paginatedPath = [strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:@"gfycats/search"].absoluteString;
        [strongSelf getPaginatedPath:paginatedPath
                    parameters:params
                 responseModel:[GfycatMediaCollection class]
                       success:success
                       failure:failure];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

- (void)searchSoundMediaWithString:(NSString *)searchString
                             count:(NSInteger)count
                       withSuccess:(GfycatMediaBlock)success
                           failure:(nullable GfycatFailureBlock)failure {
    [self searchSoundMediaWithString:searchString count:count options:nil withSuccess:success failure:failure];
}

- (void)searchSoundMediaWithString:(NSString *)searchString
                             count:(NSInteger)count
                           options:(nullable GfycatSearchOptions *)options
                       withSuccess:(GfycatMediaBlock)success
                           failure:(nullable GfycatFailureBlock)failure {

    NSMutableDictionary *params = [self searchParametersForOptions:options];
    [params setObject:@(count) forKey:@"count"];
    [params setObject:searchString forKey:@"search_text"];

    __weak __typeof(self) weakSelf = self;
    [self refreshSession:^(NSDictionary *serverResponse) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSString *paginatedPath = [strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:@"sound/search"].absoluteString;
        [strongSelf getPaginatedPath:paginatedPath
                          parameters:params
                       responseModel:[GfycatMediaCollection class]
                             success:success
                             failure:failure];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

- (void)searchStickersWithString:(nullable NSString *)searchString
                           count:(NSInteger)count
                     withSuccess:(GfycatMediaBlock)success
                         failure:(nullable GfycatFailureBlock)failure {
    
    __weak __typeof(self) weakSelf = self;
    [self refreshSession:^(NSDictionary *serverResponse) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSString *paginatedPath = searchString.length
            ? [strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:@"stickers/search"].absoluteString
            : [strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:@"stickers"].absoluteString;
        NSDictionary *parameters = searchString.length
            ? @{ @"search_text": searchString, @"count": @(count) }
            : @{ @"count": @(count) };
        [strongSelf getPaginatedPath:paginatedPath
                          parameters:parameters
                       responseModel:[GfycatMediaCollection class]
                             success:success
                             failure:failure];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

- (void)getLikedMediasCount:(NSInteger)count
                     cursor:(nullable NSString *)cursor
                withSuccess:(GfycatMediaBlock)success
                    failure:(nullable GfycatFailureBlock)failure {
    __weak __typeof(self) weakSelf = self;
    [self refreshSession:^(NSDictionary *serverResponse) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSMutableDictionary *parameters = [@{@"count" : @(count)} mutableCopy];
        if (cursor != nil) {
            parameters[kCursor] = cursor;
        }
        NSString *paginatedPath = [strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:@"me/likes/populated"].absoluteString;
        [strongSelf getPaginatedPath:paginatedPath
                        parameters:parameters
                     responseModel:[GfycatMediaCollection class]
                           success:success
                           failure:failure];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

- (void)getCreatedMediasCount:(NSInteger)count
                       cursor:(nullable NSString *)cursor
                  withSuccess:(GfycatMediaBlock)success
                      failure:(nullable GfycatFailureBlock)failure
{
    __weak __typeof(self) weakSelf = self;
    [self refreshSession:^(NSDictionary *serverResponse) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSMutableDictionary *parameters = [@{@"count" : @(count)} mutableCopy];
        if (cursor != nil) {
            parameters[kCursor] = cursor;
        }
        NSString *paginatedPath = [strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:@"me/gfycats"].absoluteString;
        [strongSelf getPaginatedPath:paginatedPath
                        parameters:parameters
                     responseModel:[GfycatMediaCollection class]
                           success:success
                           failure:failure];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

- (void)reportMedia:(NSString *)mediaId
        withSuccess:(GfycatResponseBlock)success
            failure:(nullable GfycatFailureBlock)failure {
    
    __weak __typeof(self) weakSelf = self;
    [self refreshSession:^(NSDictionary *serverResponse) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSString *postPath = [strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"gfycats/%@/report-content", mediaId]].absoluteString;
        [strongSelf postPath:postPath
                parameters:@{}
                   success:success
                   failure:failure];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

- (NSProgress *)downloadFileWithURL:(NSURL * _Nullable)url
                         completion:(void(^)(NSURLResponse * _Nullable response, NSURL * _Nullable filePath, NSError * _Nullable error))completion {
    
    return [self downloadFileWithURL:url ignoreCache:NO completion:completion];
}
    
- (NSProgress *)downloadFileWithURL:(NSURL * _Nullable)url ignoreCache:(BOOL)ignoreCache
                         completion:(void(^)(NSURLResponse * _Nullable response, NSURL * _Nullable filePath, NSError * _Nullable error))completion {

    url = [self URLByApplyingOverrideDomain:url];
    NSString *uniqueComponent = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *fileExt = (url.pathExtension.length > 0) ? url.pathExtension : @"tmp";
    NSURL *tempFileContentURL = [[[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:uniqueComponent] URLByAppendingPathExtension:fileExt];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    if (ignoreCache) {
        request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    }
    
    NSURLSessionDownloadTask *downloadTask = [self.httpManager downloadTaskWithRequest:[request copy]
                                                                              progress:nil
                                                                           destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                                                               return tempFileContentURL;
                                                                           } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                                                               GfySafeExecute(completion, response, filePath, error);
                                                                           }];
    [downloadTask resume];
    return [self.httpManager downloadProgressForTask:downloadTask];
}

- (void)likeMedia:(NSString *)mediaId forTag:(nullable NSString *)tag withSuccess:(GfycatResponseBlock)success failure:(nullable GfycatFailureBlock)failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                    @"value" : @"1",
                                                                                    }];
    if (tag) {
        params[@"tag"] = tag;
    }
    
    NSString *putPath = [self.gfycatApiKitBaseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"/me/gfycats/%@/like", mediaId]].absoluteString;
    [self putPath:putPath parameters:params success:^(NSDictionary * _Nonnull serverResponse) {
        GfySafeExecute(success, serverResponse);
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

- (void)dislikeMedia:(NSString *)mediaId forTag:(nullable NSString *)tag withSuccess:(GfycatResponseBlock)success failure:(nullable GfycatFailureBlock)failure {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                    @"value" : @"1",
                                                                                    }];
    if (tag) {
        params[@"tag"] = tag;
    }
    
    NSString *putPath = [self.gfycatApiKitBaseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"/me/gfycats/%@/dislike", mediaId]].absoluteString;
    [self putPath:putPath parameters:params success:^(NSDictionary * _Nonnull serverResponse) {
        GfySafeExecute(success, serverResponse);
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

#pragma mark - Users -


#pragma mark - Pagination -

- (void)getPaginatedItemsForInfo:(GfycatPaginationInfo *)paginationInfo
                     withSuccess:(GfycatPaginatiedResponseBlock)success
                         failure:(nullable GfycatFailureBlock)failure {
    
    [self getPaginatedPath:paginationInfo.path
                parameters:paginationInfo.parameters
             responseModel:paginationInfo.type
                   success:success
                   failure:failure];
}

#pragma mark - Upload -
- (void)createGfycatWithParameters:(nullable NSDictionary *)parameters
                           success:(GfycatUploadKeyBlock)success
                           failure:(nullable GfycatFailureBlock)failure {
    
    __weak __typeof(self) weakSelf = self;
    [self refreshSession:^(NSDictionary *serverResponse) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSString *postPath = [strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:@"gfycats"].absoluteString;
        [strongSelf postPath:postPath
            parameters:parameters
               success:^(NSDictionary *response) {
                   GfycatUploadKey *uploadKey = GfyNotNull(response) ? [[GfycatUploadKey alloc] initWithInfo:response] : nil;
                   GfySafeExecute(success, uploadKey);
               } failure:^(NSError *error, NSInteger serverStatusCode) {
                   GfySafeExecute(failure, error, serverStatusCode);
               }];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

NSString *const kFileDropEndpointPath = @"https://filedrop.gfycat.com/%@";
- (void)uploadFileUrl:(NSURL *)fileUrl
         forUploadKey:(GfycatUploadKey *)uploadKey
              success:(GfycatSuccessBlock)success
             progress:(nullable GfycatProgressBlock)progress
              failure:(nullable GfycatFailureBlock)failure {
    
    NSString *urlString = [NSString stringWithFormat:kFileDropEndpointPath, uploadKey.gfyId];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"PUT";
    [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *task = [self.httpUploadManager uploadTaskWithRequest:request fromFile:fileUrl progress:nil
                                                             completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                                 if (error) {
                                                                     if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                                                         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                                         GfySafeExecute(failure, error,httpResponse.statusCode);
                                                                     } else {
                                                                         GfySafeExecute(failure, error,0);
                                                                     }
                                                                 } else {
                                                                     GfySafeExecute(success);
                                                                 }
                                                             }];
    
    [task resume];
}

- (void)deleteGfycatWithParameters:(nullable NSDictionary *)parameters
                           success:(GfycatUploadKeyBlock)success
                           failure:(nullable GfycatFailureBlock)failure {
    
    // TODO: implement deletion
    NSAssert(NO, @"Not implemented");
}
         
- (void)deleteGfycatMedia:(NSString *)mediaId withSuccess:(GfycatResponseBlock)success failure:(nullable GfycatFailureBlock)failure {
    
    NSParameterAssert(mediaId);
    
    __weak __typeof(self) weakSelf = self;
    [self refreshSession:^(NSDictionary * _Nonnull serverResponse) {
         __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSString *deletePath = [strongSelf.gfycatApiKitBaseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"me/gfycats/%@", mediaId]].absoluteString;
        [strongSelf deletePath:deletePath parameters:@{} success:^(NSDictionary * _Nonnull serverResponse) {
            GfySafeExecute(success, serverResponse);
        } failure:failure];
    } failure:failure];
}

// TODO - determine if this should go into a utility class
#pragma mark - Utilities -

- (GfycatCategories *)categoriesByApplyingConfigurations:(NSArray<GfycatConfigurationObject *> *)configurationsArray toCategories:(GfycatCategories *)categories {
    if (configurationsArray.count == 0) {
        return categories;
    }
    
    NSMutableArray<GfycatCategory *> *retCetegories = [@[] mutableCopy];
    NSMutableDictionary<NSString *, GfycatConfigurationObject *> *configIndex = [@{} mutableCopy];
    
    for (GfycatConfigurationObject *configObject in configurationsArray) {
        configIndex[configObject.title.lowercaseString] = configObject;
    }
    
    NSMutableDictionary<NSNumber *, NSMutableArray<GfycatCategory *> *> *categoriesPriorityIndex = [@{} mutableCopy];
    
    for (GfycatCategory *category in categories.array) {
        GfycatConfigurationObject *indexedConfig = configIndex[category.title.lowercaseString];
        
        if (indexedConfig.hidden.boolValue) {
            continue;
        }
        
        NSNumber *priority = indexedConfig ? indexedConfig.priority : @(0);
        NSMutableArray *categoriesForCurrentPriority = categoriesPriorityIndex[priority];
        
        if (categoriesForCurrentPriority != nil) {
            [categoriesForCurrentPriority addObject:category];
        } else {
            categoriesPriorityIndex[priority] = [@[category] mutableCopy];
        }
    }
    
    NSArray<NSNumber *> *sortedPriorities = [categoriesPriorityIndex.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        return obj1.longValue < obj2.longValue;
    }];
    
    for (NSNumber *priority in sortedPriorities) {
        NSArray<GfycatCategory *> *categories = categoriesPriorityIndex[priority];
        [retCetegories addObjectsFromArray:categories];
    }
    
    return [[GfycatCategories alloc] initWithArray:retCetegories];
}

- (NSString *)currentLanguageCode {
    
    if ([NSLocale preferredLanguages].count) {
        NSString *lang = [[NSLocale preferredLanguages] firstObject];
        NSMutableArray<NSString *> *components = [[lang componentsSeparatedByString:@"-"] mutableCopy];
        if (components.count > 1) {
            [components removeLastObject];
        }
        NSString *resultLang = [components componentsJoinedByString:@"-"];
        if ([resultLang isEqualToString:@"zh-Hant"]) {
            resultLang = @"zh-TW";
        } else if ([resultLang isEqualToString:@"zh-Hans"]) {
            resultLang = @"zh-CN";
        }
        return resultLang;
    }

    if ([NSLocale currentLocale].languageCode.length) {
        return [NSLocale currentLocale].languageCode;
    }

    return @"en";
}

- (NSURL *)gfycatApiKitBaseURL
{
    return [self URLByApplyingOverrideDomain: _baseURL ?: [NSURL URLWithString:kGfycatApiKitBaseURL]];
}

- (NSURL *)authorizationEndpointURL
{
    return [self.gfycatApiKitBaseURL URLByAppendingPathComponent:@"oauth/token/"];
}

@end

@implementation GfycatApi(NSURLExtensions)

- (NSURL *)URLByApplyingOverrideDomain:(NSURL *)url
{
    if (_overrideDomain == nil || url == nil) {
        return url;
    }
    
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
    components.host = [components.host.lowercaseString stringByReplacingOccurrencesOfString:kGfycatApiKitDefaultDomain withString:self->_overrideDomain];
    components.port = self->_overridePort;
    return components.URL;
}

@end

NS_ASSUME_NONNULL_END
