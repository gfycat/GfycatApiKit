//
//  GfycatApiConfiguration.h
//  GfycatApiKit
//
//  Created by Voytenko Oleksiy on 5/24/17.
//  Copyright © 2017 Gfycat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GfycatApiConfiguration : NSObject

/**
 *  Redirect URL for API calls.
 */
@property (strong, nonatomic) NSURL *baseURL;

@end
