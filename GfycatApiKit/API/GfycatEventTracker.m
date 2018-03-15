//
//  GfycatEventTracker.m
//  GfycatApiKit
//
//  Created by Victor Pavlychko on 3/31/17.
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

#import "GfycatEventTracker.h"
#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "GfycatApi.h"

@interface GfycatEventTracker () {
    NSURL *_baseURL;
    AFURLSessionManager *_sessionManager;
}

@end

static NSString *stringValueForObject(id object) {
    if (object == [NSNull null]) {
        return @"";
    }
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    }
    if ([object respondsToSelector:@selector(stringValue)]) {
        return [object stringValue];
    }
    NSCAssert1(NO, @"[ERROR] GfycatEventTracker: '%@' can't be converted to string.", object);
    return @"";
}

@implementation GfycatEventTracker

+ (GfycatEventTracker *)impressionsTracker {
    static GfycatEventTracker *impressionsTracker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        impressionsTracker = [self trackerWithBaseURL:[GfycatApi.shared URLByApplyingOverrideDomain:[NSURL URLWithString:@"https://px.gfycat.com/pix.gif"]]];
    });
    return impressionsTracker;
}

+ (GfycatEventTracker *)analyticsTracker {
    static GfycatEventTracker *analyticsTracker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        analyticsTracker = [self trackerWithBaseURL:[GfycatApi.shared URLByApplyingOverrideDomain:[NSURL URLWithString:@"https://metrics.gfycat.com/pix.gif"]]];
    });
    return analyticsTracker;
}

+ (NSMutableDictionary<NSString *,id> *)globalParameters {
    static NSMutableDictionary<NSString *,id> *globalParameters = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *idfv = [UIDevice currentDevice].identifierForVendor.UUIDString;
        NSString *bundleIdentifier = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleIdentifierKey];
        NSString *versionString = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        NSString *buildString = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleVersionKey];
        NSString *versionAndBuildString = [NSString stringWithFormat:@"%@.%@", versionString, buildString];
        globalParameters = [@{
            @"idfa": [NSNull null],
            @"idfv": idfv ?: [NSNull null],
            @"app_id": bundleIdentifier ?: [NSNull null],
            @"ver": versionAndBuildString ?: [NSNull null],
        } mutableCopy];
    });

    return globalParameters;
}

+ (void)setIDFA:(NSString *)idfa {
    [self.globalParameters setObject:[idfa copy] ?: [NSNull null] forKey:@"idfa"];
}

+ (instancetype)trackerWithBaseURL:(NSURL *)baseURL {
    return [[self alloc] initWithBaseURL:baseURL];
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL {
    if (self = [super init]) {
        _baseURL = [baseURL copy];

        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        _sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer new];
    }
    
    return self;
}

- (void)trackEvent:(NSString *)name withParameters:(NSDictionary<NSString *, id> *)parameters {
    NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:_baseURL resolvingAgainstBaseURL:YES];

    NSMutableDictionary<NSString *, id> *aggregatedParameters = [[NSMutableDictionary alloc] init];
    [URLComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem *obj, NSUInteger idx, BOOL *stop) {
        if (obj.name && obj.value) {
            [aggregatedParameters setObject:obj.value forKey:obj.name];
        }
    }];
    
    [aggregatedParameters setObject:name forKey:@"event"];
    [aggregatedParameters addEntriesFromDictionary:[[self class] globalParameters]];
    [aggregatedParameters addEntriesFromDictionary:parameters ?: @{}];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [[NSMutableArray alloc] initWithCapacity:aggregatedParameters.count];
    [aggregatedParameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:stringValueForObject(obj)]];
    }];
    
    URLComponents.queryItems = queryItems;

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URLComponents.URL];
    request.HTTPMethod = @"POST";
    [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [NSData data];
    
    [[_sessionManager dataTaskWithRequest:[request copy] completionHandler:nil] resume];
}

@end
