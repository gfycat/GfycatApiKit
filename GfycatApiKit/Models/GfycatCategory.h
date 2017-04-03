//
//  GfycatCategory.h
//  GfycatApiKit
//
//  Created by Gfycat on 2/9/17.
//  Copyright © 2017 Gfycat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GfycatMedia.h"

NS_ASSUME_NONNULL_BEGIN

@interface GfycatCategory : NSObject <NSCopying, NSSecureCoding>

/**
 *  Title of the Category.
 */
@property (nonatomic, readonly, copy) NSString *title;

/**
 *  Localized Title of the Category.
 */
@property (nonatomic, readonly, copy) NSString *localizedTitle;

/**
 *  Representative media of the Category
 */
@property (nonatomic, readonly, nullable) GfycatMedia *media;

/**
 *  Initializes a new instance.
 *  @param info JSON dictionary.
 */
- (instancetype)initWithInfo:(NSDictionary *)info;

/**
 *  Comparing Gfycat category objects.
 *  @param category a category object.
 *  @return YES if title and representative media match. Else NO.
 */
- (BOOL)isEqualToCategory:(nullable GfycatCategory *)category;

@end

@interface GfycatCategories : NSObject <NSCopying, NSSecureCoding>

/**
 *  An array of GfycatCategory objects.
 */
@property (nonatomic, readonly) NSArray<GfycatCategory *> *array;

/**
 *  Initializes a new instance.
 *  @array Array of GfycatCategory objects.
 */
- (instancetype)initWithArray:(NSArray<GfycatCategory *> *)array;

/**
 *  Initializes a new instance.
 *  @param info JSON dictionary.
 */
- (instancetype)initWithInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
