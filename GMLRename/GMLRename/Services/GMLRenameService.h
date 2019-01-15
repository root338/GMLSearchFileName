//
//  GMLRenameService.h
//  GMLRename
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GMLRenameService : NSObject

@property (nonatomic, copy) NSString *searchPath;
@property (nonatomic, copy) NSArray<NSString *> *renamePaths;

- (void)run;

@end

NS_ASSUME_NONNULL_END
