//
//  GMLSearchFileService.m
//  GMLRename
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLSearchFileService.h"

@implementation GMLSearchFileService

- (void)startSearchPath:(NSString *)targetPath {
    [self _searchPath:targetPath];
}

- (void)_searchPath:(NSString *)targetPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = YES;
    if (![fileManager fileExistsAtPath:targetPath isDirectory:&isDirectory]) {
        return;
    }
    
    if (!isDirectory) {
        [self.delegate service:self filePath:targetPath];
    }else {
        BOOL shouldIgnore = NO;
        if ([self.delegate respondsToSelector:@selector(service:shouldIgnoreFolderPath:)]) {
            shouldIgnore = [self.delegate service:self shouldIgnoreFolderPath:targetPath];
        }
        if (shouldIgnore) {
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(service:beginFolderPath:)]) {
            [self.delegate service:self beginFolderPath:targetPath];
        }
        NSArray *list = [fileManager contentsOfDirectoryAtPath:targetPath error:nil];
        for (NSString *name in list) {
            if ([self shouldIgnoreName:name]) {
                continue;
            }
            [self _searchPath:[targetPath stringByAppendingPathComponent:name]];
        }
        if ([self.delegate respondsToSelector:@selector(service:endFolderPath:)]) {
            [self.delegate service:self endFolderPath:targetPath];
        }
    }
}

- (BOOL)shouldIgnoreName:(NSString *)name {
    for (NSString *prefix in self.configuration.ignoreNamePrefixSet) {
        if ([name hasPrefix:prefix]) {
            return YES;
        }
    }
    for (NSString *suffix in self.configuration.ignoreNameSuffixSet) {
        if ([name hasSuffix:suffix]) {
            return YES;
        }
    }
    NSString *pathExtension = [name pathExtension];
    if (pathExtension.length > 0 && [self.configuration.ignorePathExtensionSet containsObject:pathExtension]) {
        return YES;
    }
    return NO;
}

- (GMLSearchFileConfiguration *)configuration {
    if (_configuration == nil) {
        _configuration = GMLSearchFileConfiguration.new;
        _configuration.ignoreNamePrefixSet = [NSSet setWithObjects:@".", nil];
    }
    return _configuration;
}

@end
