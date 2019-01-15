//
//  GMLStack.m
//  GMLRename
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLStack.h"

@interface GMLStack ()

@property (nonatomic, strong) NSMutableArray *stackList;

@end

@implementation GMLStack

- (id)push:(id)obj {
    [self.stackList addObject:obj];
    return obj;
}

- (id)pop {
    id obj = self.stackList.lastObject;
    [self.stackList lastObject];
    return obj;
}

- (NSMutableArray *)stackList {
    if (_stackList == nil) {
        _stackList = NSMutableArray.array;
    }
    return _stackList;
}

@end
