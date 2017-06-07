//
//  GfycatExtendedMedia.h
//  GfycatApiKit
//
//  Created by Andrii Novoselskyi on 6/7/17.
//  Copyright © 2017 Gfycat. All rights reserved.
//

#import <GfycatApiKit/GfycatApiKit.h>

@interface GfycatExtendedMedia : GfycatMedia <NSCopying, NSSecureCoding, NSObject>

/**
 *  Like state of the Media
 */
@property (nonatomic, readonly) NSInteger likeState;

/**
 *  Bookmark state of the Media
 */
@property (nonatomic, readonly) NSInteger bookmarkState;

@end
