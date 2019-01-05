//
//  YMFileMode.m
//  YMSearchFile
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019 apple. All rights reserved.
//

#import "YMFileMode.h"
#import "GMLFileConstants.h"

static NSString * typeAtPathExtension(NSString *path) {
    NSString *pathExtension = [path.pathExtension lowercaseString];
    if ([pathExtension isEqualToString:GMLHTypeFile]) {
        return GMLHTypeFile;
    }else if ([pathExtension isEqualToString:GMLMTypeFile]) {
        return GMLMTypeFile;
    }else if ([pathExtension isEqualToString:GMLXIBTypeFile]) {
        return GMLXIBTypeFile;
    }else if ([pathExtension isEqualToString:GMLSWIFTTypeFile]) {
        return GMLSWIFTTypeFile;
    }else {
        return nil;
    }
}

@interface YMFileMode ()

@property (nonatomic, copy, readwrite) NSString *fileName;

@property (nonatomic, copy) NSMutableDictionary<NSString *, NSString *> *supportPathDict;

@property (nonatomic, copy) NSMutableSet<NSString *> *filePaths;

@end

@implementation YMFileMode

- (instancetype)initWithFileName:(NSString *)fileName {
    self = [super init];
    if (self) {
        _fileName = fileName;
    }
    return self;
}

+ (instancetype)createWithFilePath:(NSString *)filePath {
    NSString *fileName = [[filePath lastPathComponent] stringByDeletingPathExtension];
    YMFileMode *fileMode = [[self alloc] initWithFileName:fileName];
    [fileMode addFileRelationPath:filePath];
    return fileMode;
}

- (NSSet<NSString *> *)filePathsWithTypes:(NSArray<NSString *> *)types {
    if (types.count == 0) {
        return nil;
    }
    NSMutableSet *filePaths = NSMutableSet.set;
    [types enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *filePath = self.supportPathDict[obj];
        if (filePath != nil) {
            [filePaths addObject:[filePath copy]];
        }
    }];
    return filePaths.count? filePaths : nil;
}

- (void)addFileRelationPath:(NSString *)path {
    NSString *key = typeAtPathExtension(path);
    if (key != nil) {
        NSString *existFile = _supportPathDict[key];
        if (existFile) {
            [self.filePaths removeObject:existFile];
        }
        self.supportPathDict[key] = path;
    }
    [self.filePaths addObject:path];
}

- (void)removePath:(NSString *)path {
    if (path == nil) {
        return;
    }
    [self.filePaths removeObject:path];
    NSString *key = typeAtPathExtension(path);
    if (key != nil) {
        NSString *existFile = _supportPathDict[key];
        if ([existFile isEqualToString:path]) {
            [_supportPathDict removeObjectForKey:key];
        }
    }
}

- (BOOL)containsPathExtension:(NSString *)pathExtension {
    NSString *lowercasePathExtension = [pathExtension lowercaseString];
    for (NSString *filePath in self.filePaths) {
        NSString *extension = [[filePath pathExtension] lowercaseString];
        if ([extension isEqualToString:lowercasePathExtension]) {
            return YES;
        }
    }
    return NO;
}

- (NSHashTable<YMFileMode *> *)citedFileNameTable {
    if (_citedFileNameTable == nil) {
        _citedFileNameTable = [[NSHashTable alloc] initWithOptions:NSHashTableWeakMemory capacity:0];
    }
    return _citedFileNameTable;
}

- (NSHashTable<YMFileMode *> *)includeFileNameTable {
    if (_includeFileNameTable == nil) {
        _includeFileNameTable = [[NSHashTable alloc] initWithOptions:NSHashTableWeakMemory capacity:0];
    }
    return _includeFileNameTable;
}

- (NSMutableSet<NSString *> *)filePaths {
    if (_filePaths == nil) {
        _filePaths = NSMutableSet.set;
    }
    return _filePaths;
}

- (NSMutableDictionary<NSString *,NSString *> *)supportPathDict {
    if (_supportPathDict == nil) {
        _supportPathDict = NSMutableDictionary.dictionary;
    }
    return _supportPathDict;
}

- (NSString *)hFilePath {
    return [_supportPathDict[GMLHTypeFile] copy];
}

- (NSString *)mFilePath {
    return [_supportPathDict[GMLMTypeFile] copy];
}

- (NSString *)xibFilePath {
    return [_supportPathDict[GMLXIBTypeFile] copy];
}

- (NSString *)swiftFilePath {
    return [_supportPathDict[GMLSWIFTTypeFile] copy];
}

- (NSSet<NSString *> *)allRelationPathSet {
    return [_filePaths copy];
}

@end
