//
//  GMLMethodProtocol.h
//  GMLProjectService
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLTextProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GMLMethodProtocol <GMLTextProtocol>

- (void)changeMethodPrefix:(NSString *)methodPrefix;

@end

NS_ASSUME_NONNULL_END
