//
//  GMLClassFileMode.m
//  YMSearchFile
//
//  Created by apple on 2019/1/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLClassFileMode.h"
#import "GMLFileProtocol.h"
@interface GMLClassFileMode ()

@property (nonatomic, strong) NSMapTable<NSNumber *, NSMapTable<NSString *, id<GMLClassFileProtocol>> *> *importFileMap;
@property (nonatomic, strong) NSHashTable<id<GMLClassFileProtocol>> *citedImportClassFileTable;
@property (nonatomic, strong) NSHashTable<id<GMLFileProtocol>> *hashTable;

@end

@implementation GMLClassFileMode

- (void)addFile:(id<GMLFileProtocol>)file {
    [self.hashTable addObject:file];
}

- (void)addImportClassFile:(id<GMLClassFileProtocol>)importClassFile permissionType:(GMLPermissionType)permissionType {
    NSNumber *key = @(permissionType);
    NSMapTable<NSString *, id<GMLClassFileProtocol>> *importFileMap = [_importFileMap objectForKey:key];
    if (importFileMap == nil) {
        importFileMap = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableWeakMemory capacity:0];
        [self.importFileMap setObject:importFileMap forKey:key];
    }
    [importFileMap setObject:importClassFile forKey:importClassFile.name];
}

- (void)addCitedImportClassFile:(id<GMLClassFileProtocol>)importClassFile {
    [self.citedImportClassFileTable addObject:importClassFile];
}

- (NSArray<id<GMLClassFileProtocol>> *)classFileListWithType:(NSArray<NSNumber *> *)permissionList {
    NSMutableSet *mutableSet = NSMutableSet.set;
    for (NSNumber *key in permissionList) {
        NSMapTable<NSString *, id<GMLClassFileProtocol>> *tmpMapTable = [_importFileMap objectForKey:key];
        if (tmpMapTable) {
            [mutableSet unionSet:[NSSet setWithArray:NSAllMapTableValues(tmpMapTable)]];
        }
    }
    return mutableSet.count ? mutableSet.allObjects : nil;
}

#pragma mark - Getter & Setter
- (NSArray<id<GMLFileProtocol>> *)fileArray {
    return _hashTable.allObjects;
}

- (GMLClassLanguageType)classLanguageType {
    return GMLClassLanguageTypeOC;
}

- (NSString *)name {
    if (_name == nil) {
        _name = [[_hashTable anyObject].pathURL.lastPathComponent stringByDeletingPathExtension];
    }
    return _name;
}

- (NSArray<id<GMLClassFileProtocol>> *)importClassFileList {
    return [self classFileListWithType:@[@(GMLPermissionTypePrivate), @(GMLPermissionTypePublic)]];
}

- (NSArray<id<GMLClassFileProtocol>> *)publicClassFileList {
    return [self classFileListWithType:@[@(GMLPermissionTypePublic)]];
}

- (NSArray<id<GMLClassFileProtocol>> *)privateClassFileList {
    return [self classFileListWithType:@[@(GMLPermissionTypePrivate)]];
}

- (NSArray<id<GMLClassProtocol>> *)containClassList {
    return @[];
}

- (NSHashTable<id<GMLFileProtocol>> *)hashTable {
    if (_hashTable == nil) {
        _hashTable = [[NSHashTable alloc] initWithOptions:NSHashTableStrongMemory capacity:0];
    }
    return _hashTable;
}

- (NSMapTable<NSNumber *,NSMapTable<NSString *,id<GMLClassFileProtocol>> *> *)importFileMap {
    if (_importFileMap == nil) {
        _importFileMap = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory capacity:0];
    }
    return _importFileMap;
}

- (NSHashTable<id<GMLClassFileProtocol>> *)citedImportClassFileTable {
    if (_citedImportClassFileTable == nil) {
        _citedImportClassFileTable = [[NSHashTable alloc] initWithOptions:NSHashTableWeakMemory capacity:0];
    }
    return _citedImportClassFileTable;
}

@end
