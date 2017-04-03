//
//  GfycatPaginationInfo.m
//  GfycatApiKit
//
//  Created by Yin Zhu on 1/27/17.
//  Copyright © 2017 Gfycat. All rights reserved.
//

#import "GfycatPaginationInfo.h"
#import "GfycatModel.h"
#import "GfycatModelConstants.h"
#import "GfycatApiConstants.h"

@interface GfycatPaginationInfo ()

@property (nonatomic, copy, nullable) NSString *cursor;
@property (nonatomic, copy, nullable) NSString *digest;
@property (nonatomic, nullable) Class type;
@property (nonatomic, copy) NSString *path;
@property (nonatomic) NSDictionary *parameters;

@end

@implementation GfycatPaginationInfo

- (instancetype)initWithInfo:(NSDictionary *)info path:(NSString *)path parameters:(NSDictionary *)parameters andObjectType:(Class)type {
    self = [super init];
    BOOL infoExists = GfyNotNull(info) && GfyNotNull(info[kCursor]);
    if (self && infoExists){
        self.cursor = info[kCursor];
        self.digest = info[kDigest];

        NSMutableDictionary *dictionary = [NSMutableDictionary new];
        if GfyNotNull(parameters) {
            dictionary = [parameters mutableCopy];
        }
        if (GfyNotNull(self.digest) && [self.digest length] > 0) {
            dictionary[kDigest] = self.digest;
        } else {
            [dictionary removeObjectForKey:kDigest];
        }
        if (GfyNotNull(self.cursor) && [self.cursor length] > 0) {
            dictionary[kCursor] = self.cursor;
        } else {
            [dictionary removeObjectForKey:kCursor];
        }
        self.parameters = [dictionary copy];
        
        if (type) {
            self.type = type;
        }
        self.path = path;
        
        return self;
    }
    return nil;
}

- (BOOL)hasMorePages {
    return (GfyNotNull(self.cursor) && [self.cursor length] > 0);
}

#pragma mark - Equality

- (BOOL)isEqualToPaginationInfo:(GfycatPaginationInfo *)paginationInfo {
    
    if (self == paginationInfo) {
        return YES;
    }
   
    // TODO - is this method even nessasary?
    return (self.cursor == paginationInfo.cursor &&
            self.type == paginationInfo.type &&
            self.path == paginationInfo.path &&
            self.parameters == paginationInfo.parameters);
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [self init])) {
        self.cursor = [decoder decodeObjectOfClass:[NSString class] forKey:kPaginationCursor];
        self.type = NSClassFromString([decoder decodeObjectOfClass:[NSString class] forKey:kPaginationType]);
        self.path = [decoder decodeObjectOfClass:[NSString class] forKey:kPaginationPath];
        self.parameters = [decoder decodeObjectOfClass:[NSDictionary class] forKey:kPaginationParameters];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.cursor forKey:kPaginationCursor];
    [encoder encodeObject:NSStringFromClass(self.type) forKey:kPaginationType];
    [encoder encodeObject:self.path forKey:kPaginationPath];
    [encoder encodeObject:self.parameters forKey:kPaginationParameters];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    GfycatPaginationInfo *copy = [[GfycatPaginationInfo allocWithZone:zone] init];
    copy->_cursor = [self.cursor copy];
    copy->_type = [self.type copy];
    copy->_path = [self.path copy];
    copy->_parameters = [self.parameters copy];
    return copy;
}

@end

