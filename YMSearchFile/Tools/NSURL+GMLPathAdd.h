//
//  NSURL+GMLPathAdd.h
//  YMSearchFile
//
//  Created by apple on 2019/1/7.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMLPathDefineTypeHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (GMLPathAdd)

@property (nonatomic, assign, readonly) GMLPathType pathType;

@property (nonatomic, assign, readonly) GMLFolderType folderType;

- (nullable NSArray<NSString *> *)folderListAtToPath:(NSURL *)toPath;
@end

NS_ASSUME_NONNULL_END
