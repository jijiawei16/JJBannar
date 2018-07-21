//
//  ViewController.m
//  JJBanar
//
//  Created by 16 on 2018/7/22.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import "ViewController.h"
#import "JJBanar.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSMutableArray *subs1 = [NSMutableArray array];
    for (NSInteger i = 0; i<3; i++) {
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
        back.backgroundColor = [UIColor colorWithRed:i*0.3 green:i*0.3 blue:i*0.3 alpha:1];
        
        UIView *top = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        top.backgroundColor = [UIColor redColor];
        
        UILabel *bottom = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 100, 50)];
        bottom.text = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld%ld%ld%ld",(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i];
        [back addSubview:top];
        [back addSubview:bottom];
        [subs1 addObject:back];
    }
    
    JJBannar *bannar = [[JJBannar alloc] initWithFrame:CGRectMake(50, 30, 300, 150) direction:JJBannarViewDirectionUp interval:2.0 click:^(NSInteger num, NSArray *items) {
        NSLog(@"%ld====%@",num,items);
    }];
    [bannar setUpItems:subs1];
    [bannar setPageStyle:JJBannarViewPageStyleTitle];
    [self.view addSubview:bannar];
    
    JJBannar *bannar1 = [[JJBannar alloc] initWithFrame:CGRectMake(50, 210, 300, 150) direction:JJBannarViewDirectionLeft interval:2.0 click:^(NSInteger num, NSArray *items) {
        NSLog(@"%ld====%@",num,items);
    }];
    [bannar1 setUpImgs:@[@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3461573980,2214527686&fm=27&gp=0.jpg",@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=694186767,873005154&fm=27&gp=0.jpg",@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1228123882,4198563929&fm=27&gp=0.jpg"]];
    
    [self.view addSubview:bannar1];
    
    JJBannar *bannar2 = [[JJBannar alloc] initWithFrame:CGRectMake(50, 390, 300, 150) direction:JJBannarViewDirectionDown interval:2.0 click:^(NSInteger num, NSArray *items) {
        NSLog(@"%ld====%@",num,items);
    }];
    [bannar2 setUpImgs:@[@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3461573980,2214527686&fm=27&gp=0.jpg",@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=694186767,873005154&fm=27&gp=0.jpg",@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1228123882,4198563929&fm=27&gp=0.jpg"]];
    [bannar2 setPageStyle:JJBannarViewPageStyleTitle];
    [self.view addSubview:bannar2];
    
    
    NSMutableArray *subs2 = [NSMutableArray array];
    for (NSInteger i = 0; i<3; i++) {
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
        back.backgroundColor = [UIColor colorWithRed:i*0.3 green:i*0.3 blue:i*0.3 alpha:1];
        
        UIView *top = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        top.backgroundColor = [UIColor redColor];
        
        UILabel *bottom = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 100, 50)];
        bottom.text = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld%ld%ld%ld",(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i];
        [back addSubview:top];
        [back addSubview:bottom];
        [subs2 addObject:back];
    }
    
    JJBannar *bannar3 = [[JJBannar alloc] initWithFrame:CGRectMake(50, 570, 300, 150) direction:JJBannarViewDirectionRight interval:2.0 click:^(NSInteger num, NSArray *items) {
        NSLog(@"%ld====%@",num,items);
    }];
    [bannar3 setUpItems:subs2];
    [self.view addSubview:bannar3];
}

@end
