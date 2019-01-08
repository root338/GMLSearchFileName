//
//  GMLFileMode.h
//  YMSearchFile
//
//  Created by apple on 2019/1/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMLFileProtocol.h"
#import "GMLPathDefineTypeHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface GMLFileMode : NSObject<GMLFileProtocol>

@property (nonatomic, assign, readonly) GMLFileType fileType;

@end

NS_ASSUME_NONNULL_END
