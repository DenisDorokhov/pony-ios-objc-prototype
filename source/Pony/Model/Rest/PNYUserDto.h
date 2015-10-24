//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAbstractDto.h"

typedef NS_ENUM(NSInteger, PNYRoleDto) {
    PNYRoleDtoUser,
    PNYRoleDtoAdmin,
};

@interface PNYUserDto : PNYAbstractDto

@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSDate *updateDate;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;

@property (nonatomic) PNYRoleDto role;

@end