//
//  YMFileManager.m
//  YMSearchFile
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019 apple. All rights reserved.
//

#import "YMFileManager.h"
#import "YMFileMode.h"
#import "YMProjectMode.h"
#import "YMParserFileImport.h"

#import "YMSearchFile.h"

@interface YMFileManager ()<YMSearchFileDelegate>

@property (nonatomic, strong) NSMutableDictionary<NSString *, YMFileMode *> *fileModeDict;

@property (nonatomic, strong) YMParserFileImport *parserFileImport;

//@property (nonatomic, strong) NSArray *supportPathExtensionList;
@property (nonatomic, strong) YMProjectMode *projectMode;

@property (nonatomic, strong) NSMutableSet<YMFileMode *> *tmpFileModeSet;
@property (nonatomic, strong) NSMutableSet<NSString *> *ignoreFileNameSet;

@property (nonatomic, strong) YMSearchFile *searchFileService;
@property (nonatomic, strong) YMParserFileImport *parserFileService;
@end

@implementation YMFileManager

+ (YMFileManager *)defaultManager {
    static YMFileManager *defaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultManager = YMFileManager.new;
    });
    return defaultManager;
}

#pragma mark - YMSearchFileDelegate
- (void)searchFile:(YMSearchFile *)searchFile parserFilePath:(NSString *)filePath result:(void (^)(NSSet<NSString *> * _Nonnull))result {
    [self.parserFileService parserImportWithFilePath:filePath result:result];
}

#pragma mark - 搜索文件
- (void)traversingPath:(NSString *)path {
    [self.searchFileService searchPath:path];
}

#pragma mark - 输出文件
- (NSMutableDictionary *)inputAllFileMode {
    
    NSMutableDictionary *dict = NSMutableDictionary.dictionary;
    [self resetRemoveFileBlackList];
    
    [_fileModeDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, YMFileMode * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.hFilePath != nil) {
            NSNumber *numberKey = @(obj.citedFileNameSets.count);
            NSMutableArray *list = dict[numberKey];
            if (list == nil) {
                list = NSMutableArray.array;
                dict[numberKey] = list;
            }
            
            if (self.removeNotIncludeFileName && obj.citedFileNameSets.count == 0) {
                [self removeFileMode:obj];
            }
            [list addObject:[NSString stringWithFormat:@"%@\n%@",obj.fileName, obj.hFilePath]];
        }
    }];
    NSLog(@"忽略文件名列表: \n%@", [self.ignoreFileNameSet.allObjects componentsJoinedByString:@"\n"]);
    return dict;
}

#pragma mark - 删除文件
- (void)removeFileMode:(YMFileMode *)fileMode {
    if (fileMode.swiftFilePath) {
        return;
    }
    if ([self.ignoreFileNameSet containsObject:fileMode.fileName]) {
        return;
    }
    
//    [[NSFileManager defaultManager] removeItemAtPath:fileMode.hFilePath error:nil];
//    if (fileMode.mFilePath) {
//        [[NSFileManager defaultManager] removeItemAtPath:fileMode.mFilePath error:nil];
//    }
//    if (fileMode.xibFilePath) {
//        [[NSFileManager defaultManager] removeItemAtPath:fileMode.xibFilePath error:nil];
//    }
//    // \. 正则中单独的"."表示匹配任意字符，所以需要转义
//    [self.projectMode deleteFileName:[fileMode.fileName stringByAppendingString:@"\\."] fileExtension:nil];
}

- (void)resetRemoveFileBlackList {
    NSMutableSet *ignoreList = NSMutableSet.set;
    
    if (self.removeFileNameBlackList) {
        [ignoreList unionSet:self.removeFileNameBlackList];
    }
    if (self.removeFileNameAndIncludeBlackList) {
        self.tmpFileModeSet = NSMutableSet.set;
        [self recursiveRelationFileNames:self.removeFileNameAndIncludeBlackList set:ignoreList];
        self.tmpFileModeSet = nil;
    }
    self.ignoreFileNameSet = ignoreList;
    
}

- (void)recursiveRelationFileNames:(NSSet *)fileNames set:(NSMutableSet *)set {
    for (NSString *name in fileNames) {
        YMFileMode *obj = self.fileModeDict[name];
        if (obj == nil || [self.tmpFileModeSet containsObject:obj]) {
            continue;
        }
        [self.tmpFileModeSet addObject:obj];
        [set addObject:name];
        [self recursiveRelationFileNames:obj.includeFileNameSets set:set];
    }
}

- (NSMutableDictionary<NSString *,YMFileMode *> *)fileModeDict {
    if (_fileModeDict == nil) {
        _fileModeDict = NSMutableDictionary.dictionary;
    }
    return _fileModeDict;
}

- (YMParserFileImport *)parserFileImport {
    if (_parserFileImport == nil) {
        _parserFileImport = YMParserFileImport.new;
    }
    return _parserFileImport;
}

- (NSString *)projectFilePath {
    return self.projectMode.projectFilePath;
}

- (void)setProjectFilePath:(NSString *)projectFilePath {
    self.projectMode.projectFilePath = projectFilePath;
}

- (YMProjectMode *)projectMode {
    if (_projectMode == nil) {
        _projectMode = YMProjectMode.new;
    }
    return _projectMode;
}

- (NSString *)projectTextContent {
    return self.projectMode.projectTextContent;
}

- (YMSearchFile *)searchFileService {
    if (_searchFileService == nil) {
        _searchFileService = YMSearchFile.new;
    }
    return _searchFileService;
}

- (YMParserFileImport *)parserFileService {
    if (_parserFileService == nil) {
        _parserFileService = YMParserFileImport.new;
    }
    return _parserFileService;
}

@end
