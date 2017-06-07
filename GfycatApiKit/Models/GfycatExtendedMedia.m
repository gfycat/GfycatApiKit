//
//  GfycatExtendedMedia.m
//  GfycatApiKit
//
//  Created by Andrii Novoselskyi on 6/7/17.
//  Copyright © 2017 Gfycat. All rights reserved.
//

#import "GfycatExtendedMedia.h"
#import "GfycatModelConstants.h"

@interface GfycatExtendedMedia ()

@property (nonatomic, assign) NSInteger likeState;
@property (nonatomic, assign) NSInteger bookmarkState;

@end

@implementation GfycatExtendedMedia

- (instancetype)initWithInfo:(NSDictionary *)info {
    self = [super initWithInfo:info];
    if (self && GfyNotNull(info)) {
        NSMutableDictionary *gfyItem = GfyNotNull(info[kGfyItem]) ? info[kGfyItem] : info;
        
        NSNumber *number = GfyNotNull(gfyItem[kLikeState]) ? gfyItem[kLikeState] : nil; self.likeState = number.integerValue;
        number = gfyItem[kBookmarkState]; self.bookmarkState = number.integerValue;
    }
    return self;
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super initWithCoder:decoder])) {
        self.likeState = [decoder decodeIntegerForKey:kLikeState];
        self.bookmarkState = [decoder decodeIntegerForKey:kBookmarkState];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
    
    [encoder encodeInteger:self.likeState forKey:kLikeState];
    [encoder encodeInteger:self.bookmarkState forKey:kBookmarkState];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    GfycatExtendedMedia *copy = [super copyWithZone:zone];
    
    copy->_likeState = self.likeState;
    copy->_bookmarkState = self.bookmarkState;
    
    return copy;
}

@end
