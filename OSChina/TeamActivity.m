//
//  TeamActivity.m
//  OSChina
//
//  Created by sky on 15/7/24.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamActivity.h"
#import "TeamMember.h"

@implementation TeamActivity

- (instancetype)initWithXML:(ONOXMLElement *)xml
{
    self = [super init];
    if (self) {
        _activityID = [[[xml firstChildWithTag:@"id"] numberValue] intValue];
        _type = [[[xml firstChildWithTag:@"type"] numberValue] intValue];
        _appID = [[[xml firstChildWithTag:@"appid"] numberValue] intValue];
        _appName = [[xml firstChildWithTag:@"appName"] stringValue];
        _replyCount = [[[xml firstChildWithTag:@"reply"] numberValue] intValue];
        _createTime = [[xml firstChildWithTag:@"createTime"] stringValue];
        
        ONOXMLElement *bodyXML = [xml firstChildWithTag:@"body"];
        _title = [[bodyXML firstChildWithTag:@"title"] stringValue];
        _detail = [[bodyXML firstChildWithTag:@"detail"] stringValue];
        _code = [[bodyXML firstChildWithTag:@"code"] stringValue];
        _codeType = [[bodyXML firstChildWithTag:@"codeType"] stringValue];
        _imageURL = [NSURL URLWithString:[[bodyXML firstChildWithTag:@"image"] stringValue]];
        _originImageURL = [NSURL URLWithString:[[bodyXML firstChildWithTag:@"imageOrigin"] stringValue]];
        
        ONOXMLElement *authorXML = [xml firstChildWithTag:@"author"];
        _author = [[TeamMember alloc] initWithXML:authorXML];
    }
    
    return self;
}

- (NSMutableAttributedString *)attributedTitle {
    if (!_attributedTitle) {
        _attributedTitle = [[NSMutableAttributedString alloc] initWithData:[_title dataUsingEncoding:NSUnicodeStringEncoding]
                                                                    options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                         documentAttributes:nil
                                                                      error:nil];

        [_attributedTitle deleteCharactersInRange:NSMakeRange(_attributedTitle.length-1, 1)];
        
        [_attributedTitle addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                   range:NSMakeRange(0, _attributedTitle.length)];
    }
    
    return _attributedTitle;
}

@end
