//
//  GMLIOSProjectService.m
//  YMSearchFile
//
//  Created by GML on 2019/1/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLIOSProjectService.h"
#import "YMFileMode.h"
#import "GMLProjectParser.h"
#import "NSURL+GMLPathAdd.h"

@interface GMLIOSProjectService ()

@property (nonatomic, strong, readwrite) NSURL *projectPath;

@property (nonatomic, strong) GMLProjectParser *folderMode;

@property (nonatomic, strong) GMLProjectParser *projectParser;
@end

@implementation GMLIOSProjectService

- (instancetype)initWithProjectPath:(NSString *)projectPath {
    return [self initWithProjectURL:[NSURL fileURLWithPath:projectPath]];
}

- (instancetype)initWithProjectURL:(NSURL *)projectURL {
    GMLPathType pathType = projectURL.pathType;
    if (pathType != GMLPathTypeFolder) {
        return nil;
    }
    self = [super init];
    if (self) {
        _projectPath = projectURL;
        [self.projectParser parserWithProjectPath:projectURL];
    }
    return self;
}

//- (YMFileMode *)fileModeAtPath:(NSString *)path {
//    id obj = [self modeAtPath:path];
//    if ([obj isKindOfClass:[YMFileMode class]]) {
//        return obj;
//    }
//    return nil;
//}
//
//- (GMLProjectParser *)folderModeAtPath:(NSString *)path {
//    
//    id obj = [self modeAtPath:path];
//    if ([obj isKindOfClass:[GMLProjectParser class]]) {
//        return obj;
//    }
//    return nil;
//}
//
//- (BOOL)getModeAtPath:(NSString *)path result:(void (NS_NOESCAPE ^) (GMLProjectParser * folderMode, YMFileMode *fileMode))result {
//    if (_fileMode != nil && [_fileMode containsPath:path]) {
//        return
//    }
//}

//- (BOOL)createModeAtPath:(NSString *)path result:(void (NS_NOESCAPE ^) (GMLProjectParser * folderMode, YMFileMode *fileMode))result {
//    BOOL isDirectory;
//    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
//    if (!isExists) {
//        return NO;;
//    }
//    GMLProjectParser *folderMode = nil;
//    YMFileMode *fildMode = nil;
//    if (isDirectory) {
//        folderMode = [[GMLProjectParser alloc] initWithFolderPath:path];
//    }else {
//        fildMode = [YMFileMode createWithFilePath:path];
//    }
//    !result?: result(folderMode, fildMode);
//    return YES;
//}

- (GMLProjectParser *)projectParser {
    if (_projectParser == nil) {
        _projectParser = GMLProjectParser.new;
    }
    return _projectParser;
}

@end
