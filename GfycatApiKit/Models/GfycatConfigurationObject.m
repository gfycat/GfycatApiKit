//
//  GfycatConfigurationObject.m
//  GfycatApiKit
//
//  Created by Voytenko Oleksiy on 6/21/17.
//  Copyright © 2017 Gfycat. All rights reserved.
//

#import "GfycatConfigurationObject.h"
#import "GfycatModelConstants.h"

@interface GfycatConfigurationObject ()

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSNumber *priority;
@property (strong, nonatomic) NSNumber *hidden;

@end

@implementation GfycatConfigurationObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.title = dictionary[kTitle];
        self.priority = dictionary[kPriority];
        self.hidden = dictionary[kHidden];
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, priority = %@, hidden = %@", self.title, self.priority, self.hidden];
}

@end
