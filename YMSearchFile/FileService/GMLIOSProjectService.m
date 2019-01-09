//
//  GMLIOSProjectService.m
//  YMSearchFile
//
//  Created by GML on 2019/1/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLIOSProjectService.h"

#import "GMLProjectMode.h"
#import "GMLSearchService.h"
#import "GMLClassFileService.h"

@interface GMLIOSProjectService ()<GMLClassFileServiceDelegate>

@property (nonatomic, strong) GMLProjectMode *projectMode;
@property (nonatomic, strong) GMLSearchService *searchService;
@property (nonatomic, strong) GMLClassFileService *classFileService;
@property (nonatomic, strong) NSMapTable<NSURL *, NSHashTable<id<GMLClassFileProtocol>> *> *canDeletedClassFileMap;
@end

@implementation GMLIOSProjectService

- (void)traversingPath:(NSURL *)pathURL {
    self.projectMode = [self.searchService searchFolderPathURL:pathURL isNeedFolderStruct:NO];
    NSArray<id<GMLClassFileProtocol>> *values = NSAllMapTableValues(self.projectMode.ocMapTable);
    for (id<GMLClassFileProtocol> value in values) {
        [self.classFileService parserClassFile:value];
    }
    if (_projectMode.swiftBridgingClassFile) {
        [self.classFileService parserClassFile:_projectMode.swiftBridgingClassFile];
    }
    if (_projectMode.pchClassFile) {
        [self.classFileService parserClassFile:_projectMode.pchClassFile];
    }
}

- (void)tryToDelete {
    NSMutableSet<id<GMLClassFileProtocol>> *canDeletedClassFileSet = NSMutableSet.set;
    if (_canDeletedClassFileMap) {
        NSArray<NSHashTable<id<GMLClassFileProtocol>> *> *values = NSAllMapTableValues(_canDeletedClassFileMap);
        for (NSHashTable<id<GMLClassFileProtocol>> *hashTable in values) {
            [canDeletedClassFileSet unionSet:[NSSet setWithArray:hashTable.allObjects]];
        }
    }
    for (id<GMLClassFileProtocol> waitingDeleted in canDeletedClassFileSet) {
        
    }
}

#pragma mark - GMLClassFileServiceDelegate
- (id<GMLClassFileProtocol>)service:(GMLClassFileService *)service sourceClassFile:(nonnull id<GMLClassFileProtocol>)sourceClassFile importFileName:(nonnull NSString *)importFileName {
    if (_swiftHeaderName && [importFileName isEqualToString:_swiftHeaderName]) {
        /// 引用了 swift 头文件
        [self.projectMode addIncludeSwiftHeaderClassFile:sourceClassFile];
        return nil;
    }
    return [_projectMode.ocMapTable objectForKey:importFileName];
}

- (void)service:(GMLClassFileService *)service sourceClassFile:(nonnull id<GMLClassFileProtocol>)sourceClassFile existFolder:(nullable NSURL *)existFolder {
    if (existFolder == nil) {
        NSHashTable<id<GMLClassFileProtocol>> *hashTable = [_canDeletedClassFileMap objectForKey:existFolder];
        if (hashTable == nil) {
            hashTable = [[NSHashTable alloc] initWithOptions:NSHashTableWeakMemory capacity:0];
            [self.canDeletedClassFileMap setObject:hashTable forKey:existFolder];
        }
        [hashTable addObject:sourceClassFile];
    }
}

- (GMLSearchService *)searchService {
    if (_searchService == nil) {
        _searchService = GMLSearchService.new;
    }
    return _searchService;
}

- (GMLClassFileService *)classFileService {
    if (_classFileService == nil) {
        _classFileService = GMLClassFileService.new;
        _classFileService.delegate = self;
    }
    return _classFileService;
}

- (NSMapTable<NSURL *,NSHashTable<id<GMLClassFileProtocol>> *> *)canDeletedClassFileMap {
    if (_canDeletedClassFileMap == nil) {
        _canDeletedClassFileMap = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory capacity:0];
    }
    return _canDeletedClassFileMap;
}

@end
