//
//  GMLFolderMode.m
//  YMSearchFile
//
//  Created by apple on 2019/1/7.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLFolderMode.h"
#import "NSURL+GMLPathAdd.h"

@interface GMLFolderMode ()

@property (nonatomic, strong, readwrite) NSURL *pathURL;
@property (nonatomic, assign, readwrite) GMLFolderType folderType;
@property (nonatomic, strong) NSMapTable<NSString *, id<GMLFileProtocol>> *fileMapTable;
@property (nonatomic, strong) NSMapTable<NSString *, id<GMLFolderProtocol>> *folderMapTable;

@end

@implementation GMLFolderMode

- (nullable instancetype)initWithPathURL:(nonnull NSURL *)pathURL {
    GMLFolderType folderType = pathURL.folderType;
    switch (folderType) {
        case GMLFolderTypeNotFound:
        case GMLFolderTypeNotDirectory:
            return nil;
        default:
            break;
    }
    self = [super init];
    if (self) {
        _pathURL = pathURL;
        _folderType = folderType;
    }
    return self;
}

- (void)addFile:(nonnull id<GMLFileProtocol>)file {
    [self.fileMapTable setObject:file forKey:file.pathURL.lastPathComponent];
}

- (void)addFolder:(nonnull id<GMLFolderProtocol>)folder {
    [self.folderMapTable setObject:folder forKey:folder.pathURL.lastPathComponent];
}

- (id<GMLFolderProtocol>)folderAtURL:(NSURL *)URL {
    if ([self.pathURL isEqual:URL]) {
        return self;
    }else {
        NSArray<NSString *> *folderList = [self.pathURL folderListAtToPath:URL];
        if (folderList == nil) {
            return nil;
        }
        else if (folderList.count == 0) {
            return self;
        }else {
            return [self.folderMapTable objectForKey:folderList.firstObject];
        }
    }
}

- (id<GMLFileProtocol>)fileAtURL:(NSURL *)URL {
    NSArray<NSString *> *folderList = [self.pathURL folderListAtToPath:URL];
    if (folderList == nil) {
        return nil;
    }
    else if (folderList.count == 0) {
        return [_fileMapTable objectForKey:URL.lastPathComponent];
    }else {
        return [self.fileMapTable objectForKey:folderList.firstObject];
    }
}

#pragma mark - Getter & Setter
- (NSArray<id<GMLFileProtocol>> *)fileArray {
    return _fileMapTable ? NSAllMapTableValues(_fileMapTable) : nil;
}
- (NSArray<id<GMLFolderProtocol>> *)folderArray {
    return _folderMapTable ? NSAllMapTableValues(_folderMapTable) : nil;
}

- (NSMapTable<NSString *,id<GMLFileProtocol>> *)fileMapTable {
    if (_fileMapTable == nil) {
        _fileMapTable = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory capacity:0];
    }
    return _fileMapTable;
}

- (NSMapTable<NSString *,id<GMLFolderProtocol>> *)folderMapTable {
    if (_folderMapTable == nil) {
        _folderMapTable = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory capacity:0];
    }
    return _folderMapTable;
}

@end
