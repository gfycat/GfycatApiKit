//
//  GfycatUserProfile.m
//  GfycatApiKit
//
//  Created by Victor Pavlychko on 7/20/18.
//  Copyright © 2018 Gfycat. All rights reserved.
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

#import "GfycatUserProfile.h"
#import "GfycatModelConstants.h"
#import "GfycatApiConstants.h"
#import "NSDictionary+GfycatApiKit.h"

@interface GfycatUserProfile ()

@property (nonatomic, readwrite, copy) NSString *userid;
@property (nonatomic, readwrite, copy) NSString *username;
@property (nonatomic, readwrite, copy) NSString *descr;
@property (nonatomic, readwrite, copy) NSString *profileUrl;
@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, assign) NSInteger views;
@property (nonatomic, readwrite, assign) BOOL emailVerified;
@property (nonatomic, readwrite, copy) NSString *url;
@property (nonatomic, readwrite, copy) NSDate *createDate;
@property (nonatomic, readwrite, copy) NSString *profileImageUrl;
@property (nonatomic, readwrite, assign) BOOL verified;
@property (nonatomic, readwrite, assign) NSInteger followers;
@property (nonatomic, readwrite, assign) NSInteger following;

@end

@implementation GfycatUserProfile

- (instancetype)initWithInfo:(NSDictionary *)info {
    self = [super init];
    if (self && GfyNotNull(info)) {
        self.userid = [info gfy_stringValueForKey:@"userid"];
        self.username = [info gfy_stringValueForKey:@"username"];
        self.descr = [info gfy_stringValueForKey:@"description"];
        self.profileUrl = [info gfy_stringValueForKey:@"profileUrl"];
        self.name = [info gfy_stringValueForKey:@"name"];
        self.views = [info gfy_integerValueForKey:@"views"];
        self.emailVerified = [info gfy_boolValueForKey:@"emailVerified"];
        self.url = [info gfy_stringValueForKey:@"url"];
        self.createDate = [info gfy_dateValueForKey:@"createDate"];
        self.profileImageUrl = [info gfy_stringValueForKey:@"profileImageUrl"];
        self.verified = [info gfy_boolValueForKey:@"verified"];
        self.followers = [info gfy_integerValueForKey:@"followers"];
        self.following = [info gfy_integerValueForKey:@"following"];
    }
    return self;
}

#pragma mark - Equality

- (NSUInteger)hash {
    return self.userid.hash;
}

- (BOOL)isEqual:(id)object {
    return (self == object) || ([self class] == [object class] && [self isEqualToUserProfile:object]);
}

- (BOOL)isEqualToUserProfile:(GfycatUserProfile *)model {
    return [self.userid isEqualToString:model.userid];
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [self init])) {
        self.userid = [decoder decodeObjectOfClass:[NSString class] forKey:@"userid"];
        self.username = [decoder decodeObjectOfClass:[NSString class] forKey:@"username"];
        self.descr = [decoder decodeObjectOfClass:[NSString class] forKey:@"description"];
        self.profileUrl = [decoder decodeObjectOfClass:[NSString class] forKey:@"profileUrl"];
        self.name = [decoder decodeObjectOfClass:[NSString class] forKey:@"name"];
        self.views = [decoder decodeIntegerForKey:@"views"];
        self.emailVerified = [decoder decodeBoolForKey:@"emailVerified"];
        self.url = [decoder decodeObjectOfClass:[NSString class] forKey:@"url"];
        self.createDate = [decoder decodeObjectOfClass:[NSDate class] forKey:@"createDate"];
        self.profileImageUrl = [decoder decodeObjectOfClass:[NSString class] forKey:@"profileImageUrl"];
        self.verified = [decoder decodeBoolForKey:@"verified"];
        self.followers = [decoder decodeIntegerForKey:@"followers"];
        self.following = [decoder decodeIntegerForKey:@"following"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.userid forKey:@"userid"];
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.descr forKey:@"description"];
    [encoder encodeObject:self.profileUrl forKey:@"profileUrl"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeInteger:self.views forKey:@"views"];
    [encoder encodeBool:self.emailVerified forKey:@"emailVerified"];
    [encoder encodeObject:self.url forKey:@"url"];
    [encoder encodeObject:self.createDate forKey:@"createDate"];
    [encoder encodeObject:self.profileImageUrl forKey:@"profileImageUrl"];
    [encoder encodeBool:self.verified forKey:@"verified"];
    [encoder encodeInteger:self.followers forKey:@"followers"];
    [encoder encodeInteger:self.following forKey:@"following"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    GfycatUserProfile *copy = [[[self class] allocWithZone:zone] init];
    copy->_userid = [self.userid copy];
    copy->_username = [self.username copy];
    copy->_descr = [self.descr copy];
    copy->_profileUrl = [self.profileUrl copy];
    copy->_name = [self.name copy];
    copy->_views = self.views;
    copy->_emailVerified = self.emailVerified;
    copy->_url = [self.url copy];
    copy->_createDate = [self.createDate copy];
    copy->_profileImageUrl = [self.profileImageUrl copy];
    copy->_verified = self.verified;
    copy->_followers = self.followers;
    copy->_following = self.following;
    return copy;
}

@end
