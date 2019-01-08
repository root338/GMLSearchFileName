//
//  GMLProjectMode.m
//  YMSearchFile
//
//  Created by apple on 2019/1/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLProjectMode.h"

#import "GMLFileMode.h"
#import "GMLPCHFileMode.h"
#import "GMLClassFileMode.h"
#import "GMLImageFileMode.h"
#import "GMLSwiftClassFileMode.h"
#import "GMLStoryboardFileMode.h"

#import "GMLFileProtocol.h"
#import "NSURL+GMLPathAdd.h"

@interface GMLProjectMode ()

@property (nonatomic, strong, readwrite) GMLFileMode *swiftHeaderFile;
@property (nonatomic, strong, readwrite) GMLPCHFileMode *pchFileMode;
@property (nonatomic, strong, readwrite) GMLFileMode *swiftBridgingFileMode;
@property (nonatomic, strong, readwrite) GMLStoryboardFileMode *storyboardFileMode;
@property (nonatomic, strong, readwrite) NSMapTable<NSString *, GMLImageFileMode *> *imageMapTable;
@property (nonatomic, strong, readwrite) NSMapTable<NSString *, id<GMLFileProtocol>> *aMapTable;
@property (nonatomic, strong, readwrite) NSMapTable<NSString *, id<GMLFileProtocol>> *otherMapTable;
@property (nonatomic, strong, readwrite) NSMapTable<NSString *, id<GMLClassProtocol>> *ocMapTable;
@property (nonatomic, strong, readwrite) NSMapTable<NSString *, id<GMLClassProtocol>> *swiftMapTable;

@property (nonatomic, strong) NSMapTable<NSString *, id<GMLFileProtocol>> *cacheXibMapTable;

@end

@implementation GMLProjectMode

- (GMLFileMode *)addSwiftHeaderFile:(id<GMLFileProtocol>)swiftHeaderFile {
    if ([swiftHeaderFile isKindOfClass:[GMLFileMode class]]) {
        _swiftHeaderFile = swiftHeaderFile;
    }else {
        _swiftHeaderFile = [[GMLFileMode alloc] initWithPathURL:swiftHeaderFile.pathURL];
    }
    return _swiftHeaderFile;
}

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
            [self.pchFileMode addFile:file];
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

- (void)addOCRelationFile:(id<GMLFileProtocol>)file type:(GMLFileType)type {
    NSString *fileName = [[file.pathURL lastPathComponent] stringByDeletingPathExtension];
    id<GMLClassProtocol> classModel = [self.ocMapTable objectForKey:fileName];
    if (classModel == nil) {
        switch (type) {
            case GMLFileTypeH:
                if ([fileName hasSuffix:@"-Bridging-Header"]) {
                    _swiftBridgingFileMode = [[GMLFileMode alloc] initWithPathURL:file.pathURL];
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
    NSString *fileName = [[file.pathURL lastPathComponent] stringByDeletingPathExtension];
    id<GMLClassProtocol> classModel = [self.swiftMapTable objectForKey:fileName];
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
    NSString *fileName = [[file.pathURL lastPathComponent] stringByDeletingPathExtension];
    
    BOOL (^addXib) (NSMapTable *) = ^(NSMapTable *mapTable) {
        id<GMLClassProtocol> classModel = [mapTable objectForKey:fileName];
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
    NSString *fileName = [[file.pathURL lastPathComponent] stringByDeletingPathExtension];
    GMLImageFileMode *imageModel = [self.imageMapTable objectForKey:fileName];
    if (imageModel == nil) {
        imageModel = GMLImageFileMode.new;
        [self.imageMapTable setObject:imageModel forKey:fileName];
    }
    [imageModel addFile:file];
}

- (BOOL)addCacheXibToClass:(id<GMLClassProtocol>)targetClass name:(NSString *)name {
    id<GMLFileProtocol> xibFile = [_cacheXibMapTable objectForKey:name];
    if (xibFile) {
        [targetClass addFile:xibFile];
        [_cacheXibMapTable removeObjectForKey:name];
        return YES;
    }
    return NO;
}

#pragma mark - Getter & Setter
- (NSMapTable<NSString *,id<GMLClassProtocol>> *)ocMapTable {
    if (_ocMapTable == nil) {
        _ocMapTable = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory capacity:0];
    }
    return _ocMapTable;
}
- (NSMapTable<NSString *,id<GMLClassProtocol>> *)swiftMapTable {
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

- (GMLPCHFileMode *)pchFileMode {
    if (_pchFileMode == nil) {
        _pchFileMode = GMLPCHFileMode.new;
    }
    return _pchFileMode;
}

- (GMLStoryboardFileMode *)storyboardFileMode {
    if (_storyboardFileMode == nil) {
        _storyboardFileMode = GMLStoryboardFileMode.new;
    }
    return _storyboardFileMode;
}

@end
