//
//  GfycatCategory.m
//  GfycatApiKit
//
//  Created by Gfycat on 2/9/17.
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

#import "GfycatCategory.h"
#import "GfycatModelConstants.h"
#import "GfycatApiConstants.h"

@interface GfycatCategory()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *localizedTitle;
@property (nonatomic) GfycatMedia *media;

@end

@implementation GfycatCategory

- (instancetype)initWithInfo:(NSDictionary *)info {
    self = [super init];
    if (self && GfyNotNull(info)) {
        self.title = GfyNotNull(info[kTag]) ? [[NSString alloc] initWithString:info[kTag]] : nil;
        self.localizedTitle = GfyNotNull(info[kTagText]) ? [[NSString alloc] initWithString:info[kTagText]] : nil;
        
        NSArray *gfyItem = info[kGfycats];
        self.media = [[GfycatMedia alloc] initWithInfo:gfyItem.firstObject];
    }
    return self;
}

#pragma mark - Equality

- (NSUInteger)hash {
    return self.title.hash;
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[GfycatCategory class]] && [self isEqualToCategory:object];
}

- (BOOL)isEqualToCategory:(GfycatCategory *)category {
    return ([self.title isEqualToString:category.title] &&
            [self.localizedTitle isEqualToString:category.localizedTitle] &&
            [self.media isEqual:category.media]);
}

#pragma mark - Serialization

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [self init])) {
        self.title = [decoder decodeObjectOfClass:[NSString class] forKey:kTitle];
        self.localizedTitle = [decoder decodeObjectOfClass:[NSString class] forKey:kTagText];
        self.media = [decoder decodeObjectOfClass:[GfycatMedia class] forKey:kGfycatMedia];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.title forKey:kTitle];
    [encoder encodeObject:self.localizedTitle forKey:kTagText];
    [encoder encodeObject:self.media forKey:kGfycatMedia];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    GfycatCategory *copy = [[[self class] allocWithZone:zone] init];
    
    copy->_title = [self.title copy];
    copy->_localizedTitle = [self.localizedTitle copy];
    copy->_media = [self.media copy];

    return copy;
}

@end

@interface GfycatCategories()

@property (nonatomic) NSArray<GfycatCategory *> *array;

@end

@implementation GfycatCategories

- (NSArray *)array {
    if (!_array) {
        _array = [NSArray new];
    }
    
    return _array;
}

- (instancetype)initWithArray:(NSArray<GfycatCategory *> *)array {
    if (self = [super init]) {
        self.array = [array copy];
    }
    return self;
}

- (instancetype)initWithInfo:(NSDictionary *)info {
    if (self = [super init]) {
        NSArray *categories = info[kTags];
        if (GfyNotNull(categories)) {
            NSMutableArray *array = [NSMutableArray new];
            for (NSDictionary *category in categories) {
                [array addObject:[[GfycatCategory alloc] initWithInfo:category]];
            }
            self.array = [array copy];
        }
    }
    return self;
}

#pragma mark - Equality

- (NSUInteger)hash {
    return self.array.hash;
}

- (BOOL)isEqual:(GfycatCategories *)categories {
    if (![categories isKindOfClass:[GfycatCategories class]]) {
        return NO;
    }
    return [self.array isEqual:categories.array];
}

#pragma mark - Serialization

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [self init])) {
        self.array = [decoder decodeObjectOfClass:[NSString class] forKey:kGfycatCategories];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.array forKey:kGfycatCategories];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    GfycatCategories *copy = [[[self class] allocWithZone:zone] init];
    
    copy->_array = [self.array copy];
    
    return copy;
}

@end
