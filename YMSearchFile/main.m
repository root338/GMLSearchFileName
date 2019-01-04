//
//  main.m
//  YMSearchFile
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YMFileManager.h"

#import "YMProjectMode.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        YMFileManager *fileManager = [YMFileManager defaultManager];

        fileManager.projectFilePath = @"/Users/apple/dev/yuemeiProject/YMMainApp/QuickAskCommunity/QuickAskCommunity.xcodeproj/project.pbxproj";
        
        fileManager.removeNotIncludeFileName = YES;
        fileManager.searchPathBlackList = [NSSet setWithArray: @[
                                            @"/Users/apple/dev/yuemeiProject/YMMainApp/QuickAskCommunity/QuickAskCommunity/Classes/Expand/3rdLib/ShareSDK",
                                            @"/Users/apple/dev/yuemeiProject/YMMainApp/QuickAskCommunity/QuickAskCommunity/Classes/Expand/3rdLib/Alipay",
                                            ]];
        fileManager.removeFileNameBlackList = [NSSet setWithArray: @[
                                                @"ZMCert",
                                                ]];
        fileManager.removeFileNameAndIncludeBlackList = [NSSet setWithArray: @[
                                                @"QuickAskCommunity-Prefix",
                                                @"QuickAskCommunity-Bridging-Header",
                                                                               ]];
        
//        YMProjectMode *projectMode = YMProjectMode.new;
//        projectMode.projectFilePath = @"/Users/apple/dev/yuemeiProject/YMMainApp/QuickAskCommunity/QuickAskCommunity.xcodeproj/project.pbxproj";
//        [projectMode deleteFileName:@"CG_CGKit\\." fileExtension:nil];
        
        // 搜索目录
        [fileManager searchPath:@"/Users/apple/dev/yuemeiProject/YMMainApp/QuickAskCommunity/QuickAskCommunity/Classes/Expand/Macro"];
        // 导出并删除没有被引用的文件
        NSMutableDictionary *dict = [[YMFileManager defaultManager] inputAllFileMode];
//        // 替换项目索引内容
//        [fileManager.projectTextContent writeToFile:fileManager.projectFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//        // 输出日志
//        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:[NSDate date]];
//        NSString *folderName = [NSString stringWithFormat:@"%li-%02li-%02li %02li:%02li:%02li", (long)dateComponents.year, (long)dateComponents.month, (long)dateComponents.day, (long)dateComponents.hour, (long)dateComponents.minute, (long)dateComponents.second];
//        NSString *folderPath = [@"/Users/apple/Desktop" stringByAppendingPathComponent:folderName];
//
//        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
//        [dict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSArray * _Nonnull obj, BOOL * _Nonnull stop) {
//            NSString *filePath = [[folderPath stringByAppendingPathComponent:[key stringValue]] stringByAppendingPathExtension:@"txt"];
//            NSString *fileNameContent = [obj componentsJoinedByString:@"\n"];
//            [fileNameContent writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//        }];
    }
    return 0;
}
