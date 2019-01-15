//
//  GMLSearchFileService.h
//  GMLRename
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMLSearchFileConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@class GMLSearchFileService;

@protocol GMLSearchFileServiceDelegate <NSObject>

@required
- (void)service:(GMLSearchFileService *)service filePath:(NSString *)filePath;

@optional
- (BOOL)service:(GMLSearchFileService *)service shouldIgnoreFolderPath:(NSString *)folderPath;

- (void)service:(GMLSearchFileService *)service beginFolderPath:(NSString *)folderPath;
- (void)service:(GMLSearchFileService *)service endFolderPath:(NSString *)folderPath;

//- (BOOL)service:(GMLSearchFileService *)service filePath:(NSString *)filePath inFramework:(NSString *)framework;
//- (BOOL)service:(GMLSearchFileService *)service filePath:(NSString *)filePath inBundle:(NSString *)bundle;


@end

@interface GMLSearchFileService : NSObject

@property (nonatomic, weak) id<GMLSearchFileServiceDelegate> delegate;

@property (nonatomic, strong) GMLSearchFileConfiguration *configuration;

- (void)startSearchPath:(NSString *)targetPath;

@end

NS_ASSUME_NONNULL_END
