//
//  ZRMonitor.m
//  ZRMonitorMethodTime
//
//  Created by ZhouRui on 2023/12/7.
//

#import "ZRMonitor.h"
#import "BSBacktraceLogger.h"
#import "UIViewController+Common.h"

#define TimeTnterval 0.01  // s

@implementation ZRMonitorTimeModel
@end

@interface ZRMonitor()

@property (nonatomic,strong) dispatch_source_t monitorTimer;
@property (nonatomic,strong) NSMutableDictionary * callStackDict;

@end

@implementation ZRMonitor

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (void)start {
    self.monitorTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    self.callStackDict = [@{} mutableCopy];
    dispatch_source_set_timer(self.monitorTimer, dispatch_walltime(NULL, 0), TimeTnterval * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.monitorTimer, ^{
        NSDictionary *mainThreadCallStack = [BSBacktraceLogger bs_backtraceMapOfMainThread];
        for (NSString *methodAddr in mainThreadCallStack.allKeys) {
            NSString *methodName = [mainThreadCallStack objectForKey:methodAddr];
            ZRMonitorTimeModel *model = [self.callStackDict objectForKey:methodAddr];
            if (!model) {
                model = [ZRMonitorTimeModel new];
                model.methodName = methodName;
                model.methodAddress = methodAddr;
                model.consumeTime = TimeTnterval;
                [self.callStackDict setObject:model forKey:methodAddr];
            } else {
                model.consumeTime += TimeTnterval;
            }
        }
    });
    dispatch_resume(self.monitorTimer);
}

- (void)stop {
    dispatch_source_cancel(self.monitorTimer);
}

- (void)printCallStackAndMethodTime {
    NSMutableString *res = [@"" mutableCopy];
    for (NSString *key in self.callStackDict.allKeys) {
        ZRMonitorTimeModel *model = [self.callStackDict objectForKey:key];
        if (model.methodName && model.consumeTime > TimeTnterval){
            [res appendFormat:@"%@的耗时为：%0.2f \n\n\n", model.methodName, model.consumeTime];
        }
    }
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"主线程中所有的方法耗时(误差0.1s)：" message:[res copy] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:confirmAction];
    [[UIViewController currentViewController] presentViewController:alertVC animated:true completion:nil];
}

@end
