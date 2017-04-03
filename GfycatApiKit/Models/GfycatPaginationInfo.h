//
//  GfycatPaginationInfo.h
//  GfycatApiKit
//
//  Created by Yin Zhu on 1/27/17.
//  Copyright © 2017 Gfycat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GfycatPaginationInfo : NSObject <NSCopying, NSSecureCoding, NSObject>

/**
 *  Pagination request path
 */
@property (nonatomic, readonly) NSString *path;

/**
 *  Parameters for request.
 */
@property (nonatomic, readonly) NSDictionary *parameters;

/** 
 *  Bool if there's more pages remaining
 */
@property (nonatomic, readonly) BOOL hasMorePages;

/**
 *  Class of Objects which are being paginated.
 */
@property (nonatomic, readonly, nullable) Class type;

/**
 *  Initializes a new GfycatPaginationInfo object.
 *
 *  @param info Received JSON dictionary.
 *  @param parameters Parameters dictionary.
 *  @param type Class of Objects which are being paginated.
 */
- (instancetype)initWithInfo:(NSDictionary *)info path:(NSString *)path parameters:(NSDictionary *)parameters andObjectType:(Class)type;

/**
 *  Comparing GfycatPaginationInfo objects.
 *  @param paginationInfo   An GfycatPaginationInfo object.
 *  @return                 YES is nextURLs match. Else NO.
 */
- (BOOL)isEqualToPaginationInfo:(GfycatPaginationInfo *)paginationInfo;

@end

NS_ASSUME_NONNULL_END
