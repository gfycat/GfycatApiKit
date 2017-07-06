//
//  GfycatApi.h
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
#import "GfycatApiConstants.h"
#import "GfycatModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GfycatApi : NSObject

/*!
 @abstract Gets the singleton instance.
 */
+ (instancetype)shared;

/**
 *  Client Id of your App, as registered with Gfycat.
 */
@property (nonatomic, copy, readonly) NSString *appClientID;

/**
 *  Client Secret of your App, as registered with Gfycat.
 */
@property (nonatomic, copy, readonly) NSString *appClientSecret;

/**
 *  The oauth token stored in the account store credential, if available.
 *  If not empty, this implies user has granted access.
 */
@property (nonatomic, copy, readonly, nullable) NSString *accessToken;

/**
 *  The username stored in the account store credential, if available.
 *  If not empty, this implies user is logged in.
 */
@property (nonatomic, copy, readonly, nullable) NSString *username;

/**
 *  Allow to set custom application ID and application secret from code.
 */
- (void)setAppClientID:(NSString *)appClientID withSecret:(NSString *)appClientSecret;

/**
 *  Setting custom base URL to make API calls.
 */
- (void)setBaseURL:(NSURL *)baseURL;

/**
 *  The identifier of the shared data container into which files in background sessions should be downloaded.
 *  App extensions wishing to use background sessions *must* set this property to a valid container identifier, or
 *  all transfers in that session will fail with NSURLErrorBackgroundSessionRequiresSharedContainer.
 */
@property (nonatomic, copy, nullable) NSString *sharedContainerIdentifier;


#pragma mark - Authentication -

/**
 *  Creates a new user account
 *
 *  @param username Username for account
 *  @param password Password for account
 *  @param email    Email address for account - Optional
 *  @param success  Provides a dictionary authorization and refresh tokens.
 *  @param failure  Provides an error and a server status code.
 */
- (void)createAccountWithUsername:(NSString *)username
                         password:(NSString *)password
                            email:(nullable NSString *)email
                          success:(GfycatResponseBlock)success
                          failure:(nullable GfycatFailureBlock)failure;

/**
 *  Gets authorization token and validates this session.
 *
 *  @param success  Provides a dictionary authorization token.
 *  @param failure  Provides an error and a server status code.
 */
- (void)validateSession:(GfycatResponseBlock)success
                failure:(nullable GfycatFailureBlock)failure;

/**
 *  Refreshes authotization token if refresh token has not expired, 
 *  otherwise fetches a new authorization token.
 *
 *  @param success  Provides a dictionary authorization token.
 *  @param failure  Provides an error and a server status code.
 */
- (void)refreshSession:(GfycatResponseBlock)success
                failure:(nullable GfycatFailureBlock)failure;

/**
 *  Validate if authorization is done.
 *
 *  @return YES if access token present, otherwise NO.
 */
- (BOOL)isSessionValid;

/**
 *  Validate if login is done.
 *
 *  @return YES if user is logged in, otherwise NO.
 */
- (BOOL)isLoggedIn;

/**
 *  Clears stored access token and browser cookies.
 */
- (void)logout;


#pragma mark - Media -

/**
 *  Get information about a Media object.
 *
 *  @param mediaId  Id of a Media object.
 *  @param success  Provides a fully populated Media object.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getMedia:(NSString *)mediaId
     withSuccess:(GfycatMediaObjectBlock)success
         failure:(nullable GfycatFailureBlock)failure;

/**
 *  Get information about a Media object given an HTTP URL.
 *
 *  @param mediaURL  URL referencing a Media object.
 *  @param success   Provides a shallow Media reference object.
 *  @param failure   Provides an error and a server status code.
 */
- (void)getReferencedMedia:(NSURL *)mediaURL
               withSuccess:(GfycatReferencedMediaObjectBlock)success
                   failure:(nullable GfycatFailureBlock)failure;

/**
 *  Get user-specific information about a Media object.
 *
 *  @param mediaId  Id of a Media object.
 *  @param success  Provides a fully populated Media object.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getExtendedMedia:(NSString *)mediaId
             withSuccess:(GfycatExtendedMediaObjectBlock)success
                 failure:(nullable GfycatFailureBlock)failure;

/**
 *  Get list of all categories.
 *
 *  @param success  Provides a media list object.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getCategoriesWithSuccess:(GfycatCategoryArrayBlock)success
                         failure:(nullable GfycatFailureBlock)failure;

/**
 *  Get a list of media objects from a category.
 *
 *  @param categoryTitle Title of category.
 *  @param count    Count of objects to fetch.
 *  @param success  Provides an array of Media objects and Pagination info.
 *  @param failure  Provides an error and a server status code.
 */
- (void)getCategoryMedia:(NSString *)categoryTitle
                   count:(NSInteger)count
             WithSuccess:(GfycatMediaBlock)success
                 failure:(nullable GfycatFailureBlock)failure;

/** 
 *  Search published Media with string.
 *
 *  @param count    Count of objects to fetch.
 *  @param success  Provides a media list object.
 *  @param failure  Provides an error and a server status code.
 */
- (void)searchMediaWithString:(NSString *)searchString
                        count:(NSInteger)count
                  withSuccess:(GfycatMediaBlock)success
                      failure:(nullable GfycatFailureBlock)failure;

/**
 * Download media content with URL
 *
 * @param url           The url to download
 * @param completion    The callback with the response, downloaded file path, error
 *
 * @return              The progress instance to track downloading progress, cancellable
 */

- (NSProgress *)downloadFileWithURL:(NSURL * _Nullable)url
                         completion:(void(^)(NSURLResponse * _Nullable response, NSURL * _Nullable filePath, NSError * _Nullable error))completion;

/**
 *  Like published Media.
 *
 *  @param mediaId  Id of a Media object.
 *  @param tag      Tag of a Media object.
 *  @param success  Provides a dictionary server response if any.
 *  @param failure  Provides an error and a server status code.
 */
- (void)likeMedia:(NSString *)mediaId
           forTag:(nullable NSString *)tag
      withSuccess:(GfycatResponseBlock)success
          failure:(nullable GfycatFailureBlock)failure;

/**
 *  Dislike published Media.
 *
 *  @param mediaId  Id of a Media object.
 *  @param tag      Tag of a Media object.
 *  @param success  Provides a dictionary server response if any.
 *  @param failure  Provides an error and a server status code.
 */
- (void)dislikeMedia:(NSString *)mediaId
              forTag:(nullable NSString *)tag
         withSuccess:(GfycatResponseBlock)success
             failure:(nullable GfycatFailureBlock)failure;

#pragma mark - Common Pagination Request -

/**
 *  Get paginated objects as specified by information contained in the PaginationInfo object.
 *
 *  @param paginationInfo The PaginationInfo Object obtained from the previous endpoint success block.
 *  @param success        Provides an array of paginated Objects.
 *  @param failure        Provides an error and a server status code.
 */
- (void)getPaginatedItemsForInfo:(GfycatPaginationInfo *)paginationInfo
                     withSuccess:(GfycatPaginatiedResponseBlock)success
                         failure:(nullable GfycatFailureBlock)failure;

#pragma mark - Gfycat Creation Request -

/**
 *  Creates a new Gfycat upload target
 *
 *  @param parameters     Dictionary of optional parameters for new Gfycat.
 *                          Valid keys are:
 *                              kNewGfycatTitle as an NSString,
 *                              kNewGfycatDescription as an NSString,
 *                              kNewGfycatTags as an NSArray of NSString,
 *                              kNewGfycatPrivate as an NSNumber 0 or 1;
 *                              // TODO - Should we include the MD5 flag incase people want to upload duplicates?
 *  @param success        Provides a response dictionary with keys kNewGfycatName and kNewGfycatSecret.
 *  @param failure        Provides an error and a server status code.
 */
- (void)createGfycatWithParameters:(nullable NSDictionary *)parameters
                           success:(GfycatUploadKeyBlock)success
                           failure:(nullable GfycatFailureBlock)failure;

/**
 *  Upload file to create new Gfycat
 *
 *  @param success        Called on success.
 *  @param progress       Provides an upload progress.
 *  @param failure        Provides an error and a server status code.
 */
- (void)uploadFileUrl:(NSURL *)fileUrl
         forUploadKey:(GfycatUploadKey *)uploadKey
              success:(GfycatSuccessBlock)success
             progress:(nullable GfycatProgressBlock)progress
              failure:(nullable GfycatFailureBlock)failure;

#pragma mark - Gfycat Delete Request - TODO - IMPEMENT ME
/**
 *  Deletes a Gfycat target
 *
 *  @param parameters     Dictionary of optional parameters for new Gfycat.
 *                          Valid keys are:
 *                              kNewGfycatTitle as an NSString,
 *                              kNewGfycatDescription as an NSString,
 *                              kNewGfycatTags as an NSArray of NSString,
 *                              kNewGfycatPrivate as an NSNumber 0 or 1;
 *                              // TODO - Should we include the MD5 flag incase people want to upload duplicates?
 *  @param success        Provides a response dictionary with keys kNewGfycatName and kNewGfycatSecret.
 *  @param failure        Provides an error and a server status code.
 */
- (void)deleteGfycatWithParameters:(nullable NSDictionary *)parameters
                              success:(GfycatUploadKeyBlock)success
                              failure:(nullable GfycatFailureBlock)failure;

#pragma mark - Report Gfycat Request -

/**
 *  Report Media object as offensive.
 *
 *  @param mediaId  Id of a Media object.
 *  @param success  Provides a dictionary server response if any.
 *  @param failure  Provides an error and a server status code.
 */
- (void)reportMedia:(NSString *)mediaId
        withSuccess:(GfycatResponseBlock)success
            failure:(nullable GfycatFailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
