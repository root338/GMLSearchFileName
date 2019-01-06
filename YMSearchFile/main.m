//
//  main.m
//  YMSearchFile
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GMLProjectGroupingHelper.h"
#import "YMXcodeProjectFileService.h"

#import "NSString+GMLPathTools.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSString *userFolderPath = @"/Users/ml";
        NSString *projectFolderPath = [userFolderPath stringByAppendingPathComponent:@"dev/yuemei_mainAPP/QuickAskCommunity"];
        
        
        
        YMXcodeProjectFileService *fileManager = YMXcodeProjectFileService.new;
        fileManager.fileIndexPath = [projectFolderPath stringByAppendingPathComponent:@"QuickAskCommunity.xcodeproj/project.pbxproj"];
        
        [NSString folderListAtFromPath:userFolderPath toPath:fileManager.fileIndexPath];
        
        fileManager.ignoreSearchPathSet = [NSSet setWithArray: @[
                                                                 [projectFolderPath stringByAppendingPathComponent:@"QuickAskCommunity/Resources"],
                                                                 [projectFolderPath stringByAppendingPathComponent:@"QuickAskCommunity/Classes/Expand/3rdLib/ShareSDK"],
                                                                 [projectFolderPath stringByAppendingPathComponent:@"QuickAskCommunity/Classes/Expand/3rdLib/Alipay"],
                                                                 ]];
        
        fileManager.ignoreRemoveFileAndIncludeFileNameSet = [NSSet setWithArray: @[
                                                                                   @"QuickAskCommunity-Prefix",
                                                                                   @"QuickAskCommunity-Bridging-Header",
                                                                                   ]];
        
        NSString *logFolderPath = [userFolderPath stringByAppendingPathComponent:@"Desktop"];
        
        [fileManager traversingPath:[projectFolderPath stringByAppendingPathComponent:@"QuickAskCommunity"]];
//        [fileManager removeFileAtMaxCitedFileNumber:0];
//        [fileManager outputCitedNumberLogWithFolderPath:logFolderPath];
        NSSet<NSString *> *targetPathSet = [NSSet setWithObjects:[projectFolderPath stringByAppendingPathComponent:@"QuickAskCommunity/Classes"], nil];
        NSSet<NSString *> *baseFolderSet = [GMLProjectGroupingHelper baseFolderSetWithPaths:targetPathSet subpathlevel:2];
        [fileManager outputFolderGroupingLogWithFolderPath:logFolderPath baseFolderSet:baseFolderSet];
    }
    return 0;
}
