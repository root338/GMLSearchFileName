//
//  GMLPCHFileMode.m
//  YMSearchFile
//
//  Created by apple on 2019/1/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLPCHFileMode.h"

@interface GMLPCHFileMode ()

@property (nonatomic, strong) NSHashTable<id<GMLFileProtocol>> *hashTable;

@end

@implementation GMLPCHFileMode

- (void)addFile:(id<GMLFileProtocol>)file {
    [self.hashTable addObject:file];
}

- (NSArray<id<GMLFileProtocol>> *)fileArray {
    return _hashTable.allObjects;
}

- (NSHashTable<id<GMLFileProtocol>> *)hashTable {
    if (_hashTable == nil) {
        _hashTable = [[NSHashTable alloc] initWithOptions:NSHashTableWeakMemory capacity:0];
    }
    return _hashTable;
}

@end
