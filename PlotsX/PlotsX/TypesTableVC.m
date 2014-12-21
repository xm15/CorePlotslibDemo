//
//  TypesTableVC.m
//  ADSampleV1.0.4
//
//  Created by xm15 on 14-3-21.
//  Copyright (c) 2014年 xm15. All rights reserved.
//

#import "TypesTableVC.h"
//#import "DetailVC.h"

#import "KSViewController.h"
#import "PieChartController.h"
#import "BarChartController.h"
#import "ScatterPlotController.h"

@interface TypesTableVC ()

@end

@implementation TypesTableVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[[UIView alloc]initWithFrame:CGRectZero]autorelease];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [infoButton addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[[UIBarButtonItem alloc]initWithCustomView:infoButton]autorelease];
    [self.navigationItem setRightBarButtonItem:item];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)showInfo
{
//    DetailVC *detail = [[DetailVC alloc]init];
//    [self.navigationController pushViewController:detail animated:YES];
//    [detail release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseCellIdentifier"];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseCellIdentifier"]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"曲线";
            break;
        case 1:
            cell.textLabel.text = @"柱状";
            break;
        case 2:
            cell.textLabel.text = @"饼状";
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *pushVC = nil;
    switch (indexPath.row) {
        case 0:
            pushVC = [[KSViewController alloc]init];
            break;
        case 1:
            pushVC = [[BarChartController alloc]init];
            break;
        case 2:
            pushVC = [[PieChartController alloc]init];
            break;
        
        default:
            break;
    }
    if (pushVC) {
        [self.navigationController pushViewController:pushVC animated:YES];
        [pushVC release];
    }

}



@end
