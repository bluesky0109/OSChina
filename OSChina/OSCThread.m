//
//  OSCThread.m
//  OSChina
//
//  Created by sky on 15/7/15.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCThread.h"
#import "OSCAPI.h"
#import "Config.h"
#import <AFNetworking.h>
#import <AFOnoResponseSerializer.h>
#import <Ono.h>

static BOOL isPollingStarted;
static NSTimer *timer;

@interface OSCThread()

@end

@implementation OSCThread

+ (void)startPollingNotice {
    if (isPollingStarted) {
        return;
    } else {
        timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
        isPollingStarted = YES;
    }
}

+ (void)timerUpdate {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFOnoResponseSerializer XMLResponseSerializer];

    [manager GET:[NSString stringWithFormat:@"%@%@", OSCAPI_PREFIX, OSCAPI_USER_NOTICE]
      parameters:@{@"uid":@([Config getOwnID])}
         success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseObject) {
             ONOXMLElement *notice = [responseObject.rootElement firstChildWithTag:@"notice"];
             int atCount = [[[notice firstChildWithTag:@"atmeCount"] numberValue] intValue];
             int msgCount = [[[notice firstChildWithTag:@"msgCount"] numberValue] intValue];
             int reviewCount = [[[notice firstChildWithTag:@"reviewCount"] numberValue] intValue];
             int newFansCount = [[[notice firstChildWithTag:@"newFansCount"] numberValue] intValue];

             if (atCount || msgCount || reviewCount || newFansCount) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:OSCAPI_USER_NOTICE
                                                                     object:@[@(atCount), @(msgCount), @(reviewCount), @(newFansCount)]];
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"%@", error);
         }];
}

@end
