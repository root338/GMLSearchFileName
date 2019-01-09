//
//  GMLClassService.h
//  YMSearchFile
//
//  Created by apple on 2019/1/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol GMLClassFileProtocol;
@class GMLClassService;

@protocol GMLClassServiceDelegate <NSObject>

@required

@optional


@end

@interface GMLClassService : NSObject

- (void)parserClass:(id<GMLClassFileProtocol>)targetClass;

@end

NS_ASSUME_NONNULL_END
