//
//  YMXcodeProjectFileService.m
//  YMSearchFile
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019 apple. All rights reserved.
//

#import "YMXcodeProjectFileService.h"
#import "YMFileMode.h"
#import "YMProjectMode.h"
#import "GMLFileConstants.h"

#import "GMLLogService.h"
#import "GMLFilterService.h"
#import "YMParserFileService.h"
#import "YMSearchFileService.h"
#import "GMLDeleteFileService.h"
#import "GMLFileGroupingService.h"

@interface YMXcodeProjectFileService ()<YMSearchFileServiceDelegate>
#pragma mark - 服务
/// 搜索文件服务
@property (nonatomic, strong) YMSearchFileService *searchFileService;
/// 解析文件服务
@property (nonatomic, strong) YMParserFileService *parserFileService;
/// 文件分组服务
@property (nonatomic, strong) GMLFileGroupingService *fileGroupingService;
/// 删除文件服务
@property (nonatomic, strong) GMLDeleteFileService *deleteFileService;
/// 过滤器
@property (nonatomic, strong) GMLFilterService *filterService;

@property (nonatomic, strong) GMLLogService *logService;

#pragma mark - 关联配置
/// 关联项目模型
@property (nonatomic, strong) YMProjectMode *projectMode;

#pragma mark - 存储变量
/// 文件列表
@property (nonatomic, strong) NSDictionary<NSString *, YMFileMode *> *fileModeDict;

@end

@implementation YMXcodeProjectFileService

//+ (YMXcodeProjectFileService *)defaultManager {
//    static YMXcodeProjectFileService *defaultManager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        defaultManager = YMXcodeProjectFileService.new;
//    });
//    return defaultManager;
//}

- (void)traversingPath:(NSString *)path {
    
    self.fileModeDict = [self.searchFileService searchPath:path ignorePathSet:self.ignoreSearchPathSet error:nil];
    [self parserAllFileModeImportFile];
}

- (void)parserAllFileModeImportFile {
    NSDictionary<NSString *, YMFileMode *> *fileModeDict = self.fileModeDict;
    [fileModeDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, YMFileMode * _Nonnull obj, BOOL * _Nonnull stop) {
        NSSet<NSString *> *filePathSet = obj.allRelationPathSet;
        if (filePathSet != nil) {
            NSHashTable *includeFileNameTable = [[NSHashTable alloc] initWithOptions:NSHashTableWeakMemory capacity:0];
            for (NSString *filePath in filePathSet) {
                NSSet *includeSet = [self.parserFileService parserImportFileWithFilePath:filePath];
                [includeSet enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                    YMFileMode *fileMode = self.fileModeDict[obj];
                    [includeFileNameTable addObject:fileMode];
                }];
            }
            [obj.includeFileNameTable unionHashTable:includeFileNameTable];
            NSEnumerator *enumerator = includeFileNameTable.objectEnumerator;
            YMFileMode *fileMode = enumerator.nextObject;
            while (fileMode) {
                [fileMode.citedFileNameTable addObject:obj];
                fileMode = enumerator.nextObject;
            }
        }
    }];
}

- (void)removeFileAtMaxCitedFileNumber:(NSUInteger)maxCitedFileNumber {
    
    __block NSUInteger minCitedCount = 0;
    __block NSUInteger maxCitedCount = 0;
    
    NSSet *supportPathExtension = [NSSet setWithObjects:GMLHTypeFile, nil];
    NSDictionary<NSNumber *,NSSet<YMFileMode *> *> *fileModeGroupingDict = [self accordingToCitedGroupingFileWithSupportPathExtensionSet:supportPathExtension completion:^(NSUInteger minCitedCount, NSUInteger maxCitedCount) {
        minCitedCount = minCitedCount;
        maxCitedCount = maxCitedCount;
    }];
    if (fileModeGroupingDict == nil || minCitedCount > maxCitedFileNumber) {
        return;
    }
    
    NSMutableSet *deleteFileModeSet = NSMutableSet.set;
    for (NSInteger i = 0; i <= MIN(maxCitedCount, maxCitedCount); i++) {
        NSNumber *key = @(i);
        NSSet *fileModeSet = fileModeGroupingDict[key];
        if (fileModeSet) {
            [deleteFileModeSet unionSet:fileModeSet];
        }
    }
    
    if (deleteFileModeSet.count == 0) {
        return;
    }
    NSSet<YMFileMode *> *ignoreFileModeSet = [self ignoreRemoveFileModeSet];
    [deleteFileModeSet minusSet:ignoreFileModeSet];
    
    [self.deleteFileService deleteFileSet:deleteFileModeSet fileIndexPath:self.fileIndexPath];
}

#pragma mark - 打印日志
- (void)outputCitedNumberLogWithFolderPath:(NSString *)folderPath {
    NSDictionary<NSNumber *,NSSet<YMFileMode *> *> *fileModeGroupingDict = [self accordingToCitedGroupingFileWithSupportPathExtensionSet:[NSSet setWithObjects:GMLHTypeFile, nil] completion:nil];
    [self.logService outputCitedGroupingFileModeData:fileModeGroupingDict folderPath:folderPath];
}

- (void)outputFolderGroupingLogWithFolderPath:(NSString *)folderPath baseFolderSet:(NSSet<NSString *> *)baseFolderSet {
    NSDictionary<NSString *, GMLFolderGroupingMode *> *folderGroupingDict = [self accordingToCitedGroupingFileWithSupportPathExtensionSet:[NSSet setWithObjects:GMLHTypeFile, nil] baseFolderSet:baseFolderSet ignoreBasePathSet:nil];
    [self.logService outputFolderGroupingDict:folderGroupingDict folderPath:folderPath];
}

- (void)outputFolderGroupingLogWithFolderPath:(NSString *)folderPath baseFolderSet:(nonnull NSSet<NSString *> *)baseFolderSet ignoreFolderSet:(nonnull NSSet<NSString *> *)ignoreFolderSet {
    
    NSSet<YMFileMode *> *fileModeSet = [self.filterService fileModeSet:[NSSet setWithArray:self.fileModeDict.allValues] filterIncludePathExtensions:[NSSet setWithObjects:GMLHTypeFile, nil]];
    [self.fileGroupingService accordingToBasePathGroupingFileWithFileModeSet:fileModeSet shouldDeletePathSet:ignoreFolderSet];
    [self.logService outputCitedGroupingFileModeData:@{@(0) : fileModeSet} folderPath:folderPath];
}

#pragma mark - 忽略文件处理
- (NSSet<YMFileMode *> *)ignoreRemoveFileModeSet {
    NSMutableSet *ignoreFileModeSet = NSMutableSet.set;
    
    __weak typeof(self) weakSelf    = self;
    void (^addFileMode) (NSString *) = ^(NSString *fileName) {
        YMFileMode *fileMode = weakSelf.fileModeDict[fileName];
        !fileMode?: [ignoreFileModeSet addObject:fileMode];
    };
    for (NSString *fileName in self.ignoreRemoveFileNameSet) {
        addFileMode(fileName);
    }
    if (self.ignoreRemoveFileAndIncludeFileNameSet) {
        NSHashTable *ignoreFileModeTable = [[NSHashTable alloc] initWithOptions:NSHashTableWeakMemory capacity:0];
        for (NSString *ignoreFileName in self.ignoreRemoveFileAndIncludeFileNameSet) {
            YMFileMode *fileMode = self.fileModeDict[ignoreFileName];
            if (fileMode != nil) {
                [ignoreFileModeTable addObject:fileMode];
            }
        }
        [self recursiveFileNames:ignoreFileModeTable saveSet:ignoreFileModeSet didCacheFileNames:[[NSHashTable alloc] initWithOptions:NSHashTableWeakMemory capacity:0]];
    }
    
    return ignoreFileModeSet;
}

- (void)recursiveFileNames:(NSHashTable<YMFileMode *> *)fileNames saveSet:(NSMutableSet<YMFileMode *> *)saveSet didCacheFileNames:(NSHashTable<YMFileMode *> *)didCacheFileNameSet {
    [fileNames minusHashTable:didCacheFileNameSet];
    [didCacheFileNameSet unionHashTable:fileNames];
    NSEnumerator *enumerator = fileNames.objectEnumerator;
    for (YMFileMode *fileMode = enumerator.nextObject; fileMode; fileMode = enumerator.nextObject) {
        [saveSet addObject:fileMode];
        if (fileMode.includeFileNameTable.count > 0) {
            [self recursiveFileNames:fileMode.includeFileNameTable saveSet:saveSet didCacheFileNames:didCacheFileNameSet];
        }
    }
}

#pragma mark - 分组过滤文件
- (NSDictionary<NSNumber *, NSSet<YMFileMode *> *> *)accordingToCitedGroupingFileWithSupportPathExtensionSet:(NSSet<NSString *> *)supportPathExtensionSet completion:(void (NS_NOESCAPE ^ _Nullable) (NSUInteger minCitedCount, NSUInteger maxCitedCount))completion {
    
    NSSet<YMFileMode *> *fileModeSet = [self.filterService fileModeSet:[NSSet setWithArray:self.fileModeDict.allValues] filterIncludePathExtensions:supportPathExtensionSet];
    NSDictionary<NSNumber *,NSSet<YMFileMode *> *> *fileModeGroupingDict = [self.fileGroupingService accordingToCitedGroupingFileWithFileModeSet:fileModeSet completion:completion];
    return fileModeGroupingDict;
}

- (NSDictionary<NSString *, GMLFolderGroupingMode *> *)accordingToCitedGroupingFileWithSupportPathExtensionSet:(NSSet<NSString *> *)supportPathExtensionSet baseFolderSet:(NSSet<NSString *> *)baseFolderSet ignoreBasePathSet:(NSSet<NSString *> *)ignoreBasePathSet {
    NSSet<YMFileMode *> *fileModeSet = [self.filterService fileModeSet:[NSSet setWithArray:self.fileModeDict.allValues] filterIncludePathExtensions:supportPathExtensionSet];
    NSDictionary<NSString *, GMLFolderGroupingMode *> *folderGroupingDict = [self.fileGroupingService accordingToBasePathGroupingFileWithFileModeSet:fileModeSet basePathSet:baseFolderSet ignoreBasePathSet:ignoreBasePathSet];
    return folderGroupingDict;
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

- (YMSearchFileService *)searchFileService {
    if (_searchFileService == nil) {
        _searchFileService = YMSearchFileService.new;
        _searchFileService.delegate = self;
    }
    return _searchFileService;
}

- (YMParserFileService *)parserFileService {
    if (_parserFileService == nil) {
        _parserFileService = YMParserFileService.new;
    }
    return _parserFileService;
}

- (GMLFileGroupingService *)fileGroupingService {
    if (_fileGroupingService == nil) {
        _fileGroupingService = GMLFileGroupingService.new;
    }
    return _fileGroupingService;
}

- (GMLDeleteFileService *)deleteFileService {
    if (_deleteFileService == nil) {
        _deleteFileService = GMLDeleteFileService.new;
    }
    return _deleteFileService;
}

- (GMLFilterService *)filterService {
    if (_filterService == nil) {
        _filterService = GMLFilterService.new;
    }
    return _filterService;
}

- (GMLLogService *)logService {
    if (_logService == nil) {
        _logService = GMLLogService.new;
    }
    return _logService;
}

@end
