//
// Created by Denis Dorokhov on 29/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYRestService.h"
#import "PNYPersistentDictionary.h"

@class PNYSongDownloadService;

@protocol PNYSongDownload <NSObject>

@property (nonatomic, readonly) NSNumber *songId;
@property (nonatomic, readonly) NSString *filePath;
@property (nonatomic, readonly) NSDate *date;

@end

@protocol PNYSongDownloadProgress <NSObject>

@property (nonatomic, readonly) NSNumber *songId;
@property (nonatomic, readonly) float value;

@end

@protocol PNYSongDownloadServiceDelegate <NSObject>

@optional

- (void)songDownloadService:(PNYSongDownloadService *)aService didStartSongDownload:(NSNumber *)aSongId;
- (void)songDownloadService:(PNYSongDownloadService *)aService didProgressSongDownload:(id <PNYSongDownloadProgress>)aProgress;
- (void)songDownloadService:(PNYSongDownloadService *)aService didCancelSongDownload:(NSNumber *)aSongId;
- (void)songDownloadService:(PNYSongDownloadService *)aService didFailSongDownload:(NSNumber *)aSongId errors:(NSArray *)aErrors;
- (void)songDownloadService:(PNYSongDownloadService *)aService didCompleteSongDownload:(id <PNYSongDownload>)aSongDownload;

@end

@interface PNYSongDownloadService : NSObject

@property (nonatomic, strong) id <PNYRestService> restService;
@property (nonatomic, strong) id <PNYPersistentDictionary> persistentDictionary;

@property (nonatomic, copy) NSString *folderPathInDocuments;

- (void)addDelegate:(id <PNYSongDownloadServiceDelegate>)aDelegate;
- (void)removeDelegate:(id <PNYSongDownloadServiceDelegate>)aDelegate;

- (id <PNYSongDownload>)songDownload:(NSNumber *)aSongId;

- (void)startSongDownload:(NSNumber *)aSongId;
- (void)cancelSongDownload:(NSNumber *)aSongId;

- (id <PNYSongDownloadProgress>)progressForSong:(NSNumber *)aSongId;

@end