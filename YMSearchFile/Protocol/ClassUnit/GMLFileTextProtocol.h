//
//  GMLFileTextProtocol.h
//  YMSearchFile
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GMLFileTextProtocol <NSObject>
@property (nonatomic, strong, readonly) NSURL *pathURL;
@property (nonatomic, strong, readonly) NSString *contentText;
@end

NS_ASSUME_NONNULL_END
