//
//  GMLClassFileService.h
//  YMSearchFile
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GMLClassFileProtocol;
@class GMLClassFileService;

@protocol GMLClassFileServiceDelegate <NSObject>

@required
- (nullable id<GMLClassFileProtocol>)service:(GMLClassFileService *)service sourceClassFile:(id<GMLClassFileProtocol>)sourceClassFile importFileName:(NSString *)importFileName;

@optional
- (void)service:(GMLClassFileService *)service sourceClassFile:(id<GMLClassFileProtocol>)sourceClassFile existFolder:(nullable NSURL *)existFolder;

@end

@interface GMLClassFileService : NSObject

@property (nonatomic, weak) id<GMLClassFileServiceDelegate> delegate;

@property (nonatomic, strong) NSArray<NSURL *> *folderArray;

- (void)parserClassFile:(id<GMLClassFileProtocol>)classFile;

@end

NS_ASSUME_NONNULL_END
