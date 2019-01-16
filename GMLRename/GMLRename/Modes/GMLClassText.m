//
//  GMLClassText.m
//  GMLRename
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLClassText.h"
#import "GMLClassExtensionText.h"

@interface GMLClassText ()

@property (nonatomic, strong, readwrite) NSString *mSuperClassName;

@end

@implementation GMLClassText

- (instancetype)initWithClassSection:(GMLClassSection)classSection name:(NSString *)className superClassName:(NSString *)superClassName result:(NSTextCheckingResult *)result {
    self = [super initWithClassSection:classSection name:className result:result];
    if (self) {
        _mSuperClassName = superClassName;
    }
    return self;
}

@end
