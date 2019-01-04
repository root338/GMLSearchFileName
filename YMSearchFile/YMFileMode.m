//
//  YMFileMode.m
//  YMSearchFile
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019 apple. All rights reserved.
//

#import "YMFileMode.h"

@implementation YMFileMode

- (NSMutableSet *)citedFileNameSets {
    if (_citedFileNameSets == nil) {
        _citedFileNameSets = NSMutableSet.set;
    }
    return _citedFileNameSets;
}

- (NSMutableSet *)includeFileNameSets {
    if (_includeFileNameSets == nil) {
        _includeFileNameSets = NSMutableSet.set;
    }
    return _includeFileNameSets;
}

@end
