//
//  GMLClassBaseMode.m
//  YMSearchFile
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLClassBaseMode.h"

@interface GMLClassBaseMode ()

@property (nonatomic, strong) NSMapTable<NSString *, id<GMLPropertyProtocol>> *interfacePropertyMapTable;
@property (nonatomic, strong) NSMapTable<NSString *, id<GMLPropertyProtocol>> *implementationPropertyMapTable;
@property (nonatomic, strong) NSMapTable<NSString *, id<GMLMethodProtocol>> *methodMapTable;
@property (nonatomic, strong) NSMapTable<NSString *, id<GMLProtocolProtocol>> *protocolMapTable;

@end

@implementation GMLClassBaseMode

- (void)addInterfaceProperty:(id<GMLPropertyProtocol>)property {
    
}

- (void)addImplementationProperty:(id<GMLPropertyProtocol>)property {
    
}

- (void)addProtocol:(id<GMLProtocolProtocol>)protocol isExistInterface:(BOOL)isExistInterface {
    
}

- (void)addMethod:(id<GMLMethodProtocol>)method isExistInterface:(BOOL)isExistInterface {
    
}

#pragma mark - Getter & Setter

- (NSString *)contentText {
    return nil;
}

- (NSArray<id<GMLPropertyProtocol>> *)publicPropertyList {
    if (_interfacePropertyMapTable == nil) {
        return nil;
    }
    return NSAllMapTableValues(_interfacePropertyMapTable);
}

- (NSArray<id<GMLPropertyProtocol>> *)privatePropertyList {
    if (_implementationPropertyMapTable == nil) {
        return nil;
    }
    return NSAllMapTableValues(_implementationPropertyMapTable);
}

- (NSArray<id<GMLMethodProtocol>> *)publicMethodList {
    return nil;
}

- (NSArray<id<GMLMethodProtocol>> *)privateMethodList {
    return nil;
}

- (NSArray<id<GMLMethodProtocol>> *)publicProtocolList {
    return nil;
}

- (NSArray<id<GMLProtocolProtocol>> *)privateProtocolList {
    return nil;
}

- (NSMapTable<NSString *,id<GMLPropertyProtocol>> *)interfacePropertyMapTable {
    if (_interfacePropertyMapTable == nil) {
        _interfacePropertyMapTable = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory capacity:0];
    }
    return _interfacePropertyMapTable;
}

- (NSMapTable<NSString *,id<GMLPropertyProtocol>> *)implementationPropertyMapTable {
    if (_implementationPropertyMapTable == nil) {
        _implementationPropertyMapTable = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory capacity:0];;
    }
    return _implementationPropertyMapTable;
}

- (NSMapTable<NSString *,id<GMLMethodProtocol>> *)methodMapTable {
    if (_methodMapTable == nil) {
        _methodMapTable = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory capacity:0];;
    }
    return _methodMapTable;
}

- (NSMapTable<NSString *,id<GMLProtocolProtocol>> *)protocolMapTable {
    if (_protocolMapTable == nil) {
        _protocolMapTable = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory capacity:0];;
    }
    return _protocolMapTable;
}

@end
