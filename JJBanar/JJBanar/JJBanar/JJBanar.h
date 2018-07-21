//
//  JJBanar.h
//  JJBanar
//
//  Created by 16 on 2018/7/22.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    JJBannarViewDirectionUp,// 向上滚动
    JJBannarViewDirectionLeft,// 向左滚动
    JJBannarViewDirectionDown,// 向下滚动
    JJBannarViewDirectionRight// 向右滚动
}JJBannarViewDirection;

typedef enum{
    JJBannarViewPageStyleCircle,// 圆圈
    JJBannarViewPageStyleTitle,// 文字
    JJBannarViewPageStyleNone,// 无效果
}JJBannarViewPageStyle;

typedef void(^JJBannarViewCilckBlock)(NSInteger num, NSArray *items);
@interface JJBannar : UIView

///数据源(返回的是子控件数组)
@property (nonatomic , strong , readonly) NSArray <UIView*> *items;
///数据源(返回的是图片数组)
@property (nonatomic , strong , readonly) NSArray *imgs;
///当前页提示类型
@property (nonatomic , assign) JJBannarViewPageStyle pageStyle;

/**
 设置数据源(传子视图数组形式)
 */
- (void)setUpItems:(NSArray<UIView*> *)items;

/**
 设置数据源(传图片url数组形式)
 */
- (void)setUpImgs:(NSArray *)imgs;

/**
 创建bannar视图(添加子视图形式)
 */
- (instancetype)initWithFrame:(CGRect)frame direction:(JJBannarViewDirection)direction interval:(CGFloat)interval;

/**
 创建bannar视图(展示图片形式)
 */
- (instancetype)initWithFrame:(CGRect)frame direction:(JJBannarViewDirection)direction interval:(CGFloat)interval click:(JJBannarViewCilckBlock)block;
@end

