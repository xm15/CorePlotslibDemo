//
//  ViewController.m
//  PlotsX
//
//  Created by xm15 on 14/12/15.
//  Copyright (c) 2014年 xm15. All rights reserved.
//

#import "ViewController.h"
#import "KSViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    KSViewController *ksViewController =[[KSViewController alloc]init];
    [self.view addSubview:ksViewController.view];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
