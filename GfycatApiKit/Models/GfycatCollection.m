//
//  GfycatCollection.m
//  GfycatApiKit
//
//  Created by Gfycat on 12/16/18.
//  Copyright 2018 Gfycat
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

#import "GfycatCollection.h"
#import "GfycatModelConstants.h"
#import "GfycatApiConstants.h"

@interface GfycatCollection()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *folderId;
@property (nonatomic) GfycatMedia *media;

@end

@implementation GfycatCollection

- (instancetype)initWithInfo:(NSDictionary *)info {
    self = [super init];
    if (self && GfyNotNull(info)) {
        self.title = GfyNotNull(info[kFolderName]) ? [[NSString alloc] initWithString:info[kFolderName]] : nil;
        self.folderId = GfyNotNull(info[kFolderId]) ? [[NSString alloc] initWithString:info[kFolderId]] : nil;
        
        NSDictionary *gfyItem = info[kPosterMedia];
        GfycatMedia *media = [[GfycatMedia alloc] initWithInfo:gfyItem];
        if (media.gfyId.length && media.gfyName.length && media.size.width && media.size.height) {
            self.media = media;
        } else {
            NSLog(@"GFYCAT: Skipping invalid media: '%@', gfyName = '%@', size = %@ x %@.", media.gfyId, media.gfyName, @(media.size.width), @(media.size.height));
        }
    }
    return self;
}

#pragma mark - Equality

- (NSUInteger)hash {
    return self.title.hash;
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[GfycatCollection class]] && [self isEqualToCollection:object];
}

- (BOOL)isEqualToCollection:(GfycatCollection *)collection {
    return ([self.title isEqualToString:collection.title] &&
            [self.folderId isEqualToString:collection.folderId] &&
            [self.media isEqual:collection.media]);
}

#pragma mark - Serialization

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [self init])) {
        self.title = [decoder decodeObjectOfClass:[NSString class] forKey:kTitle];
        self.folderId = [decoder decodeObjectOfClass:[NSString class] forKey:kFolderId];
        self.media = [decoder decodeObjectOfClass:[GfycatMedia class] forKey:kGfycatMedia];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.title forKey:kTitle];
    [encoder encodeObject:self.folderId forKey:kFolderId];
    [encoder encodeObject:self.media forKey:kGfycatMedia];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    GfycatCollection *copy = [[[self class] allocWithZone:zone] init];
    
    copy->_title = [self.title copy];
    copy->_folderId = [self.folderId copy];
    copy->_media = [self.media copy];

    return copy;
}

@end

@interface GfycatCollections()

@property (nonatomic) NSArray<GfycatCollection *> *array;

@end

@implementation GfycatCollections

- (NSArray *)array {
    if (!_array) {
        _array = [NSArray new];
    }
    
    return _array;
}

- (instancetype)initWithArray:(NSArray<GfycatCollection *> *)array {
    if (self = [super init]) {
        self.array = [array copy];
    }
    return self;
}

- (instancetype)initWithInfo:(NSDictionary *)info {
    if (self = [super init]) {
        NSArray *collections = info[kGfyCollections];
        if (GfyNotNull(collections)) {
            NSMutableArray *array = [NSMutableArray new];
            for (NSDictionary *collection in collections) {
                [array addObject:[[GfycatCollection alloc] initWithInfo:collection]];
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

- (BOOL)isEqual:(GfycatCollections *)collections {
    if (![collections isKindOfClass:[GfycatCollections class]]) {
        return NO;
    }
    return [self.array isEqual:collections.array];
}

#pragma mark - Serialization

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [self init])) {
        self.array = [decoder decodeObjectOfClass:[NSString class] forKey:kGfyCollections];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.array forKey:kGfyCollections];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    GfycatCollections *copy = [[[self class] allocWithZone:zone] init];
    
    copy->_array = [self.array copy];
    
    return copy;
}

@end
