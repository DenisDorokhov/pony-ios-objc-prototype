//
// Created by Denis Dorokhov on 11/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYPersistentDictionaryImpl.h"

@implementation PNYPersistentDictionaryImpl
{
@private
    dispatch_queue_t saveQueue;
    BOOL isInvalid;
}

@synthesize data = _data;

- (instancetype)initWithFilePath:(NSString *)aFilePath
{
    self = [super init];

    if (self != nil) {

        _filePath = [aFilePath copy];

        [self setup];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self onExit];
}

#pragma mark - <PNYPersistentDictionary>

- (void)save
{
    isInvalid = YES;
}

#pragma mark - Private

- (void)setup
{
    _fileFlushInterval = 60.0;
    _excludeFromBackup = NO;

    NSString *folderPath = [_filePath stringByDeletingLastPathComponent];

    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES
                                                   attributes:nil error:nil];
    }

    _data = [NSMutableDictionary dictionaryWithContentsOfFile:_filePath];

    if (_data == nil) {
        _data = [[NSMutableDictionary alloc] init];
    }

    isInvalid = NO;

    saveQueue = dispatch_queue_create("PNYPersistentDictionaryImpl.saveQueue", NULL);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onExit)
                                                 name:UIApplicationWillResignActiveNotification object:nil];

    [self scheduleSave];
}

- (void)scheduleSave
{
    __weak PNYPersistentDictionaryImpl *weakSelf = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_fileFlushInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf validate];
        [weakSelf scheduleSave];
    });
}

- (void)validate
{
    if (isInvalid) {

        NSDictionary *dataCopy = (__bridge_transfer NSDictionary *)(CFPropertyListCreateDeepCopy(kCFAllocatorDefault,
                (__bridge CFPropertyListRef)(_data), kCFPropertyListMutableContainersAndLeaves));

        dispatch_async(saveQueue, ^{
            [self doSave:dataCopy];
        });

        isInvalid = NO;
    }
}

- (void)doSave:(NSDictionary *)aData
{
    NSData *contents = [NSPropertyListSerialization dataWithPropertyList:aData format:NSPropertyListBinaryFormat_v1_0
                                                                 options:0 error:nil];

    [[NSFileManager defaultManager] createFileAtPath:_filePath contents:contents attributes:nil];

    [[NSURL fileURLWithPath:_filePath] setResourceValue:@(_excludeFromBackup)
                                                 forKey:NSURLIsExcludedFromBackupKey error:nil];

    DDLogDebug(@"Data has been flushed to file [%@].", _filePath);
}

- (void)onExit
{
    if (isInvalid) {

        [self doSave:_data];

        isInvalid = NO;
    }
}

@end