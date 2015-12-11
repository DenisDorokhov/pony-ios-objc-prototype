//
// Created by Denis Dorokhov on 11/12/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYImageDownloadView.h"
#import "PNYRestServiceLocator.h"
#import "PNYMacros.h"

@implementation PNYImageDownloadView
{
@private
    id <PNYRestService> restService;
}

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
    restService = [PNYRestServiceLocator sharedInstance].restService;

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

        self.activityIndicatorView.hidden = NO;

        NSString *loadingUrl = self.imageUrl;

        // Downloading every image during fast scrolling.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([loadingUrl isEqualToString:self.imageUrl]) {

                PNYLogVerbose(@"Downloading image [%@]...", loadingUrl);

                [restService downloadImage:loadingUrl success:^(UIImage *aImage) {

                    PNYLogVerbose(@"Downloaded image [%@].", loadingUrl);

                    if ([loadingUrl isEqualToString:self.imageUrl]) {
                        self.activityIndicatorView.hidden = YES;
                        self.imageView.hidden = NO;
                        self.imageView.image = aImage;
                    }

                }                  failure:^(NSArray *aErrors) {

                    PNYLogError(@"Could not download image [%@]: %@", loadingUrl, aErrors);

                    if ([loadingUrl isEqualToString:self.imageUrl]) {
                        self.activityIndicatorView.hidden = YES;
                    }
                }];
            }
        });

    } else {
        self.activityIndicatorView.hidden = YES;
    }
}

- (UIView *)loadViewFromNib
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UINib *nib = [UINib nibWithNibName:@"ImageDownloadView" bundle:bundle];
    return [nib instantiateWithOwner:self options:nil][0];
}

@end