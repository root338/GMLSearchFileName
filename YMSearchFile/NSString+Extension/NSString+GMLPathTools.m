//
//  NSString+GMLPathTools.m
//  YMSearchFile
//
//  Created by GML on 2019/1/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import "NSString+GMLPathTools.h"
#import "GMLFileConstants.h"

@implementation NSString (GMLPathTools)

- (GMLPathType)pathType {
    BOOL isDirectory;
    BOOL result = [NSFileManager.defaultManager fileExistsAtPath:self isDirectory:&isDirectory];
    if (!result) {
        return GMLPathTypeNotFound;
    }
    return isDirectory? GMLPathTypeFolder : GMLPathTypeFile;
}

- (GMLFolderType)folderType {
    BOOL isDirectory;
    BOOL result = [NSFileManager.defaultManager fileExistsAtPath:self isDirectory:&isDirectory];
    if (!result) {
        return GMLFolderTypeNotFound;
    }
    if (!isDirectory) {
        return GMLFolderTypeNotDirectory;
    }
    NSString *pathExtension = [self.pathExtension lowercaseString];
    if (pathExtension.length == 0) {
        return GMLFolderTypeNormal;
    }else if ([pathExtension isEqualToString:GMLFrameworkTypeFolder]) {
        return GMLFolderTypeFramework;
    }else if ([pathExtension isEqualToString:GMLBundleTypeFolder]) {
        return GMLFolderTypeBundle;
    }else {
        return GMLFolderTypeUnknown;
    }
}

+ (NSArray<NSString *> *)folderListAtFromPath:(NSString *)fromPath toPath:(NSString *)toPath {
    
    NSString * (^folderPath) (NSString *) = ^(NSString *targetPath) {
        NSString *targetFolderPath = nil;
        GMLPathType pathType = targetPath.pathType;
        switch (pathType) {
            case GMLPathTypeNotFound:break;
            case GMLPathTypeFolder:
                targetFolderPath = targetPath;
                break;
            case GMLPathTypeFile:
                targetFolderPath = [targetPath stringByDeletingLastPathComponent];
                break;
        }
        return targetFolderPath;
    };
    
    NSString *tmpFromPath = folderPath(fromPath);
    if (tmpFromPath == nil) { return nil; }
    NSString *tmpToPath = folderPath(toPath);
    if (tmpToPath == nil) { return nil; }
    
    if (![tmpToPath hasPrefix:tmpFromPath]) { return nil; }
    
    NSMutableArray *pathComponents = [NSMutableArray arrayWithArray:[tmpToPath substringFromIndex:tmpFromPath.length].pathComponents];
    if ([pathComponents.firstObject isEqualToString:@"/"]) {
        [pathComponents removeObjectAtIndex:0];
    }
    return pathComponents;
}

@end
