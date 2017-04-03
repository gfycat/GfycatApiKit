//
//  GfycatUploadKey.h
//  GfycatApiKit
//
//  Created by Gfycat on 3/14/17.
//  Copyright © 2017 Gfycat. All rights reserved.
//

#import <GfycatApiKit/GfycatApiKit.h>

@interface GfycatUploadKey : GfycatModel <NSCopying, NSSecureCoding, NSObject>

/**
 *  Secret key used for deletion later if the Gfycat was created anonymously
 */
@property (nonatomic, readonly) NSString *secret;

/**
 *  Initializes a new instance.
 *  @param info JSON dictionary
 */
- (instancetype)initWithInfo:(NSDictionary *)info;

@end
