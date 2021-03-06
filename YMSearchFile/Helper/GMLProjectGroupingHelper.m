//
//  GMLProjectGroupingHelper.m
//  YMSearchFile
//
//  Created by GML on 2019/1/5.
//  Copyright © 2019 ml. All rights reserved.
//

#import "GMLProjectGroupingHelper.h"

@implementation GMLProjectGroupingHelper

+ (NSSet<NSString *> *)shouldDeleteFolderSet {
    NSArray<NSString *> *list = @[
    @"/Users/ml/dev/yuemei_mainAPP/QuickAskCommunity/QuickAskCommunity/Classes/Module/ShoppingCart",
    @"/Users/ml/dev/yuemei_mainAPP/QuickAskCommunity/QuickAskCommunity/Classes/Module/TaoDetail",
    @"/Users/ml/dev/yuemei_mainAPP/QuickAskCommunity/QuickAskCommunity/Classes/Module/Community",
    @"/Users/ml/dev/yuemei_mainAPP/QuickAskCommunity/QuickAskCommunity/Classes/Module/WriteDiary",
    @"/Users/ml/dev/yuemei_mainAPP/QuickAskCommunity/QuickAskCommunity/Classes/Module/PostList",
    @"/Users/ml/dev/yuemei_mainAPP/QuickAskCommunity/QuickAskCommunity/Classes/Module/TaoParticulars",
    @"/Users/ml/dev/yuemei_mainAPP/QuickAskCommunity/QuickAskCommunity/Classes/Module/Search",
    @"/Users/ml/dev/yuemei_mainAPP/QuickAskCommunity/QuickAskCommunity/Classes/Module/HomePage",
    @"/Users/ml/dev/yuemei_mainAPP/QuickAskCommunity/QuickAskCommunity/Classes/Module/DoctorHospitalList",
    @"/Users/ml/dev/yuemei_mainAPP/QuickAskCommunity/QuickAskCommunity/Classes/Module/PostDetail",
    @"/Users/ml/dev/yuemei_mainAPP/QuickAskCommunity/QuickAskCommunity/Classes/Module/Doctor",
    @"/Users/ml/dev/yuemei_mainAPP/QuickAskCommunity/QuickAskCommunity/Classes/Module/TaoList",
    @"/Users/ml/dev/yuemei_mainAPP/QuickAskCommunity/QuickAskCommunity/Classes/Module/My",
                                  ];
    return [NSSet setWithArray:list];
}

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
