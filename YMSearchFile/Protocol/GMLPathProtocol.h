//
//  GMLPathProtocol.h
//  YMSearchFile
//
//  Created by apple on 2019/1/7.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GMLPathProtocol <NSObject>

@property (nonatomic, strong, readonly) NSURL *pathURL;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (nullable instancetype)initWithPathURL:(NSURL *)pathURL;

@end

NS_ASSUME_NONNULL_END
