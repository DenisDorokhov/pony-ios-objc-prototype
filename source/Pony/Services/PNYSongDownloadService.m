//
// Created by Denis Dorokhov on 29/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <EasyMapping/EKMapper.h>
#import <EasyMapping/EKSerializer.h>
#import "PNYSongDownloadService.h"
#import "NSMutableOrderedSet+PNYNSValue.h"
#import "PNYMacros.h"
#import "PNYFileUtils.h"
#import "NSOrderedSet+PNYNSValue.h"
#import "PNYErrorDto.h"
#import "PNYDtoUtils.h"

@interface PNYSongDownloadImpl : NSObject <PNYSongDownload, EKMappingProtocol>

@property (nonatomic, strong) NSNumber *songId;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSDate *date;

@end

@implementation PNYSongDownloadImpl

#pragma mark - <EKMappingProtocol>

+ (EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *aMapping) {
        [aMapping mapPropertiesFromArray:@[@"songId", @"filePath"]];
        [aMapping mapKeyPath:@"date" toProperty:@"date" withValueBlock:^(NSString *aKey, NSNumber *aValue) {
            return [PNYDtoUtils timestampToDate:aValue];
        }       reverseBlock:^id(NSDate *aValue) {
            return [PNYDtoUtils dateToTimestamp:aValue];
        }];
    }];
}

@end

@interface PNYSongDownloadProgressImpl : NSObject <PNYSongDownloadProgress>

@property (nonatomic, strong) PNYSongDto *song;
@property (nonatomic) float value;

@end

@implementation PNYSongDownloadProgressImpl

@end

@interface PNYSongDownloadServiceTask : NSObject

@property (nonatomic, strong) PNYSongDto *song;

@property (nonatomic, strong) id <PNYRestRequest> request;
@property (nonatomic, strong) PNYSongDownloadProgressImpl *progress;

@property (nonatomic, copy) NSString *filePath;

@end

@implementation PNYSongDownloadServiceTask

@end

@implementation PNYSongDownloadService
{
@private

    NSMutableOrderedSet *delegates;

    NSMutableDictionary *songIdToTask; // NSNumber -> PNYSongDownloadServiceTask
}

static NSString *const KEY_SONG_DOWNLOADS = @"PNYSongDownloadService.songDownload";

- (instancetype)init
{
    self = [super init];
    if (self != nil) {

        delegates = [NSMutableOrderedSet orderedSet];

        songIdToTask = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Public

- (NSString *)folderPathInDocuments
{
    if (_folderPathInDocuments == nil) {
        _folderPathInDocuments = @"PNYSongDownloadService/Downloads";
    }

    return _folderPathInDocuments;
}

- (void)addDelegate:(id <PNYSongDownloadServiceDelegate>)aDelegate
{
    [delegates addNonretainedObject:aDelegate];
}

- (void)removeDelegate:(id <PNYSongDownloadServiceDelegate>)aDelegate
{
    [delegates removeNonretainedObject:aDelegate];
}

- (id <PNYSongDownload>)downloadForSong:(NSNumber *)aSongId
{
    PNYAssert(self.persistentDictionary != nil);

    PNYSongDownloadImpl *songDownload = nil;

    NSDictionary *songDownloadDictionary = self.persistentDictionary.data[KEY_SONG_DOWNLOADS][aSongId];

    if (songDownloadDictionary != nil) {
        songDownload = [EKMapper objectFromExternalRepresentation:songDownloadDictionary
                                                      withMapping:[PNYSongDownloadImpl objectMapping]];
        songDownload.filePath = [[self folderPath] stringByAppendingPathComponent:songDownload.filePath];
    }

    return songDownload;
}

- (NSArray *)allDownloads
{
    NSMutableArray *downloads = [NSMutableArray array];
    [self.persistentDictionary.data[KEY_SONG_DOWNLOADS] enumerateKeysAndObjectsUsingBlock:^(NSNumber *aSongId, NSDictionary *aSongDownload, BOOL *aStop) {
        [downloads addObject:[EKSerializer serializeObject:aSongDownload
                                               withMapping:[PNYSongDownloadImpl objectMapping]]];
    }];
    return downloads;
}

- (void)startDownloadForSong:(PNYSongDto *)aSong
{
    PNYAssert(self.restService != nil);

    if (songIdToTask[aSong.id] != nil) {

        PNYLogInfo(@"Song [%@] is already downloading, cancelling download.", aSong.id);

        [self doCancelSongDownload:aSong.id];
    }

    PNYSongDownloadProgressImpl *progress = [PNYSongDownloadProgressImpl new];

    progress.song = aSong;
    progress.value = 0;

    PNYSongDownloadServiceTask *task = [PNYSongDownloadServiceTask new];

    task.song = aSong;
    task.progress = progress;
    task.filePath = [PNYFileUtils createTemporaryFile];

    task.request = [self.restService downloadSong:task.song.url toFile:task.filePath progress:^(float aValue) {
        [self progressSongDownload:task.song.id value:aValue];
    }                                     success:^{
        PNYLogDebug(@"Song [%@] file downloaded to [%@].", task.song.id, task.filePath);
        [self finishSongDownload:task.song.id];
    }                                     failure:^(NSArray *aErrors) {
        if ([PNYErrorDto fetchErrorFromArray:aErrors withCode:PNYErrorDtoCodeClientRequestCancelled] == nil) {
            [self failSongDownload:task.song.id errors:aErrors];
        }
    }];

    songIdToTask[task.song.id] = task;

    PNYLogInfo(@"Song [%@] download started.", task.song.id);

    [delegates enumerateNonretainedObjectsUsingBlock:^(id <PNYSongDownloadServiceDelegate> aObject, NSUInteger aIndex, BOOL *aStop) {
        if ([aObject respondsToSelector:@selector(songDownloadService:didStartSongDownload:)]) {
            [aObject songDownloadService:self didStartSongDownload:task.song.id];
        }
    }];
}

- (void)cancelDownloadForSong:(NSNumber *)aSongId
{
    if (songIdToTask[aSongId] != nil) {

        [self doCancelSongDownload:aSongId];

        PNYLogInfo(@"Song [%@] download cancelled.", aSongId);

    } else {
        PNYLogWarn(@"Could not cancel download of song [%@]: download is not started", aSongId);
    }
}

- (void)deleteDownloadForSong:(NSNumber *)aSongId
{
    PNYAssert(self.persistentDictionary != nil);

    id <PNYSongDownload> songDownload = [self downloadForSong:aSongId];

    if (songDownload != nil) {

        [self.persistentDictionary.data[KEY_SONG_DOWNLOADS] removeObjectForKey:songDownload.songId];
        [self.persistentDictionary save];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{

            [[NSFileManager defaultManager] removeItemAtPath:songDownload.filePath error:nil];

            PNYLogDebug(@"Song [%@] file [%@] deleted.", songDownload.songId, songDownload.filePath);
        });

        PNYLogInfo(@"Song [%@] download deleted.", songDownload.songId);

        [delegates enumerateNonretainedObjectsUsingBlock:^(id <PNYSongDownloadServiceDelegate> aObject, NSUInteger aIndex, BOOL *aStop) {
            if ([aObject respondsToSelector:@selector(songDownloadService:didDeleteSongDownload:)]) {
                [aObject songDownloadService:self didDeleteSongDownload:songDownload.songId];
            }
        }];

    } else {
        PNYLogWarn(@"Could not delete song [%@]: song download not found.", aSongId);
    }
}

- (id <PNYSongDownloadProgress>)progressForSong:(NSNumber *)aSongId
{
    return [self taskForSong:aSongId].progress;
}

- (NSArray *)allProgresses
{
    NSMutableArray *progresses = [NSMutableArray array];
    [songIdToTask enumerateKeysAndObjectsUsingBlock:^(NSNumber *aSongId, PNYSongDownloadServiceTask *aTask, BOOL *aStop) {
        [progresses addObject:aTask.progress];
    }];
    return progresses;
}

#pragma mark - Private

- (PNYSongDownloadServiceTask *)taskForSong:(NSNumber *)aSongId
{
    return songIdToTask[aSongId];
}

- (void)doCancelSongDownload:(NSNumber *)aSongId
{
    id <PNYRestRequest> request = [self taskForSong:aSongId].request;

    if (request != nil) {

        [request cancel];

        [self clearIntermediateDataForSong:aSongId];

        [delegates enumerateNonretainedObjectsUsingBlock:^(id <PNYSongDownloadServiceDelegate> aObject, NSUInteger aIndex, BOOL *aStop) {
            if ([aObject respondsToSelector:@selector(songDownloadService:didCancelSongDownload:)]) {
                [aObject songDownloadService:self didCancelSongDownload:aSongId];
            }
        }];
    }
}

- (void)progressSongDownload:(NSNumber *)aSongId value:(float)aValue
{
    PNYSongDownloadProgressImpl *progress = [self taskForSong:aSongId].progress;

    progress.value = aValue;

    [delegates enumerateNonretainedObjectsUsingBlock:^(id <PNYSongDownloadServiceDelegate> aObject, NSUInteger aIndex, BOOL *aStop) {
        if ([aObject respondsToSelector:@selector(songDownloadService:didProgressSongDownload:)]) {
            [aObject songDownloadService:self didProgressSongDownload:progress];
        }
    }];
}

- (void)finishSongDownload:(NSNumber *)aSongId
{
    PNYAssert(self.persistentDictionary != nil);

    [PNYFileUtils createDirectory:[self folderPath]];

    NSString *originalPath = [self taskForSong:aSongId].filePath;
    NSString *destinationPath = [[self folderPath] stringByAppendingPathComponent:aSongId.stringValue];

    NSError *error = nil;

    [[NSFileManager defaultManager] removeItemAtPath:destinationPath error:nil];
    [[NSFileManager defaultManager] moveItemAtPath:originalPath toPath:destinationPath
                                             error:&error];

    if (error == nil) {

        PNYSongDownloadImpl *songDownload = [PNYSongDownloadImpl new];

        songDownload.songId = aSongId;
        songDownload.filePath = aSongId.stringValue;
        songDownload.date = [NSDate date];

        NSMutableDictionary *songDownloadsDictionary = self.persistentDictionary.data[KEY_SONG_DOWNLOADS];
        if (songDownloadsDictionary == nil) {
            self.persistentDictionary.data[KEY_SONG_DOWNLOADS] = songDownloadsDictionary = [NSMutableDictionary dictionary];
        }
        songDownloadsDictionary[aSongId] = [EKSerializer serializeObject:songDownload
                                                             withMapping:[PNYSongDownloadImpl objectMapping]];

        [self.persistentDictionary save];

        songDownload.filePath = destinationPath;

        [self clearIntermediateDataForSong:aSongId];

        PNYLogInfo(@"Song [%@] download complete.", aSongId);

        [delegates enumerateNonretainedObjectsUsingBlock:^(id <PNYSongDownloadServiceDelegate> aObject, NSUInteger aIndex, BOOL *aStop) {
            if ([aObject respondsToSelector:@selector(songDownloadService:didCompleteSongDownload:)]) {
                [aObject songDownloadService:self didCompleteSongDownload:songDownload];
            }
        }];

    } else {

        PNYLogError(@"Could not move song download from [%@] to [%@]: %@", originalPath, destinationPath, error);

        [self failSongDownload:aSongId errors:@[[PNYErrorDtoFactory createErrorUnexpected]]];
    }
}

- (void)failSongDownload:(NSNumber *)aSongId errors:(NSArray *)aErrors
{
    [self clearIntermediateDataForSong:aSongId];

    PNYLogError(@"Song [%@] download failed: %@", aSongId, aErrors);

    [delegates enumerateNonretainedObjectsUsingBlock:^(id <PNYSongDownloadServiceDelegate> aObject, NSUInteger aIndex, BOOL *aStop) {
        if ([aObject respondsToSelector:@selector(songDownloadService:didFailSongDownload:errors:)]) {
            [aObject songDownloadService:self didFailSongDownload:aSongId errors:aErrors];
        }
    }];
}

- (void)clearIntermediateDataForSong:(NSNumber *)aSongId
{
    PNYSongDownloadServiceTask *task = [self taskForSong:aSongId];

    [[NSFileManager defaultManager] removeItemAtPath:task.filePath error:nil];

    [songIdToTask removeObjectForKey:aSongId];
}

- (NSString *)folderPath
{
    return [PNYFileUtils filePathInDocuments:self.folderPathInDocuments];
}

@end