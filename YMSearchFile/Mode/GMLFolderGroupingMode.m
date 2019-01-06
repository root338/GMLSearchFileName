//
//  GMLFolderGroupingMode.m
//  YMSearchFile
//
//  Created by GML on 2019/1/5.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLFolderGroupingMode.h"

@interface GMLFolderGroupingMode ()

/// 文件夹存在的文件
@property (nonatomic, strong) NSHashTable<YMFileMode *> *folderFileModeTable;
/// 文件夹需要外部的文件
@property (nonatomic, strong) NSMapTable<NSString *,NSHashTable<YMFileMode *> *> *includeOtherFolderFileModeMap;
/// 被其他文件夹引用的文件
@property (nonatomic, strong) NSHashTable<YMFileMode *> *citedOtherFolderFileModeTable;

@end

@implementation GMLFolderGroupingMode

- (void)addFileMode:(YMFileMode *)fileMode {
    [self.folderFileModeTable addObject:fileMode];
}

- (void)addIncludeFolder:(NSString *)includeFolder fileMode:(YMFileMode *)fileMode {
    [[self tableAtIncludeFolder:includeFolder] addObject:fileMode];
}

- (void)addIncludeFolder:(NSString *)includeFolder fileModeTable:(NSHashTable<YMFileMode *> *)fileModeTable {
    [[self tableAtIncludeFolder:includeFolder] unionHashTable:fileModeTable];
}

- (void)addCitedOtherFolderWithFileMode:(YMFileMode *)fileMode {
    [self.citedOtherFolderFileModeTable addObject:fileMode];
}

- (NSDictionary<NSString *,NSArray<YMFileMode *> *> *)transformWithMap:(NSMapTable<NSString *,NSHashTable<YMFileMode *> *> *)map {
    NSDictionary<NSString *,NSHashTable<YMFileMode *> *> *dict = [_includeOtherFolderFileModeMap dictionaryRepresentation];
    NSMutableDictionary<NSString *,NSArray<YMFileMode *> *> *tmpDict = NSMutableDictionary.dictionary;
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSHashTable * _Nonnull obj, BOOL * _Nonnull stop) {
        tmpDict[key] = obj.allObjects;
    }];
    return tmpDict;
}

#pragma mark - Getter & Setter
- (NSArray<YMFileMode *> *)allFileMode {
    return [self.folderFileModeTable allObjects];
}

- (NSDictionary<NSString *,NSArray<YMFileMode *> *> *)includeFileModeDict {
    return [self transformWithMap:_includeOtherFolderFileModeMap];
}

- (NSArray<YMFileMode *> *)citedFileModeArray {
    return [_citedOtherFolderFileModeTable allObjects];
}

- (NSHashTable<YMFileMode *> *)tableAtIncludeFolder:(NSString *)includeFolder {
    NSHashTable<YMFileMode *> *table = [_includeOtherFolderFileModeMap objectForKey:includeFolder];
    if (table != nil) {
        return table;
    }
    table = [[NSHashTable alloc] initWithOptions:NSHashTableWeakMemory capacity:0];
    [self.includeOtherFolderFileModeMap setObject:table forKey:includeFolder];
    return table;
}

- (NSHashTable<YMFileMode *> *)folderFileModeTable {
    if (_folderFileModeTable == nil) {
        _folderFileModeTable = [[NSHashTable alloc] initWithOptions:NSHashTableStrongMemory capacity:0];
    }
    return _folderFileModeTable;
}

- (NSMapTable<NSString *,NSHashTable<YMFileMode *> *> *)includeOtherFolderFileModeMap {
    if (_includeOtherFolderFileModeMap == nil) {
        _includeOtherFolderFileModeMap = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory capacity:0];
    }
    return _includeOtherFolderFileModeMap;
}

- (NSHashTable<YMFileMode *> *)citedOtherFolderFileModeTable {
    if (_citedOtherFolderFileModeTable == nil) {
        _citedOtherFolderFileModeTable = [[NSHashTable alloc] initWithOptions:NSHashTableWeakMemory capacity:0];
    }
    return _citedOtherFolderFileModeTable;
}

@end
