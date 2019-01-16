//
//  GMLClassExtensionText.m
//  GMLRename
//
//  Created by GML on 2019/1/16.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLClassExtensionText.h"

@interface GMLClassExtensionText ()

@property (nonatomic, strong, readwrite) NSString *extensionName;

@end

@implementation GMLClassExtensionText

- (instancetype)initWithClassSection:(GMLClassSection)classSection name:(NSString *)className categoryName:(NSString *)categoryName result:(NSTextCheckingResult *)result {
    self = [super initWithClassSection:classSection name:className result:result];
    if (self) {
        _extensionName = categoryName;
    }
    return self;
}

@end
