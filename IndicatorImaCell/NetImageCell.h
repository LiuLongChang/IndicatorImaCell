//
//  NetImageCell.h
//  IndicatorImaCell
//
//  Created by langyue on 15/11/30.
//  Copyright © 2015年 langyue. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YYAnimatedImageView.h"

@interface NetImageCell : UITableViewCell



@property(nonatomic,strong)YYAnimatedImageView * webImageView;
@property(nonatomic,strong)UIActivityIndicatorView * indicator;
@property(nonatomic,strong)CAShapeLayer * progressLayer;
@property(nonatomic,strong)UILabel * label;


//-(void)setImageUrl:(NSURL*)url;



-(void)setImageURL:(NSURL*)url;



@end
