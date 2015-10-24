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

@interface DtoMappingTests : PNYTestCase

@end

@implementation DtoMappingTests

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
    } withMapping:[PNYArtistAlbumsDto objectMapping]];

    [self assertArtistDto:dto.artist];

    XCTAssertEqual([dto.albums count], 1);
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
    } withMapping:[PNYAuthenticationDto objectMapping]];

    XCTAssertEqualObjects(dto.accessToken, @"someAccessToken");
    XCTAssertEqualObjects(dto.accessTokenExpiration, [NSDate dateWithTimeIntervalSince1970:999999]);
    XCTAssertEqualObjects(dto.refreshToken, @"someRefreshToken");
    XCTAssertEqualObjects(dto.refreshTokenExpiration, [NSDate dateWithTimeIntervalSince1970:888888]);

    [self assertUserDto:dto.user];
}

- (void)testCredentialsDto
{
    PNYCredentialsDto *dto = [EKMapper objectFromExternalRepresentation:@{
            @"email" : @"someEmail",
            @"password" : @"somePassword",
    } withMapping:[PNYCredentialsDto objectMapping]];

    XCTAssertEqualObjects(dto.email, @"someEmail");
    XCTAssertEqualObjects(dto.password, @"somePassword");
}

- (void)testErrorDto
{
    PNYErrorDto *dto = [EKMapper objectFromExternalRepresentation:@{
            @"field" : @"someField",
            @"code" : @"someCode",
            @"text" : @"someText",
            @"arguments" : @[@"someArgument"],
    } withMapping:[PNYErrorDto objectMapping]];

    XCTAssertEqualObjects(dto.field, @"someField");
    XCTAssertEqualObjects(dto.code, @"someCode");
    XCTAssertEqualObjects(dto.text, @"someText");

    XCTAssertEqual([dto.arguments count], 1);
    XCTAssertEqualObjects(dto.arguments[0], @"someArgument");
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
    } withMapping:[PNYInstallationDto objectMapping]];

    XCTAssertEqualObjects(dto.version, @"someVersion");
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
    XCTFail();
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
            @"url" : @"songUrl",
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

- (void)assertAlbumSongsDto:(PNYAlbumSongsDto *)aDto
{
    [self assertAlbumDto:aDto.album];

    XCTAssertEqual([aDto.songs count], 1);
    [self assertSongDto:aDto.songs[0]];
}

- (void)assertAlbumDto:(PNYAlbumDto *)aDto
{
    XCTAssertEqualObjects(aDto.id, @1);
    XCTAssertEqualObjects(aDto.name, @"albumName");
    XCTAssertEqualObjects(aDto.year, @2015);
    XCTAssertEqualObjects(aDto.artwork, @2);
    XCTAssertEqualObjects(aDto.artworkUrl, @"albumArtworkUrl");

    [self assertArtistDto:aDto.artist];
}

- (void)assertGenreDto:(PNYGenreDto *)aDto
{
    XCTAssertEqualObjects(aDto.id, @1);
    XCTAssertEqualObjects(aDto.name, @"genreName");
    XCTAssertEqualObjects(aDto.artwork, @2);
    XCTAssertEqualObjects(aDto.artworkUrl, @"genreArtworkUrl");
}

- (void)assertArtistDto:(PNYArtistDto *)aDto
{
    XCTAssertEqualObjects(aDto.name, @"artistName");
    XCTAssertEqualObjects(aDto.artwork, @3);
    XCTAssertEqualObjects(aDto.artworkUrl, @"artistArtworkUrl");
}

- (void)assertSongDto:(PNYSongDto *)aDto
{
    XCTAssertEqualObjects(aDto.id, @1);
    XCTAssertEqualObjects(aDto.url, @"songUrl");
    XCTAssertEqualObjects(aDto.duration, @1);
    XCTAssertEqualObjects(aDto.discNumber, @2);
    XCTAssertEqualObjects(aDto.trackNumber, @3);
    XCTAssertEqualObjects(aDto.artistName, @"songArtistName");
    XCTAssertEqualObjects(aDto.name, @"songName");

    [self assertAlbumDto:aDto.album];
    [self assertGenreDto:aDto.genre];
}

- (void)assertUserDto:(PNYUserDto *)aUser
{
    XCTAssertEqualObjects(aUser.id, @1);
    XCTAssertEqualObjects(aUser.creationDate, [NSDate dateWithTimeIntervalSince1970:111111]);
    XCTAssertEqualObjects(aUser.updateDate, [NSDate dateWithTimeIntervalSince1970:222222]);
    XCTAssertEqualObjects(aUser.name, @"userName");
    XCTAssertEqualObjects(aUser.email, @"userEmail");
    XCTAssertEqual(aUser.role, PNYRoleDtoUser);
}

@end