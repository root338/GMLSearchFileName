//
//  GMLClassFileMode.h
//  YMSearchFile
//
//  Created by apple on 2019/1/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMLClassFileProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface GMLClassFileMode : NSObject<GMLClassFileProtocol>

@property (nonatomic, strong) NSString *name;

@end

NS_ASSUME_NONNULL_END
