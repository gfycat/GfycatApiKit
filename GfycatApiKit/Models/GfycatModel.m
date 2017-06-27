//
//  GfycatModel.m
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

#import "GfycatModel.h"
#import "GfycatModelConstants.h"
#import "GfycatApiConstants.h"

@interface GfycatModel ()

@property (atomic, copy) NSString *gfyId;

@end

@implementation GfycatModel

- (instancetype)initWithInfo:(NSDictionary *)info {
    self = [super init];
    if (self && GfyNotNull(info)) {
        NSDictionary *gfyItem = GfyNotNull(info[kGfyItem]) ? info[kGfyItem] : info;
        self.gfyId = [[NSString alloc] initWithString:gfyItem[kGfyId]];
    }
    return self;
}

- (instancetype)initWithGfyId:(NSString *)gfyId {
    if (self = [super init]) {
        self.gfyId = gfyId;
    }
    return self;
}

#pragma mark - Equality

- (NSUInteger)hash {
    return self.gfyId.hash;
}

- (BOOL)isEqual:(id)object {
    return (self == object) || ([self class] == [object class] && [self isEqualToModel:object]);
}

- (BOOL)isEqualToModel:(GfycatModel *)model {
    return [self.gfyId isEqualToString:model.gfyId];
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [self init])) {
        self.gfyId = [decoder decodeObjectOfClass:[NSString class] forKey:kGfyId];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.gfyId forKey:kGfyId];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    GfycatModel *copy = [[[self class] allocWithZone:zone] init];
    copy->_gfyId = [self.gfyId copy];
    return copy;
}

@end
