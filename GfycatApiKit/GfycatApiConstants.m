//
//  GfycatApiConstants.m
//  GfycatApiKit
//
//  Created by Yin Zhu on 1/23/17.
//  Copyright © 2017 Gfycat. All rights reserved.
//

#import "GfycatApiConstants.h"

NSString *const kGfycatApiKitBaseURLConfigurationKey = @"GfycatApiKitBaseUrl";
NSString *const kGfycatApiKitAuthorizationURLConfigurationKey = @"GfycatApiKitAuthorizationUrl";
NSString *const kGfycatApiKitBaseURL = @"https://api.gfycat.com/v1";
NSString *const kGfycatApiKitAuthorizationURL = @"/oauth/token";
// TODO - Add the other paths

NSString *const kGfycatAppClientIdConfigurationKey = @"GfycatApiClientId";
NSString *const kGfycatAppClientSecretConfigurationKey = @"GfycatApiClientSecret";
NSString *const kGfycatAppRedirectURLConfigurationKey = @"GfycatApiRedirectURL";

NSString *const GfycatApiKitUserAuthenticationChangedNotification = @"com.gfycatkit.token.change";
NSString *const GfycatApiKitErrorDomain = @"com.gfycatkit";
NSString *const GfycatApiKitKeychainStore = @"com.gfycatkit.secure";

NSString *const kKeyClientID = @"client_id";
NSString *const kKeyClientSecret = @"client_secret";
NSString *const kKeyGrantType = @"grant_type";
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
