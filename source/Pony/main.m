//
//  main.m
//  Pony
//
//  Created by Denis Dorokhov on 11/10/15.
//  Copyright © 2015 Denis Dorokhov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNYAppDelegate.h"
#import "PNYTestDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        if (NSClassFromString(@"XCTestCase") == nil) {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([PNYAppDelegate class]));
        } else {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([PNYTestDelegate class]));
        }
    }
}
