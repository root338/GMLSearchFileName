//
//  GMLPackageService.m
//  GMLRename
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLPackageService.h"

@interface GMLPackageService ()

@property (nonatomic, strong, readwrite) NSString *packagePath;
@property (nonatomic, strong) NSMutableSet<GMLFileService *> *fileServiceSet;
@end

@implementation GMLPackageService

- (instancetype)initWithPackagePath:(NSString *)packagePath {
    self = [super init];
    if (self) {
        _packagePath = packagePath;
    }
    return self;
}

- (void)addFileService:(GMLFileService *)fileService {
    [self.fileServiceSet addObject:fileService];
}

- (BOOL)containsFileService:(GMLFileService *)fileService {
    return [_fileServiceSet containsObject:fileService];
}

- (NSMutableSet<GMLFileService *> *)fileServiceSet {
    if (_fileServiceSet == nil) {
        _fileServiceSet = NSMutableSet.set;
    }
    return _fileServiceSet;
}

@end
