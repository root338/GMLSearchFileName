//
//  GMLProjectParser.m
//  YMSearchFile
//
//  Created by GML on 2019/1/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLProjectParser.h"
#import "NSURL+GMLPathAdd.h"

#import "GMLFolderMode.h"
#import "YMProjectMode.h"

@interface GMLProjectParser ()
{
    NSArray<NSURLResourceKey> *_resourceKeys;
}
@property (nonatomic, strong) NSURL *parserURL;
//@property (nonatomic, assign, readwrite) GMLFolderType folderType;
//@property (nonatomic, strong, readwrite) NSString *folderPath;
//@property (nonatomic, strong) NSHashTable<NSString *> *fileTable;
//@property (nonatomic, strong) NSHashTable<GMLProjectParser *> *folderModeTable;

@property (nonatomic, strong) NSDirectoryEnumerator<NSURL *> *directoryEnumerator;
@property (nonatomic, strong) id<GMLFolderProtocol> baseFolder;
@property (nonatomic, strong) YMProjectMode *projectMode;
@end

@implementation GMLProjectParser

//- (instancetype)initWithFolderPath:(NSString *)folderPath {
//    GMLFolderType folderType = folderPath.folderType;
//    switch (folderType) {
//        case GMLFolderTypeNotFound:
//        case GMLFolderTypeNotDirectory:
//            return nil;
//        default:
//            break;
//    }
//    self = [super init];
//    if (self) {
//
//    }
//    return self;
//}
//
//- (BOOL)containsPath:(NSString *)path {
//    if ([path hasPrefix:self.folderPath]) {
//        if (path.pathType != GMLPathTypeNotFound) {
//            return YES;
//        }
//    }
//    return NO;
//}

- (BOOL)parserWithProjectPath:(NSURL *)projectPath {
    self.parserURL = projectPath;
//    NSDirectoryEnumerator<NSURL *> *directoryEnumerator = self.directoryEnumerator;
    
    if (_parserURL == nil || self.baseFolder == nil) {
        return NO;
    }
    if ([self.delegate respondsToSelector:@selector(parser:shouldParserFolderURL:)]) {
        [self parserAllWithURL:projectPath];
    }else {
        [self defaultParserWithURL:projectPath];
    }
//    NSArray<NSURL *> *contentsURLs = [NSFileManager.defaultManager contentsOfDirectoryAtURL:projectPath includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants|NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
//    for (NSURL *url in directoryEnumerator) {
//        NSNumber * isDirectory;
//        [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
//        if ([self isHandleURL:url isDirectory:isDirectory]) {
//            [self handleURL:url isDirectory:isDirectory];
//        }
////        if (_parserOption != GMLParserOptionResume) {
////            if (_parserOption == GMLParserOptionStop) {
////                _directoryEnumerator = nil;
////            }
////            break;
////        }
//    }
    return YES;
}

- (void)parserAllWithURL:(NSURL *)URL {
//    NSDirectoryEnumerator<NSURL *> *directoryEnumerator = [NSFileManager.defaultManager enumeratorAtURL:URL includingPropertiesForKeys:nil options:<#(NSDirectoryEnumerationOptions)#> errorHandler:<#^BOOL(NSURL * _Nonnull url, NSError * _Nonnull error)handler#>];
//    for (NSURL  in directoryEnumerator.nextObject) {
//        <#statements#>
//    }
}

- (void)defaultParserWithURL:(NSURL *)URL {
    
    
}

- (void)handleURL:(NSURL *)url isDirectory:(NSNumber *)isDirectory {
//    if (_resourceKeys == nil) {
//        _resourceKeys = @[
//                          NSURLIsPackageKey,
//                          NSURLIsRegularFileKey,
//                          ];
//    }
//    NSDictionary<NSURLResourceKey, id> *resourceDict = [url resourceValuesForKeys:_resourceKeys error:nil];
}

- (BOOL)isHandleURL:(NSURL *)url isDirectory:(NSNumber *)isDirectory {
    
    if ([self.delegate respondsToSelector:@selector(parser:shouldParserFolderURL:)]) {
        return [self.delegate parser:self shouldParserFolderURL:url];
    }
    return YES;
}

- (NSArray<NSURL *> *)deployContentURLsWithURL:(NSURL *)targetURL {
    
    NSDirectoryEnumerationOptions options = NSDirectoryEnumerationSkipsSubdirectoryDescendants;
    if (!_parserHiddenPath) {
        options |= NSDirectoryEnumerationSkipsHiddenFiles;
    }
    NSArray<NSURL *> *tmpURLs = [NSFileManager.defaultManager contentsOfDirectoryAtURL:targetURL includingPropertiesForKeys:nil options:options error:nil];
    if (tmpURLs.count == 0) {
        return nil;
    }
    NSMutableArray *contentsURLs = [NSMutableArray arrayWithArray:tmpURLs];
    if (!_parserCocoaPodsFolder) {
        [self removeCocoaPodsPathWithURLs:contentsURLs];
    }
    if (!_parserSuffixIsTestsFolder) {
        [self removeSuffixTestsFolderWithURLs:contentsURLs];
    }
    if (!_parserXcodeprojFolder) {
        NSURL *xcodeproj = [self removeXcodeprojFolderWithURLs:contentsURLs];
        if (xcodeproj) {
            [self parserXcodeprojFolder:xcodeproj];
        }
    }
    return contentsURLs;
}

#pragma mark - 移除需要过滤的文件
- (void)removeCocoaPodsPathWithURLs:(NSMutableArray<NSURL *> *)urls {
    
    NSMutableArray<NSURL *> *cocoaPodsURLs = NSMutableArray.array;
    
    for (NSURL *targetURL in urls) {
        
        BOOL maybeIsCocoaPods = NO;
        NSNumber *isDirectory;
        [targetURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
        NSString *lastPathComponent = targetURL.lastPathComponent;
        
        if (isDirectory.boolValue) {
            maybeIsCocoaPods = [lastPathComponent isEqualToString:@"Pods"] || [lastPathComponent.pathExtension isEqualToString:@"xcworkspace"];
        }else {
            maybeIsCocoaPods = [lastPathComponent isEqualToString:@"Podfile"] || [lastPathComponent isEqualToString:@"Podfile.lock"];
        }
        if (maybeIsCocoaPods) {
            [cocoaPodsURLs addObject:targetURL];
        }
    }
    if (cocoaPodsURLs.count == 4) {
        [urls removeObjectsInArray:cocoaPodsURLs];
    }
}

- (void)removeSuffixTestsFolderWithURLs:(NSMutableArray<NSURL *> *)urls {
    NSMutableArray *testsURLs = NSMutableArray.array;
    for (NSURL *targetURL in urls) {
        NSString *lastPathComponent = targetURL.lastPathComponent;
        if ([lastPathComponent hasSuffix:@"Tests"]) {
            [testsURLs addObject:targetURL];
        }
    }
    [urls removeObjectsInArray:testsURLs];
}

- (NSURL *)removeXcodeprojFolderWithURLs:(NSMutableArray<NSURL *> *)urls {
    for (NSURL *url in urls) {
        if ([[url.pathExtension lowercaseString] isEqualToString:@"xcodeproj"]) {
            if (url.pathType == GMLPathTypeFolder) {
                [urls removeObject:url];
                return url;
            }
        }
    }
    return nil;
}

#pragma mark - 解析工程文件夹
- (void)parserXcodeprojFolder:(NSURL *)xcodeprojFolderURL {
    NSArray<NSURL *> *contentURLs = [NSFileManager.defaultManager contentsOfDirectoryAtURL:xcodeprojFolderURL includingPropertiesForKeys:nil options:0 error:nil];
    for (NSURL *url in contentURLs) {
        if ([url.lastPathComponent isEqualToString:@"project.pbxproj"]) {
            YMProjectMode *projectMode = YMProjectMode.new;
            projectMode.projectFileURLPath = url;
            [self.delegate parser:self projectMode:projectMode];
            return;
        }
    }
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
//- (BOOL)addFolderMode:(GMLProjectParser *)folderMode {
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

//- (NSArray *)pathListWithType:(GMLPathType)pathType {
//    NSArray<NSString *> *contents = [NSFileManager.defaultManager contentsOfDirectoryAtPath:_folderPath error:nil];
//    NSMutableArray *list = NSMutableArray.array;
//    for (NSString *path in contents) {
////        NSString *fullPath = [_folderPath stringByAppendingPathComponent:path];
//        if (path.pathType == pathType) {
//            [list addObject:path];
//        }
//    }
//    return list;
//}

#pragma mark - Getter & Setter
//- (NSArray<NSString *> *)filePathArrays {
//    return [_fileTable allObjects];
//}
//
//- (NSArray<GMLProjectParser *> *)folderModes {
//    return [_folderModeTable allObjects];
//}

//- (NSHashTable<NSString *> *)fileTable {
//    if (_fileTable == nil) {
//        NSArray<NSString *> *fileList = [self pathListWithType:GMLPathTypeFile];
//        _fileTable = [[NSHashTable alloc] initWithOptions:NSHashTableStrongMemory capacity:fileList.count];
//        for (NSString *filePath in _fileTable) {
//            [_fileTable addObject:filePath];
//        }
//    }
//    return _fileTable;
//}
//
//- (NSHashTable<GMLProjectParser *> *)folderModeTable {
//    if (_folderModeTable == nil) {
//        NSArray<NSString *> *folderList = [self pathListWithType:GMLPathTypeFolder];
//        _folderModeTable = [[NSHashTable alloc] initWithOptions:NSHashTableStrongMemory capacity:folderList.count];
//        for (NSString *folderPath in folderList) {
//            GMLProjectParser *folderMode = [[GMLProjectParser alloc] initWithFolderPath:folderPath];
//            [_folderModeTable addObject:folderMode];
//        }
//    }
//    return _folderModeTable;
//}

- (void)setParserURL:(NSURL *)parserURL {
    if (![_parserURL isEqual:parserURL]) {
        _parserURL = parserURL;
        _baseFolder = nil;
        _directoryEnumerator = nil;
        self.parserOption = GMLParserOptionStop;
    }
}

- (NSDirectoryEnumerator<NSURL *> *)directoryEnumerator {
    if (_directoryEnumerator == nil) {
        NSDirectoryEnumerationOptions options = 0;
        if (!_parserHiddenPath) {
            options |= NSDirectoryEnumerationSkipsHiddenFiles;
        }
        _directoryEnumerator = [NSFileManager.defaultManager enumeratorAtURL:self.parserURL includingPropertiesForKeys:nil options:options errorHandler:nil];
    }
    return _directoryEnumerator;
}

- (id<GMLFolderProtocol>)baseFolder {
    if (_baseFolder == nil) {
        _baseFolder = [[GMLFolderMode alloc] initWithPathURL:self.parserURL];
    }
    return _baseFolder;
}

@end
