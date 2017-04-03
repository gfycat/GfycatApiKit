//
//  GfycatModel.h
//  GfycatApiKit
//
//  Created by Yin Zhu on 1/23/17.
//  Copyright © 2017 Gfycat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GfycatModel : NSObject <NSCopying, NSSecureCoding, NSObject>

/**
 *  The unique identifier for each model object.
 */
@property (atomic, readonly, copy) NSString *gfyId;

/**
 *  Initializes a new instance.
 *  @param info JSON dictionary
 */
- (instancetype)initWithInfo:(NSDictionary *)info;

/**
 *  Comparing Gfycat model objects.
 *  @param model A model object.
 *  @return YES is Ids match. Else NO.
 */
- (BOOL)isEqualToModel:(nullable GfycatModel *)model;

@end

NS_ASSUME_NONNULL_END
