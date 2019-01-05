//
//  main.m
//  YMSearchFile
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YMXcodeProjectFileService.h"

#import "YMProjectMode.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSString *userFolderPath = @"/Users/ml";
        NSString *projectFolderPath = [userFolderPath stringByAppendingPathComponent:@"dev/yuemei_mainAPP/QuickAskCommunity"];
        
        YMXcodeProjectFileService *fileManager = YMXcodeProjectFileService.new;
        fileManager.fileIndexPath = [projectFolderPath stringByAppendingPathComponent:@"QuickAskCommunity.xcodeproj/project.pbxproj"];
        
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
        
//        [fileManager traversingPath:[projectFolderPath stringByAppendingPathComponent:@"QuickAskCommunity"]];
//        [fileManager removeFileAtMaxCitedFileNumber:0];
//        [fileManager outputCitedNumberLogWithFolderPath:logFolderPath];
        
        NSArray *baseFolderArray = @[
                                     
                                     ];
//        [fileManager outputFolderGroupingLogWithFolderPath:logFolderPath baseFolderSet:];
    }
    return 0;
}
