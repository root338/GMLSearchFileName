//
//  GMLClassMode.m
//  YMSearchFile
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLClassMode.h"

@interface GMLClassMode ()

@property (nonatomic, strong, readwrite) NSString *className;

@end

@implementation GMLClassMode

- (instancetype)initWithClassName:(NSString *)className {
    self = [super init];
    if (self) {
        _className = className;
    }
    return self;
}



@end
