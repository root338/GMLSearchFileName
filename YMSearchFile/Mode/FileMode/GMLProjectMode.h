//
//  GMLProjectMode.h
//  YMSearchFile
//
//  Created by apple on 2019/1/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GMLFileProtocol, GMLFolderProtocol;
NS_ASSUME_NONNULL_BEGIN

@interface GMLProjectMode : NSObject

- (nullable id<GMLFileProtocol>)addFile:(id<GMLFileProtocol>)file;
- (nullable id<GMLFolderProtocol>)addFolder:(id<GMLFolderProtocol>)folder;

@end

NS_ASSUME_NONNULL_END
