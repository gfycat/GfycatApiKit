//
//  NSDictionary+GfycatApiKit.m
//  GfycatApiKit
//
//  Created by Andrii Novoselskyi on 6/9/17.
//  Copyright © 2017 Gfycat. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "NSDictionary+GfycatApiKit.h"

@implementation NSDictionary (GfycatApiKit)

- (nullable NSNumber *)gfy_numberValueForKey:(NSString *)key
{
    id value = self[key];
    if (!value || value == [NSNull null] || [value isEqual:@"<null>"]) {
        return nil;
    }
    
    if (![value isKindOfClass:[NSNumber class]]) {
        return nil;
    }
    
    return value;
}

- (nullable NSString *)gfy_stringValueForKey:(NSString *)key
{
    id value = self[key];
    if (!value || value == [NSNull null] || [value isEqual:@"<null>"]) {
        return nil;
    }
    
    if (![value isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    return value;
}

- (nullable NSURL *)gfy_urlValueForKey:(NSString *)key
{
    id value = self[key];
    if (!value || value == [NSNull null] || [value isEqual:@"<null>"]) {
        return nil;
    }
    
    if (![value isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    return [NSURL URLWithString:value];
}

- (nullable NSDate *)gfy_dateValueForKey:(NSString *)key
{
    id value = self[key];
    if (!value || value == [NSNull null] || [value isEqual:@"<null>"]) {
        return nil;
    }
    
    if (![value isKindOfClass:[NSNumber class]]) {
        return nil;
    }
    
    return [[NSDate alloc] initWithTimeIntervalSince1970:[value doubleValue]];
}

- (nullable NSArray *)gfy_arrayValueForKey:(NSString *)key
{
    id value = self[key];
    if (!value || value == [NSNull null] || [value isEqual:@"<null>"]) {
        return nil;
    }
    
    if (![value isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    return value;
}

- (nullable NSDictionary *)gfy_dictionaryValueForKey:(NSString *)key
{
    id value = self[key];
    if (!value || value == [NSNull null] || [value isEqual:@"<null>"]) {
        return nil;
    }
    
    if (![value isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    return value;
}

- (NSInteger)gfy_integerValueForKey:(NSString *)key
{
    id value = self[key];
    if (!value || value == [NSNull null] || [value isEqual:@"<null>"]) {
        return 0;
    }
    
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value integerValue];
    }
    
    return 0;
}

- (BOOL)gfy_boolValueForKey:(NSString *)key
{
    id value = self[key];
    if (!value || value == [NSNull null] || [value isEqual:@"<null>"]) {
        return NO;
    }
    
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value boolValue];
    }
    
    return NO;
}

@end
