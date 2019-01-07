//
//  NSURL+GMLPathAdd.m
//  YMSearchFile
//
//  Created by apple on 2019/1/7.
//  Copyright © 2019 apple. All rights reserved.
//

#import "NSURL+GMLPathAdd.h"
#import "GMLFileConstants.h"

@implementation NSURL (GMLPathAdd)

- (GMLFolderType)folderType {
    GMLPathType pathType = self.pathType;
    switch (pathType) {
        case GMLPathTypeNotFound: return GMLFolderTypeNotFound;
        case GMLPathTypeFile: return GMLFolderTypeNotDirectory;
        case GMLPathTypeFolder:
        {
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

- (GMLPathType)pathType {
    NSNumber *isDirectoryKey;
    NSError *error = nil;
    [self getResourceValue:&isDirectoryKey forKey:NSURLIsDirectoryKey error:&error];
    NSAssert(error == nil, @"获取链接属性错误");
    if (isDirectoryKey == nil) {
        return GMLPathTypeNotFound;
    }else if (!isDirectoryKey.boolValue) {
        return GMLPathTypeFile;
    }else {
        return GMLPathTypeFolder;
    }
}

- (NSArray<NSString *> *)folderListAtToPath:(NSURL *)toPath {
    
    NSURL * (^folderPath) (NSURL *) = ^(NSURL *targetPath) {
        NSURL *targetFolderPath = nil;
        GMLPathType pathType = targetPath.pathType;
        switch (pathType) {
            case GMLPathTypeNotFound:break;
            case GMLPathTypeFolder:
                targetFolderPath = targetPath;
                break;
            case GMLPathTypeFile:
                targetFolderPath = [targetPath URLByDeletingLastPathComponent];
                break;
        }
        return targetFolderPath;
    };
    
    NSURL *tmpFromPath = folderPath(self);
    if (tmpFromPath == nil) { return nil; }
    NSURL *tmpToPath = folderPath(toPath);
    if (tmpToPath == nil) { return nil; }
    
    if (![tmpToPath.absoluteString hasPrefix:tmpFromPath.absoluteString]) { return nil; }
    
    if ([tmpToPath isEqual:tmpFromPath]) {
        return @[];
    }
    
    NSArray *fromPathComponents = tmpFromPath.pathComponents;
    NSArray *toPathComponents = tmpToPath.pathComponents;
    NSArray *resultArray = [toPathComponents subarrayWithRange:NSMakeRange(fromPathComponents.count, toPathComponents.count - fromPathComponents.count)];
    return resultArray;
}

@end
