//
//  GMLFolderMode.m
//  YMSearchFile
//
//  Created by apple on 2019/1/7.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLFolderMode.h"
#import "GMLFileProtocol.h"
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

- (void)addFile:(id<GMLFileProtocol>)file {
    if (file == nil) {
        return;
    }
    [self.fileMapTable setObject:file forKey:file.pathURL.lastPathComponent];
}

- (void)addFolder:(id<GMLFolderProtocol>)folder {
    if (folder == nil) {
        return;
    }
    [self.folderMapTable setObject:folder forKey:folder.pathURL.lastPathComponent];
}

- (id<GMLFolderProtocol>)addFolderWithName:(NSString *)folderName {
   
    id<GMLFolderProtocol> targetFolder = [self.folderMapTable objectForKey:folderName];
    if (targetFolder != nil) {
        return targetFolder;
    }
    GMLFolderMode *folderMode = [[GMLFolderMode alloc] initWithPathURL:[self.pathURL URLByAppendingPathComponent:folderName]];
    if (folderMode == nil) {
        return nil;
    }
    [self addFolder:folderMode];
    return folderMode;
}

- (id<GMLFolderProtocol>)addFolderWithPath:(NSURL *)path isDirectory:(BOOL *)isDirectory {
    
    id<GMLFolderProtocol> lateFolder = [self getOfLateFolderAtURL:path];
    if (lateFolder == nil) {
        return nil;
    }
    
    NSArray<NSString *> *folderList = [lateFolder.pathURL folderListAtToPath:path];
    id<GMLFolderProtocol> folderMode = lateFolder;
    for (NSString *folderName in folderList) {
        folderMode = [folderMode addFolderWithName:folderName];
        if (folderMode == nil) {
            return nil;
        }
    }
    if (isDirectory != NULL) {
        *isDirectory = path.pathType == GMLPathTypeFolder;
    }
    return folderMode;
}

- (id<GMLFolderProtocol>)getOfLateFolderAtURL:(NSURL *)URL {
    NSArray<NSString *> *folderList = [self.pathURL folderListAtToPath:URL];
    if (folderList == nil) {
        return nil;
    }
    if (folderList.count == 0) {
        return self;
    }
    id<GMLFolderProtocol> folder = [self folderAtName:folderList.firstObject];
    if (folder == nil) {
        return self;
    }
    return folder;
}

- (id<GMLFolderProtocol>)folderAtName:(NSString *)folderName {
    return folderName? [self.folderMapTable objectForKey:folderName] : nil;
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

- (id<GMLFileProtocol>)fileAtName:(NSString *)fileName {
    return fileName? [self.fileMapTable objectForKey:fileName] : nil;
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
