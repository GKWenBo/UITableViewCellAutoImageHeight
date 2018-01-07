//
//  TableViewController.m
//  UITableViewCellAutoImageHeight
//
//  Created by Admin on 2017/12/29.
//  Copyright © 2017年 WENBO. All rights reserved.
//

#import "TableViewController.h"

#import <UIImageView+WebCache.h>

#import "ImageViewCell.h"
static NSString *kIdentifier = @"ImageViewCell";

@interface TableViewController ()

@property (nonatomic, strong) NSArray *imageUrlArray;
@property (nonatomic, strong) NSMutableDictionary *heightDict;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.contentInset = UIEdgeInsetsMake([UIApplication sharedApplication].statusBarFrame.size.height, 0, 0, 0);
    self.tableView.tableFooterView = [UIView new];
    if (@available(iOS 11,*)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.tableView registerClass:[ImageViewCell class] forCellReuseIdentifier:kIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imageUrlArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *url = self.imageUrlArray[indexPath.row];
    [cell.autoImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image.size.height) {
            /**  < 图片宽度 >  */
            CGFloat imageW = [UIScreen mainScreen].bounds.size.width - 2 * 15;
            /**  <根据比例 计算图片高度 >  */
            CGFloat ratio = image.size.height / image.size.width;
             /**  < 图片高度 + 间距 >  */
            CGFloat imageH = ratio * imageW + 15;
            /**  < 缓存图片高度 没有缓存则缓存 刷新indexPath >  */
            if (![[self.heightDict allKeys] containsObject:@(indexPath.row)]) {
                [self.heightDict setObject:@(imageH) forKey:@(indexPath.row)];
                [self.tableView beginUpdates];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];
            }
        }
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self.heightDict objectForKey:@(indexPath.row)] floatValue];
}

- (NSArray *)imageUrlArray {
    if (!_imageUrlArray) {
        _imageUrlArray = @[@"http://pics.sc.chinaz.com/files/pic/pic9/201712/zzpic8996.jpg",
                           @"http://pics.sc.chinaz.com/files/pic/pic9/201711/zzpic8500.jpg",
                           @"http://pics.sc.chinaz.com/files/pic/pic9/201711/zzpic8416.jpg",
                           @"http://pics.sc.chinaz.com/files/pic/pic9/201711/bpic4293.jpg"];
    }
    return _imageUrlArray;
}

- (NSMutableDictionary *)heightDict {
    if (!_heightDict) {
        _heightDict = @{}.mutableCopy;
    }
    return _heightDict;
}

@end
