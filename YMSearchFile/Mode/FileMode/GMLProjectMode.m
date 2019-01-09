//
//  GMLProjectMode.m
//  YMSearchFile
//
//  Created by apple on 2019/1/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLProjectMode.h"

#import "GMLFileMode.h"
#import "GMLClassFileMode.h"
#import "GMLImageFileMode.h"
#import "GMLSwiftClassFileMode.h"
#import "GMLStoryboardFileMode.h"

#import "GMLFileProtocol.h"
#import "NSURL+GMLPathAdd.h"

@interface GMLProjectMode ()

@property (nonatomic, strong, readwrite) id<GMLClassFileProtocol> pchClassFile;
@property (nonatomic, strong, readwrite) id<GMLClassFileProtocol> swiftBridgingClassFile;
@property (nonatomic, strong, readwrite) GMLStoryboardFileMode *storyboardFileMode;
@property (nonatomic, strong, readwrite) NSMapTable<NSString *, GMLImageFileMode *> *imageMapTable;
@property (nonatomic, strong, readwrite) NSMapTable<NSString *, id<GMLFileProtocol>> *aMapTable;
@property (nonatomic, strong, readwrite) NSMapTable<NSString *, id<GMLFileProtocol>> *otherMapTable;
@property (nonatomic, strong, readwrite) NSMapTable<NSString *, id<GMLClassFileProtocol>> *ocMapTable;
@property (nonatomic, strong, readwrite) NSMapTable<NSString *, id<GMLClassFileProtocol>> *swiftMapTable;

@property (nonatomic, strong) NSHashTable<id<GMLClassFileProtocol>> *includeSwiftHeaderTable;

@property (nonatomic, strong) NSMapTable<NSString *, id<GMLFileProtocol>> *cacheXibMapTable;

@end

@implementation GMLProjectMode

- (id<GMLFileProtocol>)addFile:(id<GMLFileProtocol>)file {
    GMLFileType fileType = file.pathURL.fileType;
    switch (fileType) {
        case GMLFileTypeH:
        case GMLFileTypeM:
        case GMLFileTypeMM: {
            [self addOCRelationFile:file type:fileType];
        }
            break;
        case GMLFileTypeJPG:
        case GMLFileTypePNG:
        case GMLFileTypeGIF: {
            [self addImageRelationFile:file type:fileType];
        }
            break;
        case GMLFileTypeSwift: {
            [self addSwiftRelationFile:file type:fileType];
        }
            break;
        case GMLFileTypeXib: {
            [self addXibRelationFile:file type:fileType];
        }
            break;
        case GMLFileTypeA: {
            [self.aMapTable setObject:file forKey:[file.pathURL.lastPathComponent stringByDeletingPathExtension]];
        }
            break;
        case GMLFileTypePCH: {
            [self.pchClassFile addFile:file];
        }
            break;
        case GMLFileTypeStoryboard: {
            [self.storyboardFileMode addFile:file];
        }
            break;
        case GMLFileTypeUnknown: {
            [self.otherMapTable setObject:file forKey:[file.pathURL.lastPathComponent stringByDeletingPathExtension]];
        }
            break;
        case GMLFileTypeNotFound:
        case GMLFileTypeNotFile:
            return nil;
    }
    return file;
}

- (id<GMLFolderProtocol>)addFolder:(id<GMLFolderProtocol>)folder {
    return folder;
}

- (id<GMLClassFileProtocol>)fileAtName:(NSString *)name {
    id<GMLClassFileProtocol> classFileObj = [_ocMapTable objectForKey:name];
    if (classFileObj) {
        return classFileObj;
    }
    classFileObj = [_swiftMapTable objectForKey:name];
    return classFileObj;
}

- (void)addIncludeSwiftHeaderClassFile:(id<GMLClassFileProtocol>)classFile {
    [self.includeSwiftHeaderTable addObject:classFile];
}

- (void)addOCRelationFile:(id<GMLFileProtocol>)file type:(GMLFileType)type {
    NSString *fileName = file.name;
    id<GMLClassFileProtocol> classModel = [self.ocMapTable objectForKey:fileName];
    if (classModel == nil) {
        switch (type) {
            case GMLFileTypeH:
                if ([fileName hasSuffix:@"-Bridging-Header"]) {
                    [self.swiftBridgingClassFile addFile:file];
                    return;
                }
            case GMLFileTypeM:
            case GMLFileTypeMM: {
                classModel = GMLClassFileMode.new;
            }
                break;
            default:
                return;
        }
        if (classModel) {
            if (_cacheXibMapTable.count > 0) {
                [self addCacheXibToClass:classModel name:fileName];
            }
            [self.ocMapTable setObject:classModel forKey:fileName];
        }
    }
    [classModel addFile:file];
}

- (void)addSwiftRelationFile:(id<GMLFileProtocol>)file type:(GMLFileType)type {
    NSString *fileName = file.name;
    id<GMLClassFileProtocol> classModel = [self.swiftMapTable objectForKey:fileName];
    if (classModel == nil) {
        switch (type) {
            case GMLFileTypeSwift: {
                classModel = GMLSwiftClassFileMode.new;
            }
                break;
            default:
                return;
        }
        if (classModel) {
            if (_cacheXibMapTable.count > 0) {
                [self addCacheXibToClass:classModel name:fileName];
            }
            [self.swiftMapTable setObject:classModel forKey:fileName];
        }
    }
    [classModel addFile:file];
}

- (void)addXibRelationFile:(id<GMLFileProtocol>)file type:(GMLFileType)type {
    NSString *fileName = file.name;
    
    BOOL (^addXib) (NSMapTable *) = ^(NSMapTable *mapTable) {
        id<GMLClassFileProtocol> classModel = [mapTable objectForKey:fileName];
        if (classModel != nil) {
            [classModel addFile:file];
            return YES;
        }
        return NO;
    };
    
    if (addXib(_ocMapTable)) {
        return;
    }else if (addXib(_swiftMapTable)) {
        return;
    }else {
        [self.cacheXibMapTable setObject:file forKey:fileName];
    }
}

- (void)addImageRelationFile:(id<GMLFileProtocol>)file type:(GMLFileType)type {
    NSString *fileName = file.name;
    GMLImageFileMode *imageModel = [self.imageMapTable objectForKey:fileName];
    if (imageModel == nil) {
        imageModel = GMLImageFileMode.new;
        [self.imageMapTable setObject:imageModel forKey:fileName];
    }
    [imageModel addFile:file];
}

- (BOOL)addCacheXibToClass:(id<GMLClassFileProtocol>)targetClass name:(NSString *)name {
    id<GMLFileProtocol> xibFile = [_cacheXibMapTable objectForKey:name];
    if (xibFile) {
        [targetClass addFile:xibFile];
        [_cacheXibMapTable removeObjectForKey:name];
        return YES;
    }
    return NO;
}

#pragma mark - Getter & Setter
- (NSMapTable<NSString *,id<GMLClassFileProtocol>> *)ocMapTable {
    if (_ocMapTable == nil) {
        _ocMapTable = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory capacity:0];
    }
    return _ocMapTable;
}
- (NSMapTable<NSString *,id<GMLClassFileProtocol>> *)swiftMapTable {
    if (_swiftMapTable == nil) {
        _swiftMapTable = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory capacity:0];
    }
    return _swiftMapTable;
}

- (NSMapTable<NSString *, GMLImageFileMode *> *)imageMapTable {
    if (_imageMapTable == nil) {
        _imageMapTable = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory capacity:0];
    }
    return _imageMapTable;
}

- (NSMapTable<NSString *, id<GMLFileProtocol>> *)aMapTable {
    if (_aMapTable == nil) {
        _aMapTable = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory capacity:0];
    }
    return _aMapTable;
}

- (NSMapTable<NSString *,id<GMLFileProtocol>> *)otherMapTable {
    if (_otherMapTable == nil) {
        _otherMapTable = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory capacity:0];
    }
    return _otherMapTable;
}

- (NSMapTable<NSString *,id<GMLFileProtocol>> *)cacheXibMapTable {
    if (_cacheXibMapTable == nil) {
        _cacheXibMapTable = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory capacity:0];
    }
    return _cacheXibMapTable;
}

- (id<GMLClassFileProtocol>)pchClassFile {
    if (_pchClassFile == nil) {
        _pchClassFile = GMLClassFileMode.new;
    }
    return _pchClassFile;
}

- (id<GMLClassFileProtocol>)swiftBridgingClassFile {
    if (_swiftBridgingClassFile == nil) {
        _swiftBridgingClassFile = GMLClassFileMode.new;
    }
    return _swiftBridgingClassFile;
}

- (GMLStoryboardFileMode *)storyboardFileMode {
    if (_storyboardFileMode == nil) {
        _storyboardFileMode = GMLStoryboardFileMode.new;
    }
    return _storyboardFileMode;
}

- (NSHashTable<id<GMLClassFileProtocol>> *)includeSwiftHeaderTable {
    if (_includeSwiftHeaderTable == nil) {
        _includeSwiftHeaderTable = [[NSHashTable alloc] initWithOptions:NSHashTableWeakMemory capacity:0];
    }
    return _includeSwiftHeaderTable;
}

@end
