//
//  GMLFolderService.m
//  YMSearchFile
//
//  Created by GML on 2019/1/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLFolderService.h"
#import "NSString+GMLPathTools.h"

@interface GMLFolderService ()

@property (nonatomic, assign, readwrite) GMLFolderType folderType;
@property (nonatomic, strong, readwrite) NSString *folderPath;
@property (nonatomic, strong) NSHashTable<NSString *> *fileTable;
@property (nonatomic, strong) NSHashTable<GMLFolderService *> *folderModeTable;

@end

@implementation GMLFolderService

- (instancetype)initWithFolderPath:(NSString *)folderPath {
    GMLFolderType folderType = folderPath.folderType;
    switch (folderType) {
        case GMLFolderTypeNotFound:
        case GMLFolderTypeNotDirectory:
            return nil;
        default:
            break;
    }
    self = [super init];
    if (self) {
        _folderType = folderType;
        _folderPath = folderPath;
    }
    return self;
}

- (BOOL)containsPath:(NSString *)path {
    if ([path hasPrefix:self.folderPath]) {
        if (path.pathType != GMLPathTypeNotFound) {
            return YES;
        }
    }
    return NO;
}

//- (NSString *)addFilePath:(NSString *)filePath {
//    if (filePath.pathType == GMLPathTypeNotFound) {
//        return nil;
//    }
//    if (![filePath hasPrefix:_folderPath]) {
//        return nil;
//    }
//}
//
//- (BOOL)addFolderMode:(GMLFolderService *)folderMode {
//
//    [self.folderModeTable addObject:folderMode];
//}
//
//- (BOOL)addPath:(NSString *)path {
//    GMLPathType pathType = path.pathType;
//    if (pathType == GMLPathTypeNotFound) {
//        return NO;
//    }
//    if (![path hasPrefix:_folderPath]) {
//        return NO;
//    }
//    NSArray *folderList = [NSString folderListAtFromPath:_folderPath toPath:path];
//
//}

- (NSArray *)pathListWithType:(GMLPathType)pathType {
    NSArray<NSString *> *contents = [NSFileManager.defaultManager contentsOfDirectoryAtPath:_folderPath error:nil];
    NSMutableArray *list = NSMutableArray.array;
    for (NSString *path in contents) {
        NSString *fullPath = [_folderPath stringByAppendingPathComponent:path];
        if (fullPath.pathType == pathType) {
            [list addObject:fullPath];
        }
    }
    return list;
}

#pragma mark - Getter & Setter
- (NSArray<NSString *> *)filePathArrays {
    return [_fileTable allObjects];
}

- (NSArray<GMLFolderService *> *)folderModes {
    return [_folderModeTable allObjects];
}

- (NSHashTable<NSString *> *)fileTable {
    if (_fileTable == nil) {
        NSArray<NSString *> *fileList = [self pathListWithType:GMLPathTypeFile];
        _fileTable = [[NSHashTable alloc] initWithOptions:NSHashTableStrongMemory capacity:fileList.count];
        for (NSString *filePath in _fileTable) {
            [_fileTable addObject:filePath];
        }
    }
    return _fileTable;
}

- (NSHashTable<GMLFolderService *> *)folderModeTable {
    if (_folderModeTable == nil) {
        NSArray<NSString *> *folderList = [self pathListWithType:GMLPathTypeFolder];
        _folderModeTable = [[NSHashTable alloc] initWithOptions:NSHashTableStrongMemory capacity:folderList.count];
        for (NSString *folderPath in folderList) {
            GMLFolderService *folderMode = [[GMLFolderService alloc] initWithFolderPath:folderPath];
            [_folderModeTable addObject:folderMode];
        }
    }
    return _folderModeTable;
}

@end
