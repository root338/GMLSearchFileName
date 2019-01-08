//
//  GMLSwiftClassFileMode.m
//  YMSearchFile
//
//  Created by apple on 2019/1/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLSwiftClassFileMode.h"

@interface GMLSwiftClassFileMode ()

@property (nonatomic, strong) NSHashTable<id<GMLFileProtocol>> *hashTable;

@end

@implementation GMLSwiftClassFileMode

- (void)addFile:(id<GMLFileProtocol>)file {
    [self.hashTable addObject:file];
}

#pragma mark - Getter & Setter
- (NSArray<id<GMLFileProtocol>> *)fileArray {
    return _hashTable.allObjects;
}

- (GMLClassLanguageType)classLanguageType {
    return GMLClassLanguageTypeSwift;
}

- (NSHashTable<id<GMLFileProtocol>> *)hashTable {
    if (_hashTable == nil) {
        _hashTable = [[NSHashTable alloc] initWithOptions:NSHashTableWeakMemory capacity:0];
    }
    return _hashTable;
}

@end
