//
//  GMLProjectGroupingHelper.m
//  YMSearchFile
//
//  Created by GML on 2019/1/5.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLProjectGroupingHelper.h"

@implementation GMLProjectGroupingHelper

+ (NSSet<NSString *> *)baseFolderSetWithPaths:(NSSet<NSString *> *)paths subpathlevel:(NSUInteger)subpathLevel {
    NSMutableSet<NSString *> *baseFolderPath = NSMutableSet.set;
    for (NSString *path in paths) {
        NSSet<NSString *> *pathSet = [self subpathSetWithPath:path level:0 maxLevel:subpathLevel];
        !pathSet.count?: [baseFolderPath unionSet:pathSet];
    }
    return baseFolderPath;
}

+ (NSSet<NSString *> *)subpathSetWithPath:(NSString *)path level:(NSUInteger)level maxLevel:(NSUInteger)maxLevel {
    NSFileManager *fileM = NSFileManager.defaultManager;
    BOOL isDirectory;
    if (![fileM fileExistsAtPath:path isDirectory:&isDirectory]) {
        return nil;
    }
    if (maxLevel < level) {
        return nil;
    }
    
    NSArray<NSString *> *contens = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSMutableSet<NSString *> *subpathSet = NSMutableSet.set;
    for (NSString *subname in contens) {
        NSSet<NSString *> *set = [self subpathSetWithPath:[path stringByAppendingPathComponent:subname] level:level + 1 maxLevel:maxLevel];
        !set.count?: [subpathSet unionSet:set];
    }
    if (subpathSet.count == 0 && isDirectory) {
        [subpathSet addObject:path];
    }
    return subpathSet;
}

@end
