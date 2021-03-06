//
//  GMLFileGroupingService.m
//  YMSearchFile
//
//  Created by GML on 2019/1/5.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLFileGroupingService.h"

#import "YMFileMode.h"
#import "GMLFolderGroupingMode.h"

@implementation GMLFileGroupingService

- (NSDictionary<NSNumber *,NSSet<YMFileMode *> *> *)accordingToCitedGroupingFileWithFileModeSet:(NSSet<YMFileMode *> *)fileModeSet completion:(void (NS_NOESCAPE ^)(NSUInteger, NSUInteger))completion {
    NSMutableDictionary *dict = NSMutableDictionary.dictionary;
    
    __block NSUInteger minCitedCount = 0;
    __block NSUInteger maxCitedCount = 0;
    [fileModeSet enumerateObjectsUsingBlock:^(YMFileMode * _Nonnull obj, BOOL * _Nonnull stop) {
        NSUInteger citedCount = obj.citedFileNameTable.count;
        NSNumber *numberKey = @(citedCount);
        NSMutableSet *list = dict[numberKey];
        if (list == nil) {
            list = NSMutableSet.set;
            dict[numberKey] = list;
            minCitedCount = MIN(minCitedCount, citedCount);
            maxCitedCount = MAX(maxCitedCount, citedCount);
        }
        [list addObject:obj];
    }];
    !completion?: completion(minCitedCount, maxCitedCount);
    return dict;
}

- (NSDictionary<NSString *, GMLFolderGroupingMode *> *)accordingToBasePathGroupingFileWithFileModeSet:(NSSet<YMFileMode *> *)fileModeSet basePathSet:(nonnull NSSet<NSString *> *)basePathSet {
    return [self accordingToBasePathGroupingFileWithFileModeSet:fileModeSet basePathSet:basePathSet ignoreBasePathSet:nil];
}

- (NSDictionary<NSString *,GMLFolderGroupingMode *> *)accordingToBasePathGroupingFileWithFileModeSet:(NSSet<YMFileMode *> *)fileModeSet basePathSet:(NSSet<NSString *> *)basePathSet ignoreBasePathSet:(NSSet<NSString *> *)ignoreBasePathSet {
    
    NSMutableDictionary<NSString *, GMLFolderGroupingMode *> *dict = NSMutableDictionary.dictionary;
    for (YMFileMode *fileMode in fileModeSet) {
        NSString *key = [self keyWithFileMode:fileMode basePathSet:basePathSet];
        if (key == nil) {
            continue;
        }
        GMLFolderGroupingMode *groupMode = dict[key];
        if (groupMode == nil) {
            groupMode = [[GMLFolderGroupingMode alloc] initWithFolderPath:key];
            dict[key] = groupMode;
        }
        [groupMode addFileMode:fileMode];
        NSEnumerator *includeEnumerator = fileMode.includeFileNameTable.objectEnumerator;
        for (YMFileMode *includeFileMode = includeEnumerator.nextObject; includeFileMode; includeFileMode = includeEnumerator.nextObject) {
            NSString *includeFolderKey = [self keyWithFileMode:includeFileMode basePathSet:basePathSet];
            if (includeFolderKey && ![includeFolderKey isEqualToString:key]) {
                [groupMode addIncludeFolder:includeFolderKey fileMode:includeFileMode];
            }
        }
        NSEnumerator *citedEnumerator = fileMode.citedFileNameTable.objectEnumerator;
        for (YMFileMode *citedFileMode = citedEnumerator.nextObject; citedFileMode; citedFileMode = citedEnumerator.nextObject) {
            NSString *citedFolderKey = [self keyWithFileMode:citedFileMode basePathSet:basePathSet];
            if (![ignoreBasePathSet containsObject:citedFolderKey]) {
                if (citedFolderKey && ![citedFolderKey isEqualToString:key]) {
                    [groupMode addCitedOtherFolderWithFileMode:fileMode];
                    break;
                }
            }
        }
    }
    return dict;
}

- (NSSet<YMFileMode *> *)accordingToBasePathGroupingFileWithFileModeSet:(NSSet<YMFileMode *> *)fileModeSet shouldDeletePathSet:(nullable NSSet<NSString *> *)shouldDeletePathSet {
    
    NSMutableSet *needDeleteSet = NSMutableSet.set;
    for (YMFileMode *fileMode in fileModeSet) {
        BOOL result = [self isAddCanDeletedFileMode:fileMode canNotDeletePathSet:nil shouldDeletePathSet:shouldDeletePathSet didCacheFileModes:[[NSHashTable alloc] initWithOptions:NSHashTableWeakMemory capacity:0]];
        if (result) {
            [needDeleteSet addObject:fileMode];
        }
    }
    return needDeleteSet;
}

- (BOOL)isAddCanDeletedFileMode:(YMFileMode *)fileMode canNotDeletePathSet:(NSSet<NSString *> *)canNotDeletePathSet shouldDeletePathSet:(nullable NSSet<NSString *> *)shouldDeletePathSet didCacheFileModes:(NSHashTable *)didCacheFileModes {
    
    NSString *key = [self keyWithFileMode:fileMode basePathSet:shouldDeletePathSet];
    if (key == nil) {
        return NO;
    }
    
    NSEnumerator *enumerator = nil;
    
    if (![didCacheFileModes containsObject:fileMode]) {
        enumerator = fileMode.citedFileNameTable.objectEnumerator;
        [didCacheFileModes addObject:fileMode];
    }
    
    BOOL result = YES;
    for (YMFileMode *obj = enumerator.nextObject; obj; obj = enumerator.nextObject) {
        
        result = [self isAddCanDeletedFileMode:fileMode canNotDeletePathSet:canNotDeletePathSet shouldDeletePathSet:shouldDeletePathSet didCacheFileModes:didCacheFileModes];
        if (!result) {
            break;
        }
    }
    return result;
}

//- (void)fileMode:(YMFileMode *)fileMode basePathSet:(NSSet<NSString *> *)basePathSet belong:(void(^)(NSString *))belongBlock includeOtherFolder:(void(^)(NSString *, YMFileMode *))includeOtherFolder citedOtherFolder:(void(^)(NSString *, YMFileMode *))citedOtherFolder {
//    NSString *key = [self keyWithFileMode:fileMode basePathSet:basePathSet];
//    belongBlock(key);
//    NSEnumerator *includeEnumerator = fileMode.includeFileNameTable.objectEnumerator;
//    for (YMFileMode *includeFileMode = includeEnumerator.nextObject; includeFileMode; includeFileMode = includeEnumerator.nextObject) {
//        NSString *includeFolderKey = [self keyWithFileMode:includeFileMode basePathSet:basePathSet];
//        if (![includeFolderKey isEqualToString:key]) {
//            includeOtherFolder(includeFolderKey, includeFileMode);
//        }
//    }
//    NSEnumerator *citedEnumerator = fileMode.citedFileNameTable.objectEnumerator;
//    for (YMFileMode *citedFileMode = citedEnumerator.nextObject; citedFileMode; citedFileMode = citedEnumerator.nextObject) {
//        NSString *citedFolderKey = [self keyWithFileMode:citedFileMode basePathSet:basePathSet];
//        if (![citedFolderKey isEqualToString:key]) {
//            citedOtherFolder(citedFolderKey, citedFileMode);
//        }
//    }
//}

- (NSString *)keyWithFileMode:(YMFileMode *)fileMode basePathSet:(NSSet<NSString *> *)basePathSet {
    NSString *path = [fileMode.allRelationPathSet anyObject];
    __block NSString *key = nil;
    [basePathSet enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, BOOL * _Nonnull basePathStop) {
        if ([path hasPrefix:obj]) {
            key = obj;
            *basePathStop = YES;
        }
    }];
    return key;
}

@end
