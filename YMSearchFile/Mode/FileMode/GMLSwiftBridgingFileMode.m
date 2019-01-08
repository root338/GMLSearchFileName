//
//  GMLSwiftBridgingFileMode.m
//  YMSearchFile
//
//  Created by apple on 2019/1/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLSwiftBridgingFileMode.h"

@interface GMLSwiftBridgingFileMode ()

@property (nonatomic, strong) id<GMLFileProtocol> file;

@end

@implementation GMLSwiftBridgingFileMode

- (instancetype)initWithFile:(id<GMLFileProtocol>)file {
    self = [super init];
    if (self) {
        _file = file;
    }
    return self;
}

- (void)addFile:(id<GMLFileProtocol>)file {
}

- (NSArray<id<GMLFileProtocol>> *)fileArray {
    return @[_file];
}

@end
