//
//  GMLSearchService.h
//  YMSearchFile
//
//  Created by apple on 2019/1/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GMLSearchService, GMLProjectMode;
@protocol GMLFolderProtocol;

@protocol GMLSearchServiceDelegate <NSObject>

@required


@optional
- (BOOL)service:(GMLSearchService *)service shouldIgnoreURL:(NSURL *)pathURL;
- (BOOL)service:(GMLSearchService *)service folder:(id<GMLFolderProtocol>)folder;

@end

@interface GMLSearchService : NSObject

@property (nonatomic, weak) id<GMLSearchServiceDelegate> delegate;

- (nullable GMLProjectMode *)searchFolderPathURL:(NSURL *)pathURL isNeedFolderStruct:(BOOL)isNeedFolderStruct;
//- (nullable id<GMLFolderProtocol>)searchFolderPathURL:(NSURL *)pathURL options:(NSDirectoryEnumerationOptions)options;


@end

NS_ASSUME_NONNULL_END
