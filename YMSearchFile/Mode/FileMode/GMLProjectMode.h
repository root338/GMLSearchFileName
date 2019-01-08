//
//  GMLProjectMode.h
//  YMSearchFile
//
//  Created by apple on 2019/1/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GMLFileProtocol, GMLFolderProtocol, GMLClassProtocol;
@class GMLPCHFileMode, GMLFileMode, GMLStoryboardFileMode, GMLImageFileMode;
NS_ASSUME_NONNULL_BEGIN

@interface GMLProjectMode : NSObject

@property (nullable, nonatomic, strong, readonly) GMLFileMode *swiftHeaderFile;
@property (nullable, nonatomic, strong, readonly) GMLPCHFileMode *pchFileMode;
@property (nullable, nonatomic, strong, readonly) GMLFileMode *swiftBridgingFileMode;
@property (nullable, nonatomic, strong, readonly) GMLStoryboardFileMode *storyboardFileMode;

@property (nonatomic, strong, readonly) NSMapTable<NSString *, GMLImageFileMode *> *imageMapTable;
@property (nonatomic, strong, readonly) NSMapTable<NSString *, id<GMLFileProtocol>> *aMapTable;
@property (nonatomic, strong, readonly) NSMapTable<NSString *, id<GMLFileProtocol>> *otherMapTable;

@property (nonatomic, strong, readonly) NSMapTable<NSString *, id<GMLClassProtocol>> *ocMapTable;
@property (nonatomic, strong, readonly) NSMapTable<NSString *, id<GMLClassProtocol>> *swiftMapTable;

- (nullable GMLFileMode *)addSwiftHeaderFile:(id<GMLFileProtocol>)swiftHeaderFile;
- (nullable id<GMLFileProtocol>)addFile:(id<GMLFileProtocol>)file;
- (nullable id<GMLFolderProtocol>)addFolder:(id<GMLFolderProtocol>)folder;

@end

NS_ASSUME_NONNULL_END
