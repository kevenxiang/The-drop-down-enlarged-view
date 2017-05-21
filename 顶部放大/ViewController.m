//
//  ViewController.m
//  顶部放大
//
//  Created by xiang on 2017/5/21.
//  Copyright © 2017年 xiang. All rights reserved.
//

#import "ViewController.h"
#import "CZHeaderViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickButton:(id)sender {
    CZHeaderViewController *vc = [[CZHeaderViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
