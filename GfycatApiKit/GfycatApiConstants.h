//
//  GfycatApiConstants.h
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
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

/**
 *  Configuration Key for the Gfycat API's Base URL.
 */
extern NSString *const kGfycatApiKitBaseURLConfigurationKey;

extern NSString *const kGfycatApiKitOverrideDomainConfigurationKey;

/**
 *  Configuration Key for the Gfycat API's Authorization URL.
 */
extern NSString *const kGfycatApiKitAuthorizationURLConfigurationKey;

/**
 *  Allows to use external configuration file to manage categories. YES by default.
 */
extern NSString *const kGfycatCategoryManagementEnabled;

/**
 *  Gfycat API's Base URL.
 */
extern NSString *const kGfycatApiKitBaseURL;

/**
 * Gfycat's default domain
 */
extern NSString *const kGfycatApiKitDefaultDomain;

/**
 *  Gfycat configuration file's URL for release configuration.
 */
extern NSString *const kGfycatConfigurationReleaseFileURL;

/**
 *  Gfycat configuration file's URL for debug and TestFlight configurations.
 */
extern NSString *const kGfycatConfigurationDebugFileURL;

/**
 *  Gfycat API's Authorization URL.
 */
extern NSString *const kGfycatApiKitAuthorizationURL;

/**
 *  Configuration Key for the Client Id of your App, registered with Gfycat.
 */
extern NSString *const kGfycatAppClientIdConfigurationKey;

/**
 *  Configuration Key for the Client Secret of your App, registered with Gfycat.
 */
extern NSString *const kGfycatAppClientSecretConfigurationKey;

/**
 *  Configuration Key for the Gfycat API's keychain access group
 */
extern NSString *const kGfycatApiKitKeychainAccessGroupConfigurationKey;

/**
 *  Configuration Key for the Gfycat API's sharedContainerIdentifier
 */
extern NSString *const kGfycatApiKitSharedContainerIdentifierConfigurationKey;

/*!
 @typedef   GfycatApiKitLoginScope enum
 
 @abstract  Passed to indicate the scope of the access you are requesting from the user.
 
 @discussion
 All apps have basic read access by default, but if you plan on asking for extended access such as uploading, deleting, etc, you need to specify these scopes in your authorization request.
 Note that in order to use these extended permissions, first you need to submit your app for review.
 https://developers.gfycat.com/api/#introduction
*/
 
/*!
 @abstract      The notification posted on changing the authentication token.
 */
 extern NSString *const GfycatApiKitUserAuthenticationChangedNotification;


/*!
 @abstract      The error domain for all errors from GfycatApiKit.
 @discussion    Error codes in the range 0-99 are reserved for this domain.
 */
 extern NSString *const GfycatApiKitErrorDomain;


/*!
 @abstract      The Keychain Store service from GfycatApiKit to securely store credentials.
 */
 extern NSString *const GfycatApiKitKeychainStore;


/*!
 @typedef       NS_ENUM(NSInteger, GfycatApiKitErrorCode)
 @abstract      Error codes for GfycatApiKitErrorDomain.
 */
typedef NS_ENUM(NSInteger, GfycatApiKitErrorCode)
{
    /*!
     @abstract Reserved.
     */
    GfycatApiKitReservedError = 0,
    
    /*!
     @abstract The error code for errors from authentication failures.
     */
    GfycatApiKitAuthenticationFailedError,
    
    /*!
     @abstract The error code for invalid JSON response.
     */
    GfycatApiKitJSONResponseError,
    
    /*!
     @abstract The error code for invalid Media reference URL.
     */
    GfycatApiKitInvalidMediaReferenceURL,
    
    /*!
     @abstract The error code for errors when user cancels authentication.
     */
    GfycatApiKitAuthenticationCancelledError = NSUserCancelledError,
};


@class GfycatUser;
@class GfycatMedia;
@class GfycatReferencedMedia;
@class GfycatExtendedMedia;
@class GfycatPaginationInfo;
@class GfycatModel;
@class GfycatCategories;
@class GfycatMediaCollection;
@class GfycatUploadKey;
@class GfycatConfigurationObject;

/**
 *  A generic block used as a callback for receiving a collection of objects.
 *
 *  @param paginatedObjects Array of Gfycat objects.
 *  @param paginationInfo   A PaginationInfo object.
 */
typedef void (^GfycatPaginatiedResponseBlock)(id paginatedObjects, GfycatPaginationInfo * _Nullable paginationInfo);

/**
 *  A generic block used as a callback for receiving a single object.
 *
 *  @param model    An Gfycat model object.
 */
typedef void (^GfycatObjectBlock)(id model);

/**
 *  A callback block providing a collection of Media objects.
 *
 *  @param mediaCollection  A GfycatMediaCollection object.
 *  @param paginationInfo   A PaginationInfo object.
 */
typedef void (^GfycatMediaBlock)(GfycatMediaCollection *mediaCollection, GfycatPaginationInfo * _Nullable paginationInfo);

/**
 *  A callback block providing a collection of Media objects.
 *
 *  @param mediaCollection  A GfycatMediaCollection object.
 *  @param paginationInfo   A PaginationInfo object.
 *  @param isFromCache      Returns YES if data retrieved from cache
 */
typedef void (^GfycatMediaCacheableBlock)(GfycatMediaCollection *mediaCollection, GfycatPaginationInfo * _Nullable paginationInfo, BOOL isFromCache);

/**
 *  A callback block providing a collection of Category objects.
 *
 *  @param categories       A GfycatCategories object.
 *  @param paginationInfo   A PaginationInfo object.
 *  @param isFromCache      Returns YES if data retrieved from cache
 */
typedef void (^GfycatCategoryArrayBlock)(GfycatCategories *categories, GfycatPaginationInfo * _Nullable paginationInfo, BOOL isFromCache);

/**
 *  A callback block providing a collection of GfycatConfigurationObject objects.
 *
 *  @param configurationObjects       An array of GfycatConfigurationObject objects.
 */
typedef void (^GfycatConfigurationsArrayBlock)(NSArray<GfycatConfigurationObject *> *configurationObjects);

/**
 *  A callback block providing a collection of User objects.
 *
 *  @param users            An array of User objects.
 *  @param paginationInfo   A PaginationInfo object.
 */
typedef void (^GfycatUsersBlock)(NSArray<GfycatUser *> *users, GfycatPaginationInfo *paginationInfo);

/**
 *  A callback block providing a User object.
 *
 *  @param user     An GfycatUser object.
 */
typedef void (^GfycatUserBlock)(GfycatUser *user);

/**
 *  A callback block providing a Media object.
 *
 *  @param media    An GfycatMedia object.
 */
typedef void (^GfycatMediaObjectBlock)(GfycatMedia *media);

/**
 *  A callback block providing a Media object given arbitrary HTTP URL.
 *
 *  @param media    An GfycatReferencedMedia object.
 */
typedef void (^GfycatReferencedMediaObjectBlock)(GfycatReferencedMedia *media);

/**
 *  A callback block providing a extended Media object.
 *
 *  @param media    An GfycatExtendedMedia object.
 */
typedef void (^GfycatExtendedMediaObjectBlock)(GfycatExtendedMedia *media);

/**
 *  A callback block providing a extended Media object.
 *
 *  @param media    An GfycatExtendedMedia object.
 */
typedef void (^GfycatMediaLikeStateBlock)(GfycatMedia *media, BOOL likeState);

/**
 *  A callback block providing a GfycatUploadKey object.
 *
 *  @param uploadKey An GfycatUploadKey object.
 */
typedef void (^GfycatUploadKeyBlock)(GfycatUploadKey *uploadKey);

/**
 *  A callback block providing a NSString object.
 *
 *  @param string An NSString object.
 */
typedef void (^GfycatStringBlock)(NSString *string);

/**
 *  A generic failure block for handling server errors.
 *
 *  @param error                An error object
 *  @param serverStatusCode     A server status code
 */
typedef void (^GfycatFailureBlock)(NSError* error, NSInteger serverStatusCode);

/**
 *  A generic response block providing the server response dictionary, as is.
 *
 *  @param serverResponse Response JSON in dictionary form.
 */
typedef void (^GfycatResponseBlock)(NSDictionary *serverResponse);

/**
 *  A generic success block.
 */
typedef void (^GfycatSuccessBlock)(void);

/**
 *  A progress block providing the upload progress.
 *
 *  @param progress A NSProgress object.
 */
typedef void (^GfycatProgressBlock)(NSProgress *progress);

/**
 *  String constants as represented in JSON.
 */

extern NSString *const kKeyClientID;
extern NSString *const kKeyClientSecret;
extern NSString *const kKeyGrantType;
extern NSString *const kKeyAccessToken;
extern NSString *const kKeyAccessTokenExpiration;
extern NSString *const kKeyRefreshToken;
extern NSString *const kKeyRefreshTokenExpiration;
extern NSString *const kKeyAuthorization;
extern NSString *const kKeyUsername;
extern NSString *const kKeyPassword;

extern NSString *const kCursor;
extern NSString *const kDigest;
extern NSString *const kTagName;
extern NSString *const kLocale;

extern NSString *const kPagination;
extern NSString *const kPaginationType;
extern NSString *const kPaginationParameters;
extern NSString *const kPaginationPath;
extern NSString *const kPaginationCursor;

extern NSString *const kRelationshipActionKey;
extern NSString *const kRelationshipActionFollow;
extern NSString *const kRelationshipActionUnfollow;
extern NSString *const kRelationshipActionBlock;
extern NSString *const kRelationshipActionUnblock;
extern NSString *const kRelationshipActionApprove;
extern NSString *const kRelationshipActionIgnore;

extern NSString *const kNewGfycatTitle;
extern NSString *const kNewGfycatDescription;
extern NSString *const kNewGfycatTags;
extern NSString *const kNewGfycatPrivate;

NS_ASSUME_NONNULL_END

#define GfyNotNull(obj) (obj && (![obj isEqual:[NSNull null]]) && (![obj isEqual:@"<null>"]) )

#define GfySafeExecute(block, ...) do { __typeof(block) block_copy = [(block) copy]; if (block_copy) { block_copy(__VA_ARGS__); } } while (0)
