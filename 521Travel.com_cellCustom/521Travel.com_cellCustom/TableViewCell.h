//
//  TableViewCell.h
//  UserZFPlayer
//
//  Created by youngstar on 16/12/22.
//  Copyright © 2016年 521Travel.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+AkColor.h"
#import "UIView+LSAdditions.h"
#import "DataModel.h"

@interface TableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *photo;
@property (nonatomic, strong) UILabel *describe;

@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) CGSize describeSize;

@property (nonatomic, strong) DataModel *model;

- (void)setModel:(DataModel *)model;

// 获取cell的高度的方法
- (CGFloat)cellForHeight;
@end
