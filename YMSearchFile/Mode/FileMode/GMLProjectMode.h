//
//  GMLProjectMode.h
//  YMSearchFile
//
//  Created by apple on 2019/1/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GMLFileProtocol, GMLFolderProtocol, GMLClassFileProtocol;
@class GMLPCHFileMode, GMLFileMode, GMLStoryboardFileMode, GMLImageFileMode;
NS_ASSUME_NONNULL_BEGIN

@interface GMLProjectMode : NSObject

@property (nullable, nonatomic, strong, readonly) id<GMLClassFileProtocol> pchClassFile;
@property (nullable, nonatomic, strong, readonly) id<GMLClassFileProtocol> swiftBridgingClassFile;

@property (nullable, nonatomic, strong, readonly) GMLStoryboardFileMode *storyboardFileMode;

@property (nonatomic, strong, readonly) NSMapTable<NSString *, GMLImageFileMode *> *imageMapTable;
@property (nonatomic, strong, readonly) NSMapTable<NSString *, id<GMLFileProtocol>> *aMapTable;
@property (nonatomic, strong, readonly) NSMapTable<NSString *, id<GMLFileProtocol>> *otherMapTable;

@property (nonatomic, strong, readonly) NSMapTable<NSString *, id<GMLClassFileProtocol>> *ocMapTable;
@property (nonatomic, strong, readonly) NSMapTable<NSString *, id<GMLClassFileProtocol>> *swiftMapTable;

- (nullable id<GMLFileProtocol>)addFile:(id<GMLFileProtocol>)file;
- (nullable id<GMLFolderProtocol>)addFolder:(id<GMLFolderProtocol>)folder;

- (void)addIncludeSwiftHeaderClassFile:(id<GMLClassFileProtocol>)classFile;

- (nullable id<GMLClassFileProtocol>)fileAtName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
