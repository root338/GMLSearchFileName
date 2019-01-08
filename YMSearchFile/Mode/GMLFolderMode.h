//
//  GMLFolderMode.h
//  YMSearchFile
//
//  Created by apple on 2019/1/7.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMLFolderProtocol.h"
#import "GMLPathDefineTypeHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface GMLFolderMode : NSObject<GMLFolderProtocol>

@property (nonatomic, assign, readonly) GMLFolderType folderType;


@end

NS_ASSUME_NONNULL_END
