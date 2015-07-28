//
//  TeamWeeklyReportDetail.m
//  OSChina
//
//  Created by sky on 15/7/27.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamWeeklyReportDetail.h"

@implementation TeamWeeklyReportDetail

- (instancetype)initWithXML:(ONOXMLElement *)xml
{
    self = [super init];
    if (self) {
        _reportID = [[[xml firstChildWithTag:@"id"] numberValue] intValue];
        _title = [[xml firstChildWithTag:@"title"] stringValue];
        _replyCount = [[[xml firstChildWithTag:@"reply"] numberValue] intValue];
        _createTime = [[xml firstChildWithTag:@"createTime"] stringValue];
        
        ONOXMLElement *authorXML = [xml firstChildWithTag:@"author"];
        _author = [[TeamMember alloc] initWithXML:authorXML];
        
        _summary = [[xml firstChildWithTag:@"summary"] stringValue];
        
        ONOXMLElement *detailsXML = [xml firstChildWithTag:@"detail"];
        NSArray *tags = @[@"sun", @"sat", @"fri", @"thu", @"wed", @"tue", @"mon"];
        NSArray *days = @[@"星期天", @"星期六", @"星期五", @"星期四", @"星期三", @"星期二", @"星期一"];
        NSMutableArray *mutableDetails = [NSMutableArray new];
        [tags enumerateObjectsUsingBlock:^(NSString *tag, NSUInteger idx, BOOL *stop) {
            NSString *HTML = [detailsXML firstChildWithTag:tag].stringValue;
            NSMutableAttributedString *attributedDetail = [[NSMutableAttributedString alloc] initWithData:[HTML dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                                  options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                                                       documentAttributes:nil
                                                                                                    error:nil];
            
            [attributedDetail addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                      range:NSMakeRange(0, attributedDetail.length)];
            
            if (HTML) {
                [mutableDetails addObject:@[days[idx], attributedDetail]];
                _days++;
            }
        }];
        
        _details = [NSArray arrayWithArray:mutableDetails];
    }
    
    return self;
}



@end