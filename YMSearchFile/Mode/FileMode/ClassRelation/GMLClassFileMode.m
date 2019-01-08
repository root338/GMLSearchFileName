//
//  GMLClassFileMode.m
//  YMSearchFile
//
//  Created by apple on 2019/1/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLClassFileMode.h"

@interface GMLClassFileMode ()

@property (nonatomic, strong) NSHashTable<id<GMLFileProtocol>> *hashTable;

@end

@implementation GMLClassFileMode

- (void)addFile:(id<GMLFileProtocol>)file {
    [self.hashTable addObject:file];
}

#pragma mark - Getter & Setter
- (NSArray<id<GMLFileProtocol>> *)fileArray {
    return _hashTable.allObjects;
}

- (GMLClassLanguageType)classLanguageType {
    return GMLClassLanguageTypeOC;
}

- (NSHashTable<id<GMLFileProtocol>> *)hashTable {
    if (_hashTable == nil) {
        _hashTable = [[NSHashTable alloc] initWithOptions:NSHashTableWeakMemory capacity:0];
    }
    return _hashTable;
}

@end
