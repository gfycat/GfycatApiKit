//
//  NSDictionary+Gfycat.h
//  GfycatApiKit
//
//  Created by Andrii Novoselskyi on 6/9/17.
//  Copyright © 2017 Gfycat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Gfycat)

- (nullable NSNumber *)gfy_numberValueForKey:(NSString *)key;
- (nullable NSString *)gfy_stringValueForKey:(NSString *)key;
- (nullable NSURL *)gfy_urlValueForKey:(NSString *)key;
- (nullable NSDate *)gfy_dateValueForKey:(NSString *)key;
- (nullable NSArray *)gfy_arrayValueForKey:(NSString *)key;
- (nullable NSDictionary *)gfy_dictionaryValueForKey:(NSString *)key;

- (NSInteger)gfy_integerValueForKey:(NSString *)key;
- (BOOL)gfy_boolValueForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
