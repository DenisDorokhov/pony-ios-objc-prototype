//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <EasyMapping/EKMapper.h>
#import "PNYTestCase.h"
#import "PNYAlbumDto.h"
#import "PNYAlbumSongsDto.h"
#import "PNYSongDto.h"
#import "PNYArtistAlbumsDto.h"
#import "PNYAuthenticationDto.h"
#import "PNYCredentialsDto.h"
#import "PNYErrorDto.h"
#import "PNYInstallationDto.h"
#import "PNYResponseDto.h"

@interface PNYDtoMappingTests : PNYTestCase

@end

@implementation PNYDtoMappingTests

- (void)testAlbumDto
{
    PNYAlbumDto *dto = [EKMapper objectFromExternalRepresentation:[self buildAlbumDtoDictionary]
                                                      withMapping:[PNYAlbumDto objectMapping]];

    [self assertAlbumDto:dto];
}

- (void)testAlbumSongsDto
{
    PNYAlbumSongsDto *dto = [EKMapper objectFromExternalRepresentation:[self buildAlbumSongsDtoDictionary]
                                                           withMapping:[PNYAlbumSongsDto objectMapping]];

    [self assertAlbumSongsDto:dto];
}

- (void)testArtistAlbumsDto
{
    PNYArtistAlbumsDto *dto = [EKMapper objectFromExternalRepresentation:@{
            @"artist" : [self buildArtistDtoDictionary],
            @"albums" : @[[self buildAlbumSongsDtoDictionary]],
    }                                                        withMapping:[PNYArtistAlbumsDto objectMapping]];

    [self assertArtistDto:dto.artist];

    assertThat(dto.albums, hasCountOf(1));
    [self assertAlbumSongsDto:dto.albums[0]];
}

- (void)testArtistDto
{
    PNYArtistDto *dto = [EKMapper objectFromExternalRepresentation:[self buildArtistDtoDictionary]
                                                       withMapping:[PNYArtistDto objectMapping]];

    [self assertArtistDto:dto];
}

- (void)testAuthenticationDto
{
    PNYAuthenticationDto *dto = [EKMapper objectFromExternalRepresentation:@{
            @"accessToken" : @"someAccessToken",
            @"accessTokenExpiration" : @999999,
            @"refreshToken" : @"someRefreshToken",
            @"refreshTokenExpiration" : @888888,
            @"user" : [self buildUserDtoDictionary],
    }                                                          withMapping:[PNYAuthenticationDto objectMapping]];

    assertThat(dto.accessToken, equalTo(@"someAccessToken"));
    assertThat(dto.accessTokenExpiration, equalTo([NSDate dateWithTimeIntervalSince1970:999999]));
    assertThat(dto.refreshToken, equalTo(@"someRefreshToken"));
    assertThat(dto.refreshTokenExpiration, equalTo([NSDate dateWithTimeIntervalSince1970:888888]));

    [self assertUserDto:dto.user];
}

- (void)testCredentialsDto
{
    PNYCredentialsDto *dto = [EKMapper objectFromExternalRepresentation:@{
            @"email" : @"someEmail",
            @"password" : @"somePassword",
    }                                                       withMapping:[PNYCredentialsDto objectMapping]];

    assertThat(dto.email, equalTo(@"someEmail"));
    assertThat(dto.password, equalTo(@"somePassword"));
}

- (void)testErrorDto
{
    PNYErrorDto *dto = [EKMapper objectFromExternalRepresentation:[self buildErrorDtoDictionary]
                                                      withMapping:[PNYErrorDto objectMapping]];

    [self assertErrorDto:dto];
}

- (void)testGenreDto
{
    PNYGenreDto *dto = [EKMapper objectFromExternalRepresentation:[self buildGenreDtoDictionary]
                                                      withMapping:[PNYGenreDto objectMapping]];

    [self assertGenreDto:dto];
}

- (void)testInstallationDto
{
    PNYInstallationDto *dto = [EKMapper objectFromExternalRepresentation:@{
            @"version" : @"someVersion"
    }                                                        withMapping:[PNYInstallationDto objectMapping]];

    assertThat(dto.version, equalTo(@"someVersion"));
}

- (void)testSongDto
{
    PNYSongDto *dto = [EKMapper objectFromExternalRepresentation:[self buildSongDtoDictionary]
                                                     withMapping:[PNYSongDto objectMapping]];

    [self assertSongDto:dto];
}

- (void)testUserDto
{
    PNYUserDto *dto = [EKMapper objectFromExternalRepresentation:[self buildUserDtoDictionary]
                                                     withMapping:[PNYUserDto objectMapping]];

    [self assertUserDto:dto];
}

- (void)testResponseDto
{
    PNYResponseDto *dto;

    // Test plain object data.

    dto = [EKMapper objectFromExternalRepresentation:[self buildResponseDtoDictionaryWithData:[self buildAlbumSongsDtoDictionary]]
                                         withMapping:[PNYResponseDto objectMappingWithDataClass:[PNYAlbumSongsDto class]]];

    [self assertResponseDtoExcludingData:dto];

    assertThatBool([dto.data isKindOfClass:[PNYAlbumSongsDto class]], isTrue());
    [self assertAlbumSongsDto:dto.data];

    // Test array data.

    dto = [EKMapper objectFromExternalRepresentation:[self buildResponseDtoDictionaryWithData:@[[self buildArtistDtoDictionary]]]
                                         withMapping:[PNYResponseDto objectMappingWithDataClass:[PNYArtistDto class]]];

    [self assertResponseDtoExcludingData:dto];

    assertThatBool([dto.data isKindOfClass:[NSArray class]], isTrue());
    assertThat(dto.data, hasCountOf(1));
    [self assertArtistDto:dto.data[0]];

    // Test nil data.

    dto = [EKMapper objectFromExternalRepresentation:[self buildResponseDtoDictionaryWithData:nil]
                                         withMapping:[PNYResponseDto objectMappingWithDataClass:nil]];

    [self assertResponseDtoExcludingData:dto];

    assertThat(dto.data, nilValue());
}

#pragma mark - Private

- (NSDictionary *)buildAlbumSongsDtoDictionary
{
    return @{
            @"album" : [self buildAlbumDtoDictionary],
            @"songs" : @[[self buildSongDtoDictionary]],
    };
}

- (NSDictionary *)buildAlbumDtoDictionary
{
    return @{
            @"id" : @1,
            @"name" : @"albumName",
            @"year" : @2015,
            @"artwork" : @2,
            @"artworkUrl" : @"albumArtworkUrl",
            @"artist" : [self buildArtistDtoDictionary],
    };
}

- (NSDictionary *)buildSongDtoDictionary
{
    return @{
            @"id" : @1,
            @"updateDate" : @333333,
            @"url" : @"songUrl",
            @"size" : @123456,
            @"duration" : @1,
            @"discNumber" : @2,
            @"trackNumber" : @3,
            @"artistName" : @"songArtistName",
            @"name" : @"songName",
            @"album" : [self buildAlbumDtoDictionary],
            @"genre" : [self buildGenreDtoDictionary],
    };
}

- (NSDictionary *)buildGenreDtoDictionary
{
    return @{
            @"id" : @1,
            @"name" : @"genreName",
            @"artwork" : @2,
            @"artworkUrl" : @"genreArtworkUrl",
    };
}

- (NSDictionary *)buildArtistDtoDictionary
{
    return @{
            @"name" : @"artistName",
            @"artwork" : @3,
            @"artworkUrl" : @"artistArtworkUrl",
    };
}

- (NSDictionary *)buildUserDtoDictionary
{
    return @{
            @"id" : @1,
            @"creationDate" : @111111,
            @"updateDate" : @222222,
            @"name" : @"userName",
            @"email" : @"userEmail",
            @"role" : @"USER",
    };
}

- (NSDictionary *)buildErrorDtoDictionary
{
    return @{
            @"field" : @"someField",
            @"code" : @"someCode",
            @"text" : @"someText",
            @"arguments" : @[@"someArgument"],
    };
}

- (NSDictionary *)buildResponseDtoDictionaryWithData:(id)aData
{
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:@{
            @"version" : @"someVersion",
            @"successful" : @(YES),
            @"errors" : @[[self buildErrorDtoDictionary]],
    }];
    if (aData != nil) {
        result[@"data"] = aData;
    }
    return result;
}

- (void)assertAlbumSongsDto:(PNYAlbumSongsDto *)aDto
{
    [self assertAlbumDto:aDto.album];

    assertThat(aDto.songs, hasCountOf(1));
    [self assertSongDto:aDto.songs[0]];
}

- (void)assertAlbumDto:(PNYAlbumDto *)aDto
{
    assertThat(aDto.id, equalTo(@1));
    assertThat(aDto.name, equalTo(@"albumName"));
    assertThat(aDto.year, equalTo(@2015));
    assertThat(aDto.artwork, equalTo(@2));
    assertThat(aDto.artworkUrl, equalTo(@"albumArtworkUrl"));

    [self assertArtistDto:aDto.artist];
}

- (void)assertGenreDto:(PNYGenreDto *)aDto
{
    assertThat(aDto.id, equalTo(@1));
    assertThat(aDto.name, equalTo(@"genreName"));
    assertThat(aDto.artwork, equalTo(@2));
    assertThat(aDto.artworkUrl, equalTo(@"genreArtworkUrl"));
}

- (void)assertArtistDto:(PNYArtistDto *)aDto
{
    assertThat(aDto.name, equalTo(@"artistName"));
    assertThat(aDto.artwork, equalTo(@3));
    assertThat(aDto.artworkUrl, equalTo(@"artistArtworkUrl"));
}

- (void)assertSongDto:(PNYSongDto *)aDto
{
    assertThat(aDto.id, equalTo(@1));
    assertThat(aDto.updateDate, equalTo([NSDate dateWithTimeIntervalSince1970:333333]));
    assertThat(aDto.url, equalTo(@"songUrl"));
    assertThat(aDto.size, equalTo(@123456));
    assertThat(aDto.duration, equalTo(@1));
    assertThat(aDto.discNumber, equalTo(@2));
    assertThat(aDto.trackNumber, equalTo(@3));
    assertThat(aDto.artistName, equalTo(@"songArtistName"));
    assertThat(aDto.name, equalTo(@"songName"));

    [self assertAlbumDto:aDto.album];
    [self assertGenreDto:aDto.genre];
}

- (void)assertUserDto:(PNYUserDto *)aUser
{
    assertThat(aUser.id, equalTo(@1));
    assertThat(aUser.creationDate, equalTo([NSDate dateWithTimeIntervalSince1970:111111]));
    assertThat(aUser.updateDate, equalTo([NSDate dateWithTimeIntervalSince1970:222222]));
    assertThat(aUser.name, equalTo(@"userName"));
    assertThat(aUser.email, equalTo(@"userEmail"));
    assertThatInteger(aUser.role, equalToInteger(PNYRoleDtoUser));
}

- (void)assertErrorDto:(PNYErrorDto *)aDto
{
    assertThat(aDto.field, equalTo(@"someField"));
    assertThat(aDto.code, equalTo(@"someCode"));
    assertThat(aDto.text, equalTo(@"someText"));

    assertThat(aDto.arguments, hasCountOf(1));
    assertThat(aDto.arguments[0], equalTo(@"someArgument"));
}

- (void)assertResponseDtoExcludingData:(PNYResponseDto *)aDto
{
    assertThat(aDto.version, equalTo(@"someVersion"));
    assertThatBool(aDto.successful, isTrue());

    assertThat(aDto.errors, hasCountOf(1));
    [self assertErrorDto:aDto.errors[0]];
}

@end