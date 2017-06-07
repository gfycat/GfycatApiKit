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
#import "GfycatPaginationInfo.h"
#import "GfycatUploadKey.h"
#import <AFNetworking/AFNetworking.h>
#import <UICKeyChainStore/UICKeyChainStore.h>

NS_ASSUME_NONNULL_BEGIN

NSString *const kKeychainUsernameKey = @"username";
NSString *const kKeychainPasswordKey = @"password";

NSString *const kKeychainAccessTokenKey = @"accessToken";
NSString *const kKeychainAccessTokenExpirationDateKey = @"tokenExpirationDate";
NSString *const kKeychainRefreshTokenKey = @"refreshToken";
NSString *const kKeychainRefreshTokenExpirationDateKey = @"refreshTokenExpirationDate";

@interface GfycatApi()

@property (nonatomic, copy, nonnull) NSString *appClientID;
@property (nonatomic, copy, nonnull) NSString *appClientSecret;
@property (nonatomic, strong, nonnull) AFHTTPSessionManager *httpManager;
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
        NSURL *baseURL = [NSURL URLWithString:kGfycatApiKitBaseURL];
        [self configureHTTPManagersWithBaseURL:baseURL];
        [self configureCredentials];
    }
    
    return self;
}

- (void)configureHTTPManagersWithBaseURL:(NSURL *)baseURL
{
    self.httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    self.httpManager.responseSerializer = [AFJSONResponseSerializer new];
    self.httpManager.requestSerializer = [AFJSONRequestSerializer new];
    
    self.httpUploadManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    self.httpUploadManager.responseSerializer = [AFHTTPResponseSerializer new];
    self.httpUploadManager.requestSerializer = [AFHTTPRequestSerializer new];
}

- (void)configureCredentials
{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    
    self.appClientID = info[kGfycatAppClientIdConfigurationKey];
    self.appClientSecret = info[kGfycatAppClientSecretConfigurationKey];
    self.keychainStore = [UICKeyChainStore keyChainStoreWithService:GfycatApiKitKeychainStore];
    self.accessToken = self.keychainStore[kKeychainAccessTokenKey];
    self.sharedContainerIdentifier = info[kGfycatApiKitSharedContainerIdentifierConfigurationKey];
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
    [self configureHTTPManagersWithBaseURL:baseURL];
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
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                        @"username" : username,
                                                                                        @"password" : password
                                                                                        }];
        if (email) {
            params[@"email"] = email;
        }
        
        [strongSelf postPath:[kGfycatApiKitBaseURL stringByAppendingString:@"/users"] parameters:params success:^(NSDictionary *response) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            
            [strongSelf saveCredentialsForResponse:response];
            strongSelf.username = username;
            strongSelf.password = password;
            
            GfySafeExecute(success, response);
        } failure:^(NSError *error, NSInteger serverStatusCode) {
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

NSString *const kAuthorizationEndpoint = @"/oauth/token/"; // TODO - Need to standardize how endpoints are specified
- (void)validateSession:(GfycatResponseBlock)success
                failure:(nullable GfycatFailureBlock)failure {
    
    self.accessToken = nil;
    
    NSDictionary *params = @{ kKeyGrantType: @"client_credentials"};
    
    __weak __typeof(self) weakSelf = self;
    [self postPath:[kGfycatApiKitBaseURL stringByAppendingString:kAuthorizationEndpoint]
        parameters:params
           success:^(NSDictionary *response) {
               __strong __typeof(weakSelf) strongSelf = weakSelf;
               
               NSDictionary *modelDictionary = response;
               strongSelf.accessToken = modelDictionary[kKeyAccessToken];
               NSNumber *tokenExpirationInterval = modelDictionary[kKeyAccessTokenExpiration];
               strongSelf.accessTokenExpirationDate = GfyNotNull(tokenExpirationInterval) ? [NSDate dateWithTimeIntervalSinceNow:tokenExpirationInterval.integerValue] : [NSDate date];
               GfySafeExecute(success, response);
           } failure:^(NSError *error, NSInteger serverStatusCode) {
               GfySafeExecute(failure, error, serverStatusCode);
           }];
}

NSInteger const kTokenExpirationThreshold = 30;
- (void)refreshSession:(GfycatResponseBlock)success
               failure:(nullable GfycatFailureBlock)failure {
    
    __weak __typeof(self) weakSelf = self;
    dispatch_async(self.authenticationQueue, ^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        if ([strongSelf isSessionValid]) {
            NSDictionary *modelDictionary = @{
                                              kKeyAccessToken : strongSelf.accessToken,
                                              kKeyAccessTokenExpiration : @([strongSelf.accessTokenExpirationDate timeIntervalSinceNow])
                                              };
                GfySafeExecute(success, modelDictionary);
        } else if (strongSelf.refreshToken && strongSelf.refreshTokenExpirationDate && [strongSelf.refreshTokenExpirationDate timeIntervalSinceNow] > kTokenExpirationThreshold) {
            strongSelf.accessToken = nil;
            
            NSDictionary *params = @{
                                     kKeyRefreshToken : strongSelf.refreshToken,
                                     kKeyGrantType : @"refresh"
                                     };
            strongSelf.refreshToken = nil; // Refresh tokens can only be used once
            
            [strongSelf postPath:[kGfycatApiKitBaseURL stringByAppendingString:kAuthorizationEndpoint]
                    parameters:params
                       success:^(NSDictionary *response) {
                           __strong __typeof(weakSelf) strongSelf = weakSelf;
                           
                           NSDictionary *modelDictionary = response;
                           strongSelf.accessToken = modelDictionary[kKeyAccessToken];
                           NSNumber *tokenExpirationInterval = modelDictionary[kKeyAccessTokenExpiration];
                           strongSelf.accessTokenExpirationDate = GfyNotNull(tokenExpirationInterval) ? [NSDate dateWithTimeIntervalSinceNow:tokenExpirationInterval.integerValue] : [NSDate date];
                           GfySafeExecute(success, response);
                       } failure:^(NSError *error, NSInteger serverStatusCode) {
                           // The refresh token didn't work for some reason, we'll just try to refresh again
                           // with the other options.
                           [weakSelf refreshSession:success failure:failure];
                       }];
        } else if (strongSelf.username && strongSelf.password) {
            strongSelf.accessToken = nil;
            
            NSDictionary *params = @{
                                     kKeyUsername : strongSelf.username,
                                     kKeyPassword : strongSelf.password,
                                     kKeyGrantType : @"password"
                                     };
            [strongSelf postPath:[kGfycatApiKitBaseURL stringByAppendingString:kAuthorizationEndpoint]
                    parameters:params
                       success:^(NSDictionary *response) {
                           [weakSelf saveCredentialsForResponse:response];
                           GfySafeExecute(success, response);
                       } failure:^(NSError *error, NSInteger serverStatusCode) {
                           GfySafeExecute(failure, error, serverStatusCode);
                       }];
        } else {
            [strongSelf validateSession:success failure:failure];
        }
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
    
    self.accessToken = nil;
    self.username = nil;
    self.password = nil;
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
                      GfySafeExecute(failure, error, ((NSHTTPURLResponse *)[task response]).statusCode);
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
                      
                      GfySafeExecute(success, modelObject, paginationInfo);
                  }
                  failure:^(NSURLSessionDataTask *task, NSError *error) {
                      GfySafeExecute(failure, error, ((NSHTTPURLResponse *)[task response]).statusCode);
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
                       GfySafeExecute(failure, error,((NSHTTPURLResponse*)[task response]).statusCode);
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
                         GfySafeExecute(failure, error,((NSHTTPURLResponse*)[task response]).statusCode);
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
                      GfySafeExecute(failure, error,((NSHTTPURLResponse*)[task response]).statusCode);
                  }];
    
}


#pragma mark - Media -


- (void)getMedia:(NSString *)mediaId
     withSuccess:(GfycatMediaObjectBlock)success
         failure:(nullable GfycatFailureBlock)failure {
    
    __weak __typeof(self) weakSelf = self;
    [self refreshSession:^(NSDictionary *serverResponse) {
        [weakSelf getPath:[kGfycatApiKitBaseURL stringByAppendingFormat:@"/gfycats/%@", mediaId]
               parameters:@{}
            responseModel:[GfycatMedia class]
                  success:success
                  failure:failure];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

- (void)getExtendedMedia:(NSString *)mediaId withSuccess:(GfycatExtendedMediaObjectBlock)success failure:(nullable GfycatFailureBlock)failure {
    __weak __typeof(self) weakSelf = self;
    [self refreshSession:^(NSDictionary *serverResponse) {
        [weakSelf getPath:[kGfycatApiKitBaseURL stringByAppendingFormat:@"/me/gfycats/%@/full", mediaId]
               parameters:@{}
            responseModel:[GfycatExtendedMedia class]
                  success:success
                  failure:failure];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

- (void)getCategoriesWithSuccess:(GfycatCategoryArrayBlock)success
                         failure:(nullable GfycatFailureBlock)failure {
    
    __weak __typeof(self) weakSelf = self;
    [self refreshSession:^(NSDictionary *serverResponse) {
        [weakSelf getPaginatedPath:[kGfycatApiKitBaseURL stringByAppendingString:@"/reactions/populated"]
                    parameters:@{kLocale : [self currentLanguageCode]}
                 responseModel:[GfycatCategories class]
                       success:success
                       failure:failure];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

- (void)getCategoryMedia:(NSString *)categoryTitle
                   count:(NSInteger)count
             WithSuccess:(GfycatMediaBlock)success
                 failure:(nullable GfycatFailureBlock)failure {
    
    __weak __typeof(self) weakSelf = self;
    [self refreshSession:^(NSDictionary *serverResponse) {
        [weakSelf getPaginatedPath:[kGfycatApiKitBaseURL stringByAppendingString:@"/reactions/populated"]
                    parameters:@{
                                 kTagName : categoryTitle,
                                 @"gfyCount" : @(count)
                                 }
                 responseModel:[GfycatMediaCollection class]
                       success:success
                       failure:failure];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

- (void)searchMediaWithString:(NSString *)searchString
                        count:(NSInteger)count
                  withSuccess:(GfycatMediaBlock)success
                      failure:(nullable GfycatFailureBlock)failure {
    
    __weak __typeof(self) weakSelf = self;
    [self refreshSession:^(NSDictionary *serverResponse) {
        [weakSelf getPaginatedPath:[kGfycatApiKitBaseURL stringByAppendingString:@"/gfycats/search"]
                    parameters:@{
                                 @"search_text" : searchString,
                                 @"count" : @(count)
                                 }
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
        [weakSelf postPath:[kGfycatApiKitBaseURL stringByAppendingFormat:@"/gfycats/%@/report-content", mediaId]
                parameters:@{}
                   success:success
                   failure:failure];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

- (NSProgress *)downloadFileWithURL:(NSURL * _Nullable)url
                         completion:(void(^)(NSURLResponse * _Nullable response, NSURL * _Nullable filePath, NSError * _Nullable error))completion {
    
    NSString *uniqueComponent = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *fileExt = (url.pathExtension.length > 0) ? url.pathExtension : @"tmp";
    NSURL *tempFileContentURL = [[[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:uniqueComponent] URLByAppendingPathExtension:fileExt];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *downloadTask = [self.httpManager downloadTaskWithRequest:request
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
    __weak __typeof(self) weakSelf = self;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                    @"value" : @"1",
                                                                                    }];
    if (tag) {
        params[@"tag"] = tag;
    }
    
    [weakSelf putPath:[kGfycatApiKitBaseURL stringByAppendingFormat:@"/me/gfycats/%@/like", mediaId] parameters:params success:^(NSDictionary * _Nonnull serverResponse) {
        GfySafeExecute(success, serverResponse);
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        GfySafeExecute(failure, error, serverStatusCode);
    }];
}

- (void)dislikeMedia:(NSString *)mediaId forTag:(nullable NSString *)tag withSuccess:(GfycatResponseBlock)success failure:(nullable GfycatFailureBlock)failure {
    __weak __typeof(self) weakSelf = self;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                    @"value" : @"1",
                                                                                    }];
    if (tag) {
        params[@"tag"] = tag;
    }
    
    [weakSelf putPath:[kGfycatApiKitBaseURL stringByAppendingFormat:@"/me/gfycats/%@/dislike", mediaId] parameters:params success:^(NSDictionary * _Nonnull serverResponse) {
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
        [weakSelf postPath:[kGfycatApiKitBaseURL stringByAppendingString:@"/gfycats"]
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

- (void)uploadFileUrl:(NSURL *)fileUrl
         forUploadKey:(GfycatUploadKey *)uploadKey
              success:(GfycatSuccessBlock)success
             progress:(nullable GfycatProgressBlock)progress
              failure:(nullable GfycatFailureBlock)failure {
    
    NSError *error;
    NSString *urlString = [NSString stringWithFormat:@"https://filedrop.gfycat.com/%@", uploadKey.gfyId];
    NSURLRequest *request = [self.httpUploadManager.requestSerializer multipartFormRequestWithMethod:@"PUT" URLString:urlString parameters:nil
                             constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                 [formData appendPartWithFileURL:fileUrl name:uploadKey.gfyId error:nil];
                             } error:&error];
    
    NSURLSessionDataTask *task = [self.httpUploadManager dataTaskWithRequest:request uploadProgress:progress downloadProgress:nil
                                  completionHandler:^(NSURLResponse * response, id responseObject, NSError * error) {
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

// TODO - determine if this should go into a utility class
#pragma mark - Utilities -

- (NSString *)currentLanguageCode {
    
    if ([[NSLocale currentLocale] respondsToSelector:@selector(languageCode)]) {
        if ([NSLocale currentLocale].languageCode.length && [NSLocale currentLocale].scriptCode.length) {
            return [NSString stringWithFormat:@"%@-%@", [NSLocale currentLocale].languageCode, [NSLocale currentLocale].scriptCode];
        }
        
        if ([NSLocale currentLocale].languageCode.length) {
            return [NSLocale currentLocale].languageCode;
        }
    } else {
        if ([NSLocale preferredLanguages].count) {
            return [[NSLocale preferredLanguages] firstObject];
        }
    }
    
    return @"en";
}

@end

NS_ASSUME_NONNULL_END
