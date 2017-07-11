//
//  GfycatConfigurationObject.h
//  GfycatApiKit
//
//  Created by Voytenko Oleksiy on 6/21/17.
//  Copyright © 2017 Gfycat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GfycatConfigurationObject : NSObject

@property (strong, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) NSNumber *priority;
@property (strong, nonatomic, readonly) NSNumber *hidden;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
