//
//  GfycatUploadKey.m
//  GfycatApiKit
//
//  Created by Yin Zhu on 3/14/17.
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

#import "GfycatUploadKey.h"
#import "GfycatModelConstants.h"
#import "GfycatApiConstants.h"

@interface GfycatUploadKey ()

@property (nonatomic, copy) NSString *secret;

@end

@implementation GfycatUploadKey

- (instancetype)initWithInfo:(NSDictionary *)info {
    NSString *gfycatUploadName = GfyNotNull(info[kGfycatUploadName]) ? [[NSString alloc] initWithString:info[kGfycatUploadName]] : @"";
    NSDictionary *dictionary = @{kGfyId:gfycatUploadName};
    
    self = [super initWithInfo:dictionary];
    if (self && GfyNotNull(info)) {
        self.secret = GfyNotNull(info[kGfycatUploadSecret]) ? [[NSString alloc] initWithString:info[kGfycatUploadSecret]] : nil;
    }
    return self;
}

#pragma mark - Equality

- (BOOL)isEqualToModel:(GfycatUploadKey *)uploadKey {
    return [super isEqualToModel:uploadKey] && [self.secret isEqualToString:uploadKey.secret];
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super initWithCoder:decoder])) {
        self.secret = [decoder decodeObjectOfClass:[NSString class] forKey:kGfycatUploadSecret];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:self.secret forKey:kGfycatUploadSecret];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    GfycatUploadKey *copy = [super copyWithZone:zone];
    
    copy->_secret = [self.secret copy];
    
    return copy;
}

@end


