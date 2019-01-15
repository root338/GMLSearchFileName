//
//  GMLRenameService.m
//  GMLRename
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLRenameService.h"
#import "GMLSearchFileService.h"

#import "GMLStack.h"
#import "GMLProjectMode.h"
#import "GMLFileService.h"
#import "GMLPackageService.h"

@interface GMLRenameService ()<GMLSearchFileServiceDelegate>

//@property (nonatomic, strong) GMLProjectMode *projectMode;

@property (nonatomic, strong) GMLFileService *swiftHeaderFileService;
@property (nonatomic, strong) GMLFileService *swiftBridgingFileService;
@property (nonatomic, strong) GMLFileService *pchFileService;

@property (nonatomic, strong) NSMapTable<NSString *, GMLFileService *> *fileServiceMapTable;
@property (nonatomic, strong) NSMapTable<NSString *, GMLPackageService *> *packageServiceMapTable;

@property (nonatomic, strong) GMLSearchFileService *searchFileService;

@property (nonatomic, strong) GMLStack<NSString *> *packageStack;
@end

@implementation GMLRenameService

- (void)run {
    
    
    
}

#pragma mark - GMLSearchFileServiceDelegate
- (void)service:(GMLSearchFileService *)service filePath:(NSString *)filePath {
    NSString *fileName = filePath.stringByDeletingPathExtension.lastPathComponent;
    GMLFileService *fileService = [self getFileServiceAtFileName:fileName];
    [fileService addFilePath:filePath];
    NSString *topPackage = _packageStack.stackTopObj;
    if (topPackage) {
        [[self getPackageServiceAtPath:topPackage] addFileService:fileService];
    }
}

- (void)service:(GMLSearchFileService *)service beginFolderPath:(NSString *)folderPath {
    NSString *pathExtension = folderPath.stringByDeletingPathExtension.lastPathComponent;
    if (pathExtension.length > 0) {
        [self.packageStack push:folderPath];
    }
}

- (void)service:(GMLSearchFileService *)service endFolderPath:(NSString *)folderPath {
    NSString *pathExtension = folderPath.stringByDeletingPathExtension.lastPathComponent;
    if (pathExtension.length > 0) {
        [self.packageStack pop];
    }
}

//- (BOOL)service:(GMLSearchFileService *)service shouldIgnoreFolderPath:(NSString *)folderPath {
//
//}

- (GMLPackageService *)getPackageServiceAtPath:(NSString *)targetPath {
    NSString *packageName = targetPath.stringByDeletingPathExtension.lastPathComponent;
    GMLPackageService *packageService = [self.packageServiceMapTable objectForKey:targetPath];
    if (packageService != nil) {
        return packageService;
    }
    packageService = [[GMLPackageService alloc] initWithPackagePath:packageName];
    [self.packageServiceMapTable setObject:packageService forKey:packageName];
    return packageService;
}

- (GMLFileService *)getFileServiceAtFileName:(NSString *)fileName {
    GMLFileService *fileService = [[GMLFileService alloc] initWithFileName:fileName];
    if (fileService != nil) {
        return fileService;
    }
    [self.fileServiceMapTable setObject:fileService forKey:fileName];
    return fileService;
}

#pragma mark - Getter & Setter
- (GMLSearchFileService *)searchFileService {
    if (_searchFileService == nil) {
        _searchFileService = GMLSearchFileService.new;
        _searchFileService.delegate = self;
    }
    return _searchFileService;
}

- (NSMapTable<NSString *, GMLFileService *> *)fileServiceMapTable {
    if (_fileServiceMapTable == nil) {
        _fileServiceMapTable = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory capacity:0];
    }
    return _fileServiceMapTable;
}

- (NSMapTable<NSString *,GMLPackageService *> *)packageServiceMapTable {
    if (_packageServiceMapTable == nil) {
        _packageServiceMapTable = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory capacity:0];
    }
    return _packageServiceMapTable;
}

- (GMLStack<NSString *> *)packageStack {
    if (_packageStack == nil) {
        _packageStack = GMLStack.new;
    }
    return _packageStack;
}

@end
