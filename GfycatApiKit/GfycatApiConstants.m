//
//  GfycatApiConstants.m
//  GfycatApiKit
//
//  Created by Yin Zhu on 1/23/17.
//  Copyright 2017 Gfycat
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

#import "GfycatApiConstants.h"

NSString *const kGfycatApiKitBaseURLConfigurationKey = @"GfycatApiKitBaseUrl";
NSString *const kGfycatApiKitOverrideDomainConfigurationKey = @"GfycatApiKitOverrideDomain";
NSString *const kGfycatApiKitAuthorizationURLConfigurationKey = @"GfycatApiKitAuthorizationUrl";
NSString *const kGfycatApiKitBaseURL = @"https://api.gfycat.com/v1";
NSString *const kGfycatApiKitDefaultDomain = @"gfycat.com";
NSString *const kGfycatConfigurationReleaseFileURL = @"https://goo.gl/GE4qrj";
NSString *const kGfycatConfigurationDebugFileURL = @"https://goo.gl/VGFVDX";
NSString *const kGfycatApiKitAuthorizationURL = @"/oauth/token";
// TODO - Add the other paths

NSString *const kGfycatAppClientIdConfigurationKey = @"GfycatApiClientId";
NSString *const kGfycatAppClientSecretConfigurationKey = @"GfycatApiClientSecret";

NSString *const kGfycatCategoryManagementEnabled = @"GfycatCategoryManagementEnabled";
NSString *const kGfycatApiKitKeychainAccessGroupConfigurationKey = @"GfycatApiKitKeychainAccessGroup";
NSString *const kGfycatApiKitSharedContainerIdentifierConfigurationKey = @"GfycatApiKitSharedContainerIdentifier";

NSString *const GfycatApiKitUserAuthenticationChangedNotification = @"com.gfycatkit.token.change";
NSString *const GfycatApiKitErrorDomain = @"com.gfycatkit";
NSString *const GfycatApiKitKeychainStore = @"com.gfycatkit.secure";

NSString *const kKeyClientID = @"client_id";
NSString *const kKeyClientSecret = @"client_secret";
NSString *const kKeyGrantType = @"grant_type";
NSString *const kKeyProvider = @"provider";
NSString *const kKeyToken = @"token";
NSString *const kKeyAccessToken = @"access_token";
NSString *const kKeyAccessTokenExpiration = @"expires_in";
NSString *const kKeyRefreshToken = @"refresh_token";
NSString *const kKeyRefreshTokenExpiration = @"refresh_token_expires_in";
NSString *const kKeyAuthorization = @"Authorization";
NSString *const kKeyUsername = @"username";
NSString *const kKeyPassword = @"password";

NSString *const kPagination = @"pagination";
NSString *const kPaginationType = @"type";
NSString *const kPaginationParameters = @"parameters";
NSString *const kPaginationPath = @"path";
NSString *const kPaginationCursor = @"cursor";

NSString *const kCursor = @"cursor";
NSString *const kDigest = @"digest";
NSString *const kTagName = @"tagName";
NSString *const kLocale = @"locale";

NSString *const kNewGfycatTitle = @"title";
NSString *const kNewGfycatDescription = @"descripton";
NSString *const kNewGfycatTags = @"tags";
NSString *const kNewGfycatPrivate = @"private";
NSString *const kNewGfycatName = @"gfyname";
NSString *const kNewGfycatSecret = @"secret";
