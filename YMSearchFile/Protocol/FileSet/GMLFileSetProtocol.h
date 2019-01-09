//
//  GMLFileSetProtocol.h
//  YMSearchFile
//
//  Created by apple on 2019/1/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GMLFileProtocol;
NS_ASSUME_NONNULL_BEGIN

@protocol GMLFileSetProtocol <NSObject>

@required
@property (nullable, nonatomic, strong, readonly) NSArray<id<GMLFileProtocol>> *fileArray;

- (void)addFile:(id<GMLFileProtocol>)file;

@end

NS_ASSUME_NONNULL_END
