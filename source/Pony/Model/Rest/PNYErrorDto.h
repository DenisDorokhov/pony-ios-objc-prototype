//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <EasyMapping/EKMappingProtocol.h>

static NSString *const PNYErrorDtoCodeClientRequestFailed = @"errorClientRequestFailed";
static NSString *const PNYErrorDtoCodeClientOffline = @"errorClientOffline";
static NSString *const PNYErrorDtoCodeInvalidContentType = @"errorInvalidContentType";
static NSString *const PNYErrorDtoCodeInvalidRequest = @"errorInvalidRequest";
static NSString *const PNYErrorDtoCodeAccessDenied = @"errorAccessDenied";
static NSString *const PNYErrorDtoCodeValidation = @"errorValidation";
static NSString *const PNYErrorDtoCodeUnexpected = @"errorUnexpected";
static NSString *const PNYErrorDtoCodeInvalidCredentials = @"errorInvalidCredentials";
static NSString *const PNYErrorDtoCodeInvalidPassword = @"errorInvalidPassword";
static NSString *const PNYErrorDtoCodeScanJobNotFound = @"errorScanJobNotFound";
static NSString *const PNYErrorDtoCodeScanResultNotFound = @"errorScanResultNotFound";
static NSString *const PNYErrorDtoCodeArtistNotFound = @"errorArtistNotFound";
static NSString *const PNYErrorDtoCodeSongNotFound = @"errorSongNotFound";
static NSString *const PNYErrorDtoCodeUserNotFound = @"errorUserNotFound";
static NSString *const PNYErrorDtoCodeArtworkUploadNotFound = @"errorArtworkUploadNotFound";
static NSString *const PNYErrorDtoCodeArtworkUploadFormat = @"errorArtworkUploadFormat";
static NSString *const PNYErrorDtoCodeLibraryNotDefined = @"errorLibraryNotDefined";
static NSString *const PNYErrorDtoCodeMaxUploadSizeExceeded = @"errorMaxUploadSizeExceeded";
static NSString *const PNYErrorDtoCodeUserSelfDeletion = @"errorUserSelfDeletion";
static NSString *const PNYErrorDtoCodeUserSelfRoleModification = @"errorUserSelfRoleModification";
static NSString *const PNYErrorDtoCodePageNumberInvalid = @"errorPageNumberInvalid";
static NSString *const PNYErrorDtoCodePageSizeInvalid = @"errorPageSizeInvalid";
static NSString *const PNYErrorDtoCodeSongsCountInvalid = @"errorSongsCountInvalid";

@interface PNYErrorDto : NSObject <EKMappingProtocol>

@property NSString *field;
@property NSString *code;
@property NSString *text;

@property NSArray *arguments;

+ (instancetype)errorWithCode:(NSString *)aCode text:(NSString *)aText arguments:(NSArray *)aArguments;

- (instancetype)initWithCode:(NSString *)aCode text:(NSString *)aText arguments:(NSArray *)aArguments;

@end