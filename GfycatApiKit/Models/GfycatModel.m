//
//  GfycatModel.m
//  GfycatApiKit
//
//  Created by Yin Zhu on 1/23/17.
//  Copyright © 2017 Gfycat. All rights reserved.
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
