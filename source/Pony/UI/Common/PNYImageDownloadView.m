//
// Created by Denis Dorokhov on 11/12/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYImageDownloadView.h"
#import "PNYRestServiceCachedLocator.h"
#import "PNYMacros.h"

@implementation PNYImageDownloadView
{
@private
    id <PNYRestServiceCached> restService;
}

static const NSUInteger CACHE_CAPACITY = 100;

static NSCache *CACHE = nil;

- (instancetype)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if (self != nil) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self setup];
    }
    return self;
}

#pragma mark - Public

- (void)setImageUrl:(NSString *)aImageUrl
{
    _imageUrl = [aImageUrl copy];

    [self updateImageUrl];
}

#pragma mark - Private

- (void)setup
{
    if (CACHE == nil) {
        CACHE = [[NSCache alloc] init];
        CACHE.countLimit = CACHE_CAPACITY;
    }

    restService = [PNYRestServiceCachedLocator sharedInstance].restServiceCached;

    UIView *view = [self loadViewFromNib];

    view.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:view];

    for (NSString *orientation in @[@"H", @"V"]) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"%@:|[view]|", orientation]
                                                                     options:NSLayoutFormatDirectionLeadingToTrailing
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(view)]];
    }

    [self updateImageUrl];
}

- (void)updateImageUrl
{
    self.imageView.hidden = YES;

    if (self.imageUrl != nil) {

        UIImage *cachedImage = [CACHE objectForKey:self.imageUrl];

        if (cachedImage != nil) {

            self.imageView.hidden = NO;
            self.imageView.image = cachedImage;

            self.activityIndicatorView.hidden = YES;

        } else {

            self.activityIndicatorView.hidden = NO;
            [self.activityIndicatorView startAnimating];

            NSString *loadingUrl = self.imageUrl;

            // Avoid downloading every image during fast scrolling when image download view is inside table / collection view.
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([loadingUrl isEqualToString:self.imageUrl]) {

                    PNYLogVerbose(@"Downloading image [%@]...", loadingUrl);

                    [restService downloadImage:loadingUrl success:^(UIImage *aImage) {

                        PNYLogDebug(@"Downloaded image [%@].", loadingUrl);

                        [self finishImageLoading:aImage loadingUrl:loadingUrl];

                    }                  failure:^(NSArray *aErrors) {

                        PNYLogError(@"Could not download image [%@]: %@", loadingUrl, aErrors);

                        if ([loadingUrl isEqualToString:self.imageUrl]) {
                            self.activityIndicatorView.hidden = YES;
                        }

                    } cacheHandler:^BOOL(UIImage *aCachedImage) {

                        if (aCachedImage != nil) {

                            PNYLogVerbose(@"Cached image returned for URL [%@].", loadingUrl);

                            [self finishImageLoading:aCachedImage loadingUrl:loadingUrl];

                            return NO;
                        }

                        return YES;
                    }];
                }
            });
        }
    } else {
        self.activityIndicatorView.hidden = YES;
    }
}

- (void)finishImageLoading:(UIImage *)aImage loadingUrl:(NSString *)aLoadingUrl
{
    [CACHE setObject:aImage forKey:aLoadingUrl];

    if ([aLoadingUrl isEqualToString:self.imageUrl]) {
        self.activityIndicatorView.hidden = YES;
        self.imageView.hidden = NO;
        self.imageView.image = aImage;
    }
}

- (UIView *)loadViewFromNib
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UINib *nib = [UINib nibWithNibName:@"ImageDownloadView" bundle:bundle];
    return [nib instantiateWithOwner:self options:nil][0];
}

@end