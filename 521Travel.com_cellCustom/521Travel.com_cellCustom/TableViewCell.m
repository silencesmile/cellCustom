//
//  TableViewCell.m
//  UserZFPlayer
//
//  Created by youngstar on 16/12/22.
//  Copyright © 2016年 521Travel.com. All rights reserved.
//

#import "TableViewCell.h"
#import "UIView+LSAdditions.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#import "SDImageCache.h"
#import "SDWebImageDownloaderOperation.h"

@implementation TableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    self.photo = [[UIImageView alloc]initWithFrame:(CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 100))];
    _photo.userInteractionEnabled = YES;
    _photo.layer.masksToBounds = YES;
    _photo.backgroundColor = [UIColor brownColor];
    
    self.title = [[UILabel alloc]initWithFrame:(CGRectMake(_photo.left, _photo.top, _photo.width , 30))];
    _title.textColor = [UIColor redColor];
    
    self.describe = [[UILabel alloc]initWithFrame:(CGRectMake(_photo.left, _photo.bottom + 5, _photo.width, 40))];
    self.describe.numberOfLines = 0;
    
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.contentView addSubview:self.photo];
    [self.photo addSubview:self.title];
    [self.contentView addSubview:self.describe];
    
    _photo.layer.masksToBounds = YES;
}

- (void)setModel:(DataModel *)model
{
    self.title.text = model.title;
    // 给图片赋值
    [self setImageURLSize:model.imageURL];
    
    // 给文字赋值
    [self setreviewContentText:model.describe];
  
}

-(void)setImageURLSize:(NSString*)imageURL
{
    // 先从缓存中查找图片
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey: imageURL];
    
    // 没有找到已下载的图片就使用默认的占位图，当然高度也是默认的高度了，除了高度不固定的文字部分。
    if (!image) {
        image = [UIImage imageNamed:@"Wechat"];
        [self downloadImage:imageURL];
    }
    else
    {
        self.photo.image = image;
        //手动计算cell
        CGFloat imgHeight = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
        _photo.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , imgHeight);
        _imageSize.height = imgHeight;
    }
}

- (void)downloadImage:(NSString*)imageURL
{
    // 利用 SDWebImage 框架提供的功能下载图片
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageURL] options:(SDWebImageDownloaderUseNSURLCache) progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        [[SDImageCache sharedImageCache] storeImage:image forKey:imageURL toDisk:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
                    // 回到主线程做操作
//            self.photo.image = image;
//            CGFloat imgHeight = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
//            _photo.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, imgHeight);
//            _imageSize.height = imgHeight;
            
            // 请求完成 刷新代码
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:nil];
            
            
                    });
    }];
    
}

//赋值 and 自动换行,计算出cell的高度
-(void)setreviewContentText:(NSString*)text
{
    
    //获得当前cell高度
    CGRect frame = [self frame];
    
    //文本赋值
    self.describe.text = text;
    
    //设置label的最大行数
    self.describe.numberOfLines = 0;
    CGSize size = CGSizeMake(self.width-30, 1000);
    self.describeSize = [self.describe.text sizeWithFont:self.describe.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    self.describe.frame = CGRectMake(self.describe.frame.origin.x, self.photo.bottom + 10, _describe.width, _describeSize.height);
    frame.size.height = _describe.height;
    
    self.frame = frame;
    
}


- (CGFloat)cellForHeight
{
    return _imageSize.height + _describeSize.height;
}


@end
