//
//  GMLFileService.m
//  YMSearchFile
//
//  Created by GML on 2019/1/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLFileService.h"
#import "YMFileMode.h"
#import "GMLFolderService.h"
#import "NSString+GMLPathTools.h"

@interface GMLFileService ()

@property (nonatomic, strong) YMFileMode *fileMode;
@property (nonatomic, strong) GMLFolderService *folderMode;

@end

@implementation GMLFileService

- (instancetype)initWithPath:(NSString *)path {
    GMLPathType pathType = path.pathType;
    if (pathType == GMLPathTypeNotFound) {
        return nil;
    }
    self = [super init];
    if (self) {
        switch (pathType) {
            case GMLPathTypeFile:
                _fileMode = [YMFileMode createWithFilePath:path];
                break;
            case GMLPathTypeFolder:
                _folderMode = [[GMLFolderService alloc] initWithFolderPath:path];
                break;
            default:
                break;
        }
        
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
//- (GMLFolderService *)folderModeAtPath:(NSString *)path {
//    
//    id obj = [self modeAtPath:path];
//    if ([obj isKindOfClass:[GMLFolderService class]]) {
//        return obj;
//    }
//    return nil;
//}
//
//- (BOOL)getModeAtPath:(NSString *)path result:(void (NS_NOESCAPE ^) (GMLFolderService * folderMode, YMFileMode *fileMode))result {
//    if (_fileMode != nil && [_fileMode containsPath:path]) {
//        return
//    }
//}

- (BOOL)createModeAtPath:(NSString *)path result:(void (NS_NOESCAPE ^) (GMLFolderService * folderMode, YMFileMode *fileMode))result {
    BOOL isDirectory;
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    if (!isExists) {
        return NO;;
    }
    GMLFolderService *folderMode = nil;
    YMFileMode *fildMode = nil;
    if (isDirectory) {
        folderMode = [[GMLFolderService alloc] initWithFolderPath:path];
    }else {
        fildMode = [YMFileMode createWithFilePath:path];
    }
    !result?: result(folderMode, fildMode);
    return YES;
}

@end
