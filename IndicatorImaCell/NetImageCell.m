//
//  NetImageCell.m
//  IndicatorImaCell
//
//  Created by langyue on 15/11/30.
//  Copyright © 2015年 langyue. All rights reserved.
//

#import "NetImageCell.h"
#import "UIView+Plus.h"
#import "CALayer+Plus.h"
#import "UIGestureRecognizer+Plus.h"
#import "UIImageView+YYWebImage.h"


#ifndef kScreenWidth
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#endif

// main screen's height (portrait)
#ifndef kScreenHeight
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#endif


#define kCellHeight ceil((kScreenWidth) * 3.0 / 4.0)

@implementation NetImageCell

- (void)awakeFromNib {
    // Initialization code
}




-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.size = CGSizeMake(kScreenWidth, kCellHeight);
        self.contentView.size = self.size;
        _webImageView = [YYAnimatedImageView new];
        _webImageView.size = self.size;
        _webImageView.clipsToBounds = YES;
        _webImageView.contentMode = UIViewContentModeScaleAspectFill;
        _webImageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_webImageView];
        
        
        
        _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.center = CGPointMake(self.width / 2, self.height / 2);
        _indicator.hidden = YES;
        
        
        _label = [UILabel new];
        _label.size = self.size;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"Load fail, tap to reload.";
        _label.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        _label.hidden = YES;
        _label.userInteractionEnabled = YES;
        [self.contentView addSubview:_label];
        
        
        
        CGFloat lineHeight = 4;
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.size = CGSizeMake(_webImageView.width, lineHeight);
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, _progressLayer.height / 2 )];
        [path addLineToPoint:CGPointMake(_webImageView.width, _progressLayer.height / 2)];
        _progressLayer.lineWidth = lineHeight;
        _progressLayer.path = path.CGPath;
        _progressLayer.strokeColor = [UIColor colorWithRed:0.000 green:0.640 blue:1.000 alpha:0.72].CGColor;
        _progressLayer.lineCap = kCALineCapButt;
        _progressLayer.strokeStart = 0;
        _progressLayer.strokeEnd = 0;
        [_webImageView.layer addSublayer:_progressLayer];
        
        
        
        __weak typeof(self) _self = self;
        UITapGestureRecognizer * g = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id sender) {
            
           
            [_self setImageURL:_self.webImageView.imageURL];
            
            
        }];
        [_label addGestureRecognizer:g];
       
        
    }
    
    return self;
}


-(void)setImageURL:(NSURL*)url{
    
    _label.hidden = YES;
    _indicator.hidden = NO;
    [_indicator startAnimating];
    __weak typeof(self) _self = self;
    
    [CATransaction begin];
    [CATransaction setDisableActions: YES];
    self.progressLayer.hidden = YES;
    self.progressLayer.strokeEnd = 0;
    [CATransaction commit];
    
    [_webImageView setImageWithURL:url
                       placeholder:nil
                           options:YYWebImageOptionProgressiveBlur | YYWebImageOptionShowNetworkActivity | YYWebImageOptionSetImageWithFadeAnimation
                          progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                              if (expectedSize > 0 && receivedSize > 0) {
                                  CGFloat progress = (CGFloat)receivedSize / expectedSize;
                                  progress = progress < 0 ? 0 : progress > 1 ? 1 : progress;
                                  if (_self.progressLayer.hidden) _self.progressLayer.hidden = NO;
                                  _self.progressLayer.strokeEnd = progress;
                              }
                          } transform:nil
                        completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                            if (stage == YYWebImageStageFinished) {
                                _self.progressLayer.hidden = YES;
                                [_self.indicator stopAnimating];
                                _self.indicator.hidden = YES;
                                if (!image) _self.label.hidden = NO;
                            }
                        }];
    
    
    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
