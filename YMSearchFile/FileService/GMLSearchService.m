//
//  GMLSearchService.m
//  YMSearchFile
//
//  Created by apple on 2019/1/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLSearchService.h"
#import "GMLFileMode.h"
#import "GMLFolderMode.h"
#import "GMLProjectMode.h"
#import "NSURL+GMLPathAdd.h"

const NSDirectoryEnumerationOptions GMLDirectorySkipHideAndPackage = NSDirectoryEnumerationSkipsHiddenFiles | NSDirectoryEnumerationSkipsPackageDescendants;

const NSDirectoryEnumerationOptions GMLDirectorySkipAll = NSDirectoryEnumerationSkipsHiddenFiles | NSDirectoryEnumerationSkipsPackageDescendants | NSDirectoryEnumerationSkipsSubdirectoryDescendants;

static NSDirectoryEnumerator<NSURL *> * enumerator(NSURL *targetURL, NSDirectoryEnumerationOptions options) {
    return [NSFileManager.defaultManager enumeratorAtURL:targetURL includingPropertiesForKeys:@[NSURLIsDirectoryKey] options:options errorHandler:nil];
}

@interface GMLSearchService ()
{
    BOOL _isNeedFolderStruct;
}

@property (nonatomic, strong) GMLProjectMode *(^projectMode) (void);

@end

@implementation GMLSearchService

- (GMLProjectMode *)searchFolderPathURL:(NSURL *)pathURL isNeedFolderStruct:(BOOL)isNeedFolderStruct {
    
    GMLProjectMode *projectMode = GMLProjectMode.new;
    self.projectMode = ^GMLProjectMode *{
        return projectMode;
    };
    _isNeedFolderStruct = isNeedFolderStruct && [self.delegate respondsToSelector:@selector(service:folder:)];
    
    id<GMLFolderProtocol> folder = [self _searchFolderPathURL:pathURL];
    self.projectMode = nil;
    
    if (_isNeedFolderStruct) {
        [self.delegate service:self folder:folder];
    }
    
    return projectMode;
}

- (id<GMLFolderProtocol>)_searchFolderPathURL:(NSURL *)pathURL {
    @autoreleasepool {
        BOOL isIgnore = NO;
        if ([self.delegate respondsToSelector:@selector(service:shouldIgnoreURL:)]) {
            isIgnore = [self.delegate service:self shouldIgnoreURL:pathURL];
        }
        if (isIgnore) {
            return nil;
        }
        NSDirectoryEnumerator<NSURL *> *directoryEnumeration = enumerator(pathURL, GMLDirectorySkipHideAndPackage);
        if (directoryEnumeration == nil) {
            return nil;
        }
        GMLFolderMode *folderMode = nil;
        if (_isNeedFolderStruct) {
            folderMode = [[GMLFolderMode alloc] initWithPathURL:pathURL];
            if (folderMode == nil) {
                return nil;
            }
        }
        for (NSURL *targetURL in directoryEnumeration) {
            GMLPathType pathType = targetURL.pathType;
            switch (pathType) {
                case GMLPathTypeNotFound:
                    continue;
                case GMLPathTypeFolder: {
                    id<GMLFolderProtocol> tmpFolder = [self _searchFolderPathURL:targetURL];
                    if (tmpFolder) {
                        [folderMode addFolder:tmpFolder];
                    }
                }
                    break;
                case GMLPathTypeFile: {
                    id<GMLFileProtocol> fileMode = [self createFileWithURL:targetURL];
                    if (fileMode) {
                        [folderMode addFile:fileMode];
                    }
                }
                    break;
            }
        }
        return folderMode;
    }
}

- (nullable id<GMLFileProtocol>)createFileWithURL:(NSURL *)targetURL {
    GMLFileMode *fileMode = [[GMLFileMode alloc] initWithPathURL:targetURL];
    if (fileMode == nil) {
        return nil;
    }
    [self.projectMode() addFile:fileMode];
    
    return fileMode;
}

//- (id<GMLFolderProtocol>)searchFolderPathURL:(NSURL *)pathURL options:(NSDirectoryEnumerationOptions)options {
//
//
//}

@end
