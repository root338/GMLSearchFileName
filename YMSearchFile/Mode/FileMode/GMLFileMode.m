//
//  GMLFileMode.m
//  YMSearchFile
//
//  Created by apple on 2019/1/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLFileMode.h"
#import "NSURL+GMLPathAdd.h"

@interface GMLFileMode ()

@property (nonatomic, assign, readwrite) GMLFileType fileType;
@property (nonatomic, strong, readwrite) NSURL *pathURL;

@end

@implementation GMLFileMode

- (instancetype)initWithPathURL:(NSURL *)pathURL {
    GMLFileType folderType = pathURL.fileType;
    switch (folderType) {
        case GMLFileTypeNotFound:
        case GMLFileTypeNotFile:
            return nil;
        default: break;
    }
    self = [super init];
    if (self) {
        _pathURL = pathURL;
        _fileType = pathURL.fileType;
    }
    return self;
}

@end
