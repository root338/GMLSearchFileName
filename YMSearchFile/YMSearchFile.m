//
//  YMSearchFile.m
//  YMSearchFile
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019 apple. All rights reserved.
//

#import "YMSearchFile.h"

#import "YMFileMode.h"

@interface YMSearchFile ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, YMFileMode *> *fileModeDict;

@end

@implementation YMSearchFile

- (NSDictionary<NSString *,YMFileMode *> *)searchPath:(NSString *)path {
    [self searchAtPath:path];
    return self.fileModeDict;
}

- (void)searchAtPath:(NSString *)path {
    if ([self.ignoreSearchPathSet containsObject:path]) {
        return;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = YES;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDirectory]) {
        return;
    }
    if (!isDirectory) {
        [self addFilePath:path];
    }else {
        NSArray *list = [fileManager contentsOfDirectoryAtPath:path error:nil];
        for (NSString *name in list) {
            if ([name hasPrefix:@"."]) {
                continue;
            }
            [self searchPath:[path stringByAppendingPathComponent:name]];
        }
    }
}

- (void)addFilePath:(NSString *)filePath {
    YMFileMode *fileMode = [self fileModeAtFilePath:filePath];
    if (fileMode == nil) {
        return;
    }
    
    __weak __block typeof(self) weakself = self;
    [self.delegate searchFile:self parserFilePath:filePath result:^(NSSet<NSString *> *importFileNames) {
        [fileMode.includeFileNameSets unionSet:importFileNames];
        for (NSString *fileName in importFileNames) {
            YMFileMode *includeFileMode = [weakself fileModeAtFileName:fileName];
            [includeFileMode.citedFileNameSets addObject:filePath];
        }
    }];
}

- (YMFileMode *)fileModeAtFileName:(NSString *)fileName {
    YMFileMode *fileMode = self.fileModeDict[fileName];
    if (fileMode == nil) {
        fileMode = YMFileMode.new;
        fileMode.fileName = fileName;
        [self.fileModeDict setObject:fileMode forKey:fileName];
    }
    return fileMode;
}

- (YMFileMode *)fileModeAtFilePath:(NSString *)filePath {
    NSString *fileName = [[filePath lastPathComponent] stringByDeletingPathExtension];
    YMFileMode *fileMode = [self fileModeAtFileName:fileName];
    NSString *pathExtension = filePath.pathExtension;
    if ([pathExtension isEqualToString:@"h"]) {
        fileMode.hFilePath = filePath;
    }else if ([pathExtension isEqualToString:@"m"]) {
        fileMode.mFilePath = filePath;
    }else if ([pathExtension isEqualToString:@"swift"]) {
        fileMode.swiftFilePath = filePath;
    }else if ([pathExtension isEqualToString:@"xib"]) {
        fileMode.xibFilePath = filePath;
    }else {
        fileMode.otherFilePath = filePath;
    }
    return fileMode;
}

- (NSMutableDictionary<NSString *,YMFileMode *> *)fileModeDict {
    if (_fileModeDict == nil) {
        _fileModeDict = NSMutableDictionary.dictionary;
    }
    return _fileModeDict;
}

@end
