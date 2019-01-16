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

- (GMLFileType)fileType {
    GMLPathType path = self.pathType;
    switch (path) {
        case GMLPathTypeNotFound: return GMLFileTypeNotFound;
        case GMLPathTypeFolder: return GMLFileTypeNotFile;
        case GMLPathTypeFile: {
            NSString *pathExtension = [self.pathExtension lowercaseString];
            if ([pathExtension isEqualToString:GMLHTypeFile]) {
                return GMLFileTypeH;
            }else if ([pathExtension isEqualToString:GMLMTypeFile]) {
                return GMLFileTypeM;
            }else if ([pathExtension isEqualToString:GMLMMTypeFile]) {
                return GMLFileTypeMM;
            }else if ([pathExtension isEqualToString:GMLSWIFTTypeFile]) {
                return GMLFileTypeSwift;
            }else if ([pathExtension isEqualToString:GMLXIBTypeFile]) {
                return GMLFileTypeXib;
            }else if ([pathExtension isEqualToString:GMLStoryboardTypeFile]) {
                return GMLFileTypeStoryboard;
            }else if ([pathExtension isEqualToString:GMLATypeFile]) {
                return GMLFileTypeA;
            }else if ([pathExtension isEqualToString:GMLPCHTypeFile]) {
                return GMLFileTypePCH;
            }else if ([pathExtension isEqualToString:GMLJPGTypeFile]) {
                return GMLFileTypeJPG;
            }else if ([pathExtension isEqualToString:GMLPNGTypeFile]) {
                return GMLFileTypePNG;
            }else if ([pathExtension isEqualToString:GMLGIFTypeFile]) {
                return GMLFileTypeGIF;
            }else {
                return GMLFileTypeUnknown;
            }
        }
    }
}

- (GMLFolderType)folderType {
    GMLPathType path = self.pathType;
    switch (path) {
        case GMLPathTypeNotFound: return GMLFolderTypeNotFound;
        case GMLPathTypeFile: return GMLFolderTypeNotDirectory;
        case GMLPathTypeFolder: {
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
    if ([tmpToPath isEqualToString:tmpFromPath]) {
        return @[tmpToPath.lastPathComponent];
    }
    NSArray *tmpFromPathComponents = tmpFromPath.pathComponents;
    NSArray *tmpToPathComponents = tmpToPath.pathComponents;
    NSArray *pathComponents = [tmpToPathComponents subarrayWithRange:NSMakeRange(tmpFromPathComponents.count, tmpToPathComponents.count - tmpFromPathComponents.count)];
    return pathComponents;
}

- (NSRange)rangeOfAll {
    return NSMakeRange(0, self.length);
}

@end
