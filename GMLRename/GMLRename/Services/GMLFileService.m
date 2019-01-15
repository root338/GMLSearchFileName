//
//  GMLFileService.m
//  GMLRename
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLFileService.h"

@interface GMLFileService ()

@property (nonatomic, strong, readwrite) NSString *fileName;
@property (nonatomic, strong) NSMutableSet<NSString *> *filePathSet;
@end

@implementation GMLFileService

- (instancetype)initWithFileName:(NSString *)fileName {
    self = [super init];
    if (self) {
        _fileName = fileName;
    }
    return self;
}

- (BOOL)addFilePath:(NSString *)filePath {
    if (![[filePath.lastPathComponent stringByDeletingLastPathComponent] isEqualToString:_fileName]) {
        return NO;
    }
    [self.filePathSet addObject:filePath];
    return YES;
}

- (NSMutableSet<NSString *> *)filePathSet {
    if (_filePathSet == nil) {
        _filePathSet = NSMutableSet.set;
    }
    return _filePathSet;
}

@end
