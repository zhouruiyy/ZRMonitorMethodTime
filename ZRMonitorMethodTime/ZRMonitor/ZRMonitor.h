//
//  ZRMonitor.h
//  ZRMonitorMethodTime
//
//  Created by ZhouRui on 2023/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZRMonitorTimeModel : NSObject
@property (nonatomic, copy) NSString * methodName;
@property (nonatomic, copy) NSString * methodAddress;
@property (nonatomic, assign) CGFloat consumeTime;
@end


@interface ZRMonitor : NSObject

+ (instancetype)sharedInstance;

- (void)start;
- (void)stop;

- (void)printCallStackAndMethodTime;

@end

NS_ASSUME_NONNULL_END
