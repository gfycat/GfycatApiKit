//
//  NSDictionary+Gfycat.m
//  GfycatApiKit
//
//  Created by Andrii Novoselskyi on 6/9/17.
//  Copyright © 2017 Gfycat. All rights reserved.
//

#import "NSDictionary+Gfycat.h"

@implementation NSDictionary (Gfycat)

- (nullable NSNumber *)gfy_numberValueForKey:(NSString *)key
{
    id value = self[key];
    if (!value || [value isEqual:[NSNull null]] || [value isEqual:@"<null>"]) {
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
    if (!value || [value isEqual:[NSNull null]] || [value isEqual:@"<null>"]) {
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
    if (!value || [value isEqual:[NSNull null]] || [value isEqual:@"<null>"]) {
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
    if (!value || [value isEqual:[NSNull null]] || [value isEqual:@"<null>"]) {
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
    if (!value || [value isEqual:[NSNull null]] || [value isEqual:@"<null>"]) {
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
    if (!value || [value isEqual:[NSNull null]] || [value isEqual:@"<null>"]) {
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
    if (!value || [value isEqual:[NSNull null]] || [value isEqual:@"<null>"]) {
        return 0;
    }
    
    if (![value isKindOfClass:[NSNumber class]]) {
        return 0;
    }
    
    return [value integerValue];
}

- (BOOL)gfy_boolValueForKey:(NSString *)key
{
    id value = self[key];
    if (!value || [value isEqual:[NSNull null]] || [value isEqual:@"<null>"]) {
        return NO;
    }
    
    if (![value isKindOfClass:[NSNumber class]]) {
        return NO;
    }
    
    return [value boolValue];
}

@end
