//
//  GMLIOSProjectService.m
//  YMSearchFile
//
//  Created by GML on 2019/1/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLIOSProjectService.h"

#import "GMLProjectMode.h"
#import "GMLClassService.h"
#import "GMLSearchService.h"

@interface GMLIOSProjectService ()

@property (nonatomic, strong) GMLClassService *classService;
@property (nonatomic, strong) GMLProjectMode *projectMode;
@property (nonatomic, strong) GMLSearchService *searchService;
@end

@implementation GMLIOSProjectService

- (void)traversingPath:(NSURL *)pathURL {
    self.projectMode = [self.searchService searchFolderPathURL:pathURL isNeedFolderStruct:NO];
    NSArray *values = NSAllMapTableValues(self.projectMode.ocMapTable);
    for (id value in values) {
        [self.classService parserClass:value];
    }
    
}

- (GMLSearchService *)searchService {
    if (_searchService == nil) {
        _searchService = GMLSearchService.new;
    }
    return _searchService;
}

- (GMLClassService *)classService {
    if (_classService == nil) {
        _classService = GMLClassService.new;
    }
    return _classService;
}

@end
