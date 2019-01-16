//
//  main.m
//  GMLRename
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GMLRenameService.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        GMLRenameService *renameService = GMLRenameService.new;
//        renameService.searchPath = @"/Users/apple/dev/yuemeiProject/YMMainApp/QuickAskCommunity/QuickAskCommunity/Classes/Module/HomePage/Controller/MainController";
        renameService.searchPath = @"/Users/ml/dev/yuemeiProject/QuickAskCommunity/QuickAskCommunity/Classes/Module/HomePage/Controller/DiaryController";
        [renameService run];
    }
    return 0;
}
