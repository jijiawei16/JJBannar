//
//  JJBannar.m
//  JJBannar
//
//  Created by 16 on 2018/7/23.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import "JJBannar.h"
#import "JJWebImage.h"

#define sw self.frame.size.width
#define sh self.frame.size.height
@interface JJBannar ()<UIScrollViewDelegate>

///底部展示视图
@property (nonatomic , strong) UIScrollView *scrollView;
///滚动方向
@property (nonatomic , assign) JJBannarViewDirection direction;
///pageControl
@property (nonatomic , strong) UIPageControl *pageControl;
///展示标题
@property (nonatomic , strong) UILabel *pageTitle;
///手动滑动方向
@property (nonatomic , assign) JJBannarViewDirection slidingDirection;
///回调
@property (nonatomic , copy) JJBannarViewCilckBlock block;
///当前页数
@property (nonatomic , assign) NSInteger currentNum;
///下一页
@property (nonatomic , assign) NSInteger nextNum;
///定时器
@property (nonatomic , strong) NSTimer *timer;
///当前X轴偏移量
@property (nonatomic , assign) CGFloat currentContentOffsetX;
///当前Y轴偏移量
@property (nonatomic , assign) CGFloat currentContentOffsetY;
///下一个imageView,用于做底层视图
@property (nonatomic , strong) UIImageView *otherImageView;
///当前的imageView,用于做底层视图
@property (nonatomic , strong) UIImageView *currentImageView;
///滚动时间间隔
@property (nonatomic , assign) CGFloat interval;
@end
@implementation JJBannar

#pragma 展示图片格式
- (instancetype)initWithFrame:(CGRect)frame
                    direction:(JJBannarViewDirection)direction
                     interval:(CGFloat)interval
                        click:(JJBannarViewCilckBlock)block
{
    // 保存点击回调
    _block = block;
    return [self initWithFrame:frame direction:direction interval:interval];
}
#pragma mark 展示子视图格式
- (instancetype)initWithFrame:(CGRect)frame
                    direction:(JJBannarViewDirection)direction
                     interval:(CGFloat)interval
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 设置时间间隔
        self.interval = interval;
        // 设置首页角标
        self.currentNum = 1;
        // 保存该控件的自动滚动方式
        _direction = direction;
        // 默认设置显示当前页类型是圆圈类型
        _pageStyle = JJBannarViewPageStyleCircle;
        // 添加观察者,用来监听手势滑动方向
        [self addObserver:self forKeyPath:@"slidingDirection" options:NSKeyValueObservingOptionNew context:nil];
        // 给控件添加手势
        UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfClicked:)];
        click.numberOfTapsRequired = 1;
        [self addGestureRecognizer:click];
        self.userInteractionEnabled = YES;
    }
    return self;
}
#pragma 设置数据源(展示子视图形式)
- (void)setUpItems:(NSArray<UIView *> *)items
{
    _items = items;
    if (_items.count > 0) {
        
        // 设置当前图片的图片
        [self.currentImageView addSubview:_items[0]];
        // 添加视图
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.otherImageView];
        [self.scrollView addSubview:self.currentImageView];
        if (self.direction == JJBannarViewDirectionLeft||self.direction == JJBannarViewDirectionRight) {
            self.currentImageView.frame = CGRectMake(sw, 0, sw, sh);
            self.otherImageView.frame = CGRectMake(0, 0, sw, sh);
            self.scrollView.contentOffset = CGPointMake(sw, 0);
            self.scrollView.contentSize = CGSizeMake(sw*3, 0);
        }else {
            self.currentImageView.frame = CGRectMake(0, sh, sw, sh);
            self.otherImageView.frame = CGRectMake(0, 0, sw, sh);
            self.scrollView.contentOffset = CGPointMake(0, sh);
            self.scrollView.contentSize = CGSizeMake(0, sh*3);
        }
        
        // 设置page的数量
        self.pageControl.numberOfPages = items.count;
        // 添加page提示视图
        [self reloadPageView];
        
        // 判断是否可以滑动,如果是一张就不可以滑动
        if (items.count == 1) {
            self.scrollView.scrollEnabled = NO;
        }else{
            self.scrollView.scrollEnabled = YES;
            [self startTimer];// 开启定时器
        }
    }
}
#pragma 设置数据源(展示图片形式)
- (void)setUpImgs:(NSArray *)imgs
{
    _imgs = imgs;
    if (imgs.count > 0) {
        
        // 设置当前图片的图片
        [self.currentImageView jj_setImageWithUrl:[NSURL URLWithString:imgs[0]]];
        
        // 添加视图
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.otherImageView];
        [self.scrollView addSubview:self.currentImageView];
        if (self.direction == JJBannarViewDirectionLeft||self.direction == JJBannarViewDirectionRight) {
            self.currentImageView.frame = CGRectMake(sw, 0, sw, sh);
            self.otherImageView.frame = CGRectMake(0, 0, sw, sh);
            self.scrollView.contentOffset = CGPointMake(sw, 0);
            self.scrollView.contentSize = CGSizeMake(sw*3, 0);
        }else {
            self.currentImageView.frame = CGRectMake(0, sh, sw, sh);
            self.otherImageView.frame = CGRectMake(0, 0, sw, sh);
            self.scrollView.contentOffset = CGPointMake(0, sh);
            self.scrollView.contentSize = CGSizeMake(0, sh*3);
        }
        
        // 设置page的数量
        self.pageControl.numberOfPages = imgs.count;
        // 添加page提示视图
        [self reloadPageView];
        
        // 判断是否可以滑动,如果是一张就不可以滑动
        if (imgs.count == 1) {
            self.scrollView.scrollEnabled = NO;
        }else{
            self.scrollView.scrollEnabled = YES;
            [self startTimer];// 开启定时器
        }
    }
}
#pragma mark scrollView代理方法
// 监听scrollView的滑动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 设置该控件的滚动方向
    if (self.direction == JJBannarViewDirectionRight||self.direction == JJBannarViewDirectionLeft) {
        if (scrollView.contentOffset.x != sw) {
            self.slidingDirection = scrollView.contentOffset.x >sw? JJBannarViewDirectionLeft : JJBannarViewDirectionRight;
        }
    }else {
        if (scrollView.contentOffset.y != sh) {
            self.slidingDirection = scrollView.contentOffset.y >sh? JJBannarViewDirectionUp : JJBannarViewDirectionDown;
        }
    }
}
// scrollView手动滑动停止时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self reloadScrollView];
}
// scrollView停止滚动时调用(非手动)
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self reloadScrollView];
}
// 刷新scrollView展示视图
- (void)reloadScrollView
{
    switch (_slidingDirection) {
        case JJBannarViewDirectionUp:
            [self directionUpOrDown];
            break;
        case JJBannarViewDirectionLeft:
            [self directionRightOrLeft];
            break;
        case JJBannarViewDirectionDown:
            [self directionUpOrDown];
            break;
        case JJBannarViewDirectionRight:
            [self directionRightOrLeft];
            break;
        default:
            break;
    }
    [self reloadPageView];
}
// 滚动方向是水平方向
- (void)directionRightOrLeft
{
    NSInteger index = self.scrollView.contentOffset.x/sw;
    if (index == 1) return;
    self.currentNum = self.nextNum;
    if (_imgs) {
        [self.currentImageView jj_setImageWithUrl:[NSURL URLWithString:_imgs[self.nextNum-1]]];
    }
    if (_items) {
        [self.currentImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.currentImageView addSubview:self.items[self.nextNum-1]];
    }
    self.scrollView.contentOffset = CGPointMake(sw, 0);
}
// 滚动方向是竖直方向
- (void)directionUpOrDown
{
    NSInteger index = self.scrollView.contentOffset.y/sh;
    if (index == 1) return;
    self.currentNum = self.nextNum;
    if (_imgs) {
        [self.currentImageView jj_setImageWithUrl:[NSURL URLWithString:_imgs[self.nextNum-1]]];
    }
    if (_items) {
        [self.currentImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.currentImageView addSubview:self.items[self.nextNum-1]];
    }
    self.scrollView.contentOffset = CGPointMake(0, sh);
}
// 手动滑动时应该暂停定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
}
// 手动滑动停止时开启定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}
#pragma mark KVO监听方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 如果没变return
    if(change[NSKeyValueChangeNewKey] == change[NSKeyValueChangeOldKey]) return;
    switch (_slidingDirection) {
        case JJBannarViewDirectionUp:// 向上滚动
            self.otherImageView.frame = CGRectMake(0, sh*2, sw, sh);
            self.nextNum = self.currentNum+1;
            if (_imgs) {
                if (self.currentNum == self.imgs.count) {
                    self.nextNum = 1;
                }
                [self.otherImageView jj_setImageWithUrl:[NSURL URLWithString:_imgs[self.nextNum-1]]];
            }else {
                if (self.currentNum == self.items.count) {
                    self.nextNum = 1;
                }
                [self.otherImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [self.otherImageView addSubview:self.items[self.nextNum-1]];
            }
            break;
        case JJBannarViewDirectionLeft:// 向左滚动
            self.otherImageView.frame = CGRectMake(sw*2, 0, sw, sh);
            self.nextNum = self.currentNum+1;
            if (_imgs) {
                if (self.currentNum == self.imgs.count) {
                    self.nextNum = 1;
                }
                [self.otherImageView jj_setImageWithUrl:[NSURL URLWithString:_imgs[self.nextNum-1]]];
            }else {
                if (self.currentNum == self.items.count) {
                    self.nextNum = 1;
                }
                [self.otherImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [self.otherImageView addSubview:self.items[self.nextNum-1]];
            }
            break;
        case JJBannarViewDirectionDown:// 向下滚动
            self.otherImageView.frame = CGRectMake(0, 0, sw, sh);
            self.nextNum = self.currentNum-1;
            if (_imgs) {
                if (self.currentNum == 1) {
                    self.nextNum = self.imgs.count;
                }
                [self.otherImageView jj_setImageWithUrl:[NSURL URLWithString:_imgs[self.nextNum-1]]];
            }else {
                if (self.currentNum == 1) {
                    self.nextNum = self.items.count;
                }
                [self.otherImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [self.otherImageView addSubview:self.items[self.nextNum-1]];
            }
            break;
        case JJBannarViewDirectionRight:// 向右滚动
            self.otherImageView.frame = CGRectMake(0, 0, sw, sh);
            self.nextNum = self.currentNum-1;
            if (_imgs) {
                if (self.currentNum == 1) {
                    self.nextNum = self.imgs.count;
                }
                [self.otherImageView jj_setImageWithUrl:[NSURL URLWithString:_imgs[self.nextNum-1]]];
            }
            if (_items) {
                if (self.currentNum == 1) {
                    self.nextNum = self.items.count;
                }
                [self.otherImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [self.otherImageView addSubview:self.items[self.nextNum-1]];
            }
            break;
        default:
            break;
    }
}
#pragma mark 一些特定的刷新方法
- (void)reloadPageView
{
    switch (_pageStyle) {
        case JJBannarViewPageStyleCircle:
            if (_pageTitle) [_pageTitle removeFromSuperview];
            self.pageControl.currentPage = self.currentNum-1;
            break;
        case JJBannarViewPageStyleTitle:
            if (_pageControl) [_pageControl removeFromSuperview];
            self.pageTitle.text = [NSString stringWithFormat:@"%ld/%lu",self.currentNum,(unsigned long)_items?_items.count:_imgs.count];
            break;
        case JJBannarViewPageStyleNone:
            if (_pageControl) [_pageControl removeFromSuperview];
            if (_pageTitle) [_pageTitle removeFromSuperview];
            break;
        default:
            break;
    }
}
#pragma mark 定时器的逻辑
- (void)startTimer
{
    self.timer = [NSTimer timerWithTimeInterval:self.interval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
//动画改变scrollview的偏移量就可以实现自动滚动
- (void)nextPage
{
    if (_direction == JJBannarViewDirectionUp) {
        [self.scrollView setContentOffset:CGPointMake(0, sh*2) animated:YES];
    }else if (_direction == JJBannarViewDirectionLeft) {
        [self.scrollView setContentOffset:CGPointMake(sw*2, 0) animated:YES];
    }else if (_direction == JJBannarViewDirectionDown) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if (_direction == JJBannarViewDirectionRight) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
#pragma mark 设置控件属性
- (void)setPageStyle:(JJBannarViewPageStyle)pageStyle
{
    _pageStyle = pageStyle;
    [self reloadPageView];
}
#pragma mark 当前控件点击事件
- (void)selfClicked:(UITapGestureRecognizer *)sender
{
    self.block(self.currentNum, _imgs?_imgs:_items);
}
#pragma mark 懒加载
-(UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, sw, sh)];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}
-(UIImageView *)otherImageView
{
    if (_otherImageView == nil)
    {
        _otherImageView = [[UIImageView alloc]init];
        _otherImageView.layer.masksToBounds = YES;
        _otherImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _otherImageView;
}
-(UIImageView *)currentImageView
{
    if (_currentImageView == nil)
    {
        _currentImageView = [[UIImageView alloc]init];
        _currentImageView.layer.masksToBounds = YES;
        _currentImageView.contentMode = UIViewContentModeScaleAspectFill;
        _currentImageView.userInteractionEnabled = YES;
    }
    return _currentImageView;
}

-(UIPageControl *)pageControl
{
    if (_pageControl == nil)
    {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, sh-30, sw, 30)];
        _pageControl.currentPage = 0;
        _pageControl.userInteractionEnabled = NO;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}
- (UILabel *)pageTitle
{
    if (_pageTitle == nil) {
        _pageTitle = [[UILabel alloc] initWithFrame:CGRectMake((sw-60)/2, sh-35, 60, 25)];
        _pageTitle.textAlignment = NSTextAlignmentCenter;
        _pageTitle.font = [UIFont systemFontOfSize:16];
        _pageTitle.font = [UIFont boldSystemFontOfSize:16];
        _pageTitle.textColor = [UIColor whiteColor];
        _pageTitle.backgroundColor = [UIColor lightGrayColor];
        _pageTitle.layer.cornerRadius = 12.5;
        _pageTitle.layer.masksToBounds = YES;
        _pageTitle.alpha = 0.9;
        [self addSubview:_pageTitle];
    }
    return _pageTitle;
}
@end

