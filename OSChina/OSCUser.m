//
//  OSCUser.m
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCUser.h"

static NSString * const kID        = @"uid";
static NSString * const kUserID    = @"userid";
static NSString * const kLocation  = @"location";
static NSString * const kFrom      = @"from";
static NSString * const kName      = @"name";
static NSString * const kFollowers = @"followers";
static NSString * const kFans      = @"fans";
static NSString * const kScore     = @"score";
static NSString * const kPortrait  = @"portrait";
static NSString * const kExpertise = @"expertise";

@interface OSCUser()

@property (readwrite, nonatomic, assign  ) int64_t    userID;
@property (readwrite, nonatomic, strong  ) NSString   *location;
@property (readwrite, nonatomic, strong  ) NSString   *name;
@property (readwrite, nonatomic, assign  ) NSUInteger followersCount;
@property (readwrite, nonatomic, assign  ) NSUInteger fansCount;
@property (readwrite, nonatomic, assign  ) NSInteger  score;
@property (readwrite, nonatomic, strong  ) NSURL      *portraitURL;
@property (readwrite, nonatomic, strong  ) NSString   *expertise;

@end

@implementation OSCUser

- (instancetype)initWithXML:(ONOXMLElement *)xml
{
    self = [super init];
    if (!self) {return nil;}
    
    // 有些API返回用<id>，有些地方用<userid>，这样写是为了简化处理
    self.userID = [[[xml firstChildWithTag:kID] numberValue] longLongValue] | [[[xml firstChildWithTag:kUserID] numberValue] longLongValue];
    self.location = [[xml firstChildWithTag:kLocation] stringValue];
    if (!self.location) {
        self.location = [[xml firstChildWithTag:kFrom] stringValue];
    }
    self.name = [[xml firstChildWithTag:kName] stringValue];
    self.followersCount = [[[xml firstChildWithTag:kFollowers] numberValue] unsignedLongValue];
    self.fansCount = [[[xml firstChildWithTag:kFans] numberValue] unsignedLongValue];
    self.score = [[[xml firstChildWithTag:kScore] numberValue] integerValue];
    self.portraitURL = [NSURL URLWithString:[[xml firstChildWithTag:kPortrait] stringValue]];
    self.expertise = [[xml firstChildWithTag:kExpertise] stringValue];
    
    return self;
}

@end
