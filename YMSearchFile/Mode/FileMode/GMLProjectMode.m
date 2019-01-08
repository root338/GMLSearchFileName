//
//  GMLProjectMode.m
//  YMSearchFile
//
//  Created by apple on 2019/1/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLProjectMode.h"

#import "GMLPCHFileMode.h"
#import "GMLClassFileMode.h"
#import "GMLImageFileMode.h"
#import "GMLSwiftClassFileMode.h"
#import "GMLStoryboardFileMode.h"
#import "GMLSwiftBridgingFileMode.h"

#import "GMLFileProtocol.h"
#import "NSURL+GMLPathAdd.h"

@interface GMLProjectMode ()

@property (nonatomic, strong) GMLPCHFileMode *pchFileMode;
@property (nonatomic, strong) GMLSwiftBridgingFileMode *swiftBridgingFileMode;
@property (nonatomic, strong) GMLStoryboardFileMode *storyboardFileMode;

@property (nonatomic, strong) NSMapTable<NSString *, id<GMLFileProtocol>> *cacheXibMapTable;

@property (nonatomic, strong) NSMapTable<NSString *, id<GMLClassProtocol>> *classMapTable;
@property (nonatomic, strong) NSMapTable<NSString *, GMLImageFileMode *> *imageMapTable;
@property (nonatomic, strong) NSMapTable<NSString *, id<GMLFileProtocol>> *aMapTable;
@property (nonatomic, strong) NSMapTable<NSString *, id<GMLFileProtocol>> *otherMapTable;

@end

@implementation GMLProjectMode

- (id<GMLFileProtocol>)addFile:(id<GMLFileProtocol>)file {
    GMLFileType fileType = file.pathURL.fileType;
    switch (fileType) {
        case GMLFileTypeH:
        case GMLFileTypeM:
        case GMLFileTypeMM:
        case GMLFileTypeSwift:
        case GMLFileTypeXib: {
            [self addClassRelationFile:file type:fileType];
        }
            break;
        case GMLFileTypeJPG:
        case GMLFileTypePNG:
        case GMLFileTypeGIF: {
            [self addImageRelationFile:file type:fileType];
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

- (void)addClassRelationFile:(id<GMLFileProtocol>)file type:(GMLFileType)type {
    NSString *fileName = [[file.pathURL lastPathComponent] stringByDeletingPathExtension];
    id<GMLClassProtocol> classModel = [self.classMapTable objectForKey:fileName];
    if (classModel == nil) {
        switch (type) {
            case GMLFileTypeSwift: {
                classModel = GMLSwiftClassFileMode.new;
            }
                break;
            case GMLFileTypeH:
            case GMLFileTypeM:
            case GMLFileTypeMM: {
                classModel = GMLClassFileMode.new;
            }
                break;
            case GMLFileTypeXib: {
                [self.cacheXibMapTable setObject:file forKey:fileName];
            }
                break;
            default:
                return;
        }
        if (classModel) {
            id<GMLFileProtocol> xibFile = [_cacheXibMapTable objectForKey:fileName];
            if (xibFile) {
                [classModel addFile:xibFile];
                [_cacheXibMapTable removeObjectForKey:fileName];
            }
            [self.classMapTable setObject:classModel forKey:fileName];
        }
    }
    [classModel addFile:file];
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

#pragma mark - Getter & Setter
- (NSMapTable<NSString *, id<GMLClassProtocol>> *)classMapTable {
    if (_classMapTable == nil) {
        _classMapTable = [[NSMapTable alloc] initWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableWeakMemory capacity:0];
    }
    return _classMapTable;
}

- (NSMapTable<NSString *, GMLImageFileMode *> *)imageMapTable {
    if (_imageMapTable == nil) {
        _imageMapTable = [[NSMapTable alloc] initWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableWeakMemory capacity:0];
    }
    return _imageMapTable;
}

- (NSMapTable<NSString *, id<GMLFileProtocol>> *)aMapTable {
    if (_aMapTable == nil) {
        _aMapTable = [[NSMapTable alloc] initWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableWeakMemory capacity:0];
    }
    return _aMapTable;
}

- (NSMapTable<NSString *,id<GMLFileProtocol>> *)otherMapTable {
    if (_otherMapTable == nil) {
        _otherMapTable = [[NSMapTable alloc] initWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableWeakMemory capacity:0];
    }
    return _otherMapTable;
}

- (NSMapTable<NSString *,id<GMLFileProtocol>> *)cacheXibMapTable {
    if (_cacheXibMapTable == nil) {
        _cacheXibMapTable = [[NSMapTable alloc] initWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableWeakMemory capacity:0];
    }
    return _cacheXibMapTable;
}

- (GMLPCHFileMode *)pchFileMode {
    if (_pchFileMode == nil) {
        _pchFileMode = GMLPCHFileMode.new;
    }
    return _pchFileMode;
}

- (GMLSwiftBridgingFileMode *)swiftBridgingFileMode {
    if (_swiftBridgingFileMode == nil) {
        _swiftBridgingFileMode = GMLSwiftBridgingFileMode.new;
    }
    return _swiftBridgingFileMode;
}

- (GMLStoryboardFileMode *)storyboardFileMode {
    if (_storyboardFileMode == nil) {
        _storyboardFileMode = GMLStoryboardFileMode.new;
    }
    return _storyboardFileMode;
}

@end
