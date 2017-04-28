//
//  GfycatEventTracker.h
//  GfycatApiKit
//
//  Created by Victor Pavlychko on 3/31/17.
//  Copyright © 2017 GfyCat. All rights reserved.
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

#import <Foundation/Foundation.h>

@interface GfycatEventTracker : NSObject

@property (class, nonatomic, readonly) GfycatEventTracker *impressionsTracker;
@property (class, nonatomic, readonly) GfycatEventTracker *analyticsTracker;

+ (instancetype)trackerWithBaseURL:(NSURL *)baseURL;
- (instancetype)initWithBaseURL:(NSURL *)baseURL;

- (void)trackEvent:(NSString *)name withParameters:(NSDictionary<NSString *, id> *)parameters;

@end
