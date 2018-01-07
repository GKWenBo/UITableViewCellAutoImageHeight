//
//  ImageViewCell.m
//  UITableViewCellAutoImageHeight
//
//  Created by Admin on 2017/12/29.
//  Copyright © 2017年 WENBO. All rights reserved.
//

#import "ImageViewCell.h"
#import <Masonry.h>

@implementation ImageViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.autoImageView];
    [self.autoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 15, 15, 15));
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark ------ < Getter > ------
#pragma mark
- (UIImageView *)autoImageView {
    if (!_autoImageView) {
        _autoImageView = [UIImageView new];
    }
    return _autoImageView;
}

@end
