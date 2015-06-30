//
//  PostsViewController.m
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "PostsViewController.h"
#import "PostsCell.h"
#import "OSCPost.h"


static NSString *kPostCellID = @"PostCell";


@interface PostsViewController ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation PostsViewController

- (instancetype)initWithType:(PostsType)type {
    self = [super init];
    if (self) {
        self.generateURL = ^(NSUInteger page) {
            return [NSString stringWithFormat:@"%@%@?catalog=%lu&pageIndex=%lu&%@", OSCAPI_PREFIX, OSCAPI_POSTS_LIST, (unsigned long)type, (unsigned long)page, OSCAPI_SUFFIX];
        };
        
        self.parseXML = ^NSArray * (ONOXMLDocument *xml) {
            return [[xml.rootElement firstChildWithTag:@"posts"] childrenWithTag:@"post"];
        };
        
        self.objClass = [OSCPost class];
    }
    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[PostsCell class] forCellReuseIdentifier:kPostCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.objects.count) {
        PostsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kPostCellID forIndexPath:indexPath];
        OSCPost *post = [self.objects objectAtIndex:indexPath.row];
        
        [cell.portrait sd_setImageWithURL:post.portraitURL placeholderImage:nil options:0];
        [cell.titleLabel setText:post.title];
        [cell.authorLabel setText:post.author];
        [cell.timeLabel setText:[Utils intervalSinceNow:post.pubDate]];
        [cell.commentAndView setText:[NSString stringWithFormat:@"%d回 / %d阅", post.replyCount, post.viewCount]];
        
        return cell;
    } else {
        return self.lastCell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.objects.count) {
        OSCPost *post = [self.objects objectAtIndex:indexPath.row];
        [self.label setText:post.title];
        
        CGSize size = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 52, MAXFLOAT)];
        
        return size.height + 42;
    } else {
        return 60;
    }
}



@end
