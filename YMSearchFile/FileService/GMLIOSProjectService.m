//
//  GMLIOSProjectService.m
//  YMSearchFile
//
//  Created by GML on 2019/1/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLIOSProjectService.h"

#import "GMLSearchService.h"

@interface GMLIOSProjectService ()

@property (nonatomic, strong) GMLProjectMode *projectMode;
@property (nonatomic, strong) GMLSearchService *searchService;

@end

@implementation GMLIOSProjectService

- (void)traversingPath:(NSURL *)pathURL {
    self.projectMode = [self.searchService searchFolderPathURL:pathURL isNeedFolderStruct:NO];
}

- (GMLSearchService *)searchService {
    if (_searchService == nil) {
        _searchService = GMLSearchService.new;
    }
    return _searchService;
}



@end
