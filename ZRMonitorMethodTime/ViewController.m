//
//  ViewController.m
//  ZRMonitorMethodTime
//
//  Created by ZhouRui on 2023/12/7.
//

#import "ViewController.h"
#import "ZRMonitor.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[ZRMonitor sharedInstance] start];
}

- (void)viewDidAppear:(BOOL)animated {
    [self test];
    [self print];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[ZRMonitor sharedInstance] stop];
}

- (void)print {
    [[ZRMonitor sharedInstance] printCallStackAndMethodTime];
}

- (void)test {
    sleep(2);
}


@end
