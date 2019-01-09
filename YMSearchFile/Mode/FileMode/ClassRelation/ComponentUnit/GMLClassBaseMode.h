//
//  GMLClassBaseMode.h
//  YMSearchFile
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMLClassProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface GMLClassBaseMode : NSObject<GMLBaseClassProtocol>

@property (nonatomic, strong) NSURL *pathURL;
@property (nonatomic, strong) NSURL *interfaceFileURL;
@property (nonatomic, strong) NSURL *implementationFileURL;

@end

NS_ASSUME_NONNULL_END
