//
//  ViewController.m
//  Pthread
//
//  Created by 曾宪杰 on 2018/11/6.
//  Copyright © 2018 zengxianjie. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>
#import "YYDispatchQueuePool.h"

static inline dispatch_queue_t xjGCD() {
    return YYDispatchQueueGetForQOS(NSQualityOfServiceDefault);
}

@interface ViewController ()

@end

@implementation ViewController
{
    pthread_mutex_t _lock;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    __unused NSError *error = nil;

    YYDispatchQueuePool *pro = [YYDispatchQueuePool defaultPoolForQOS:NSQualityOfServiceUtility];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    //queue = pro.queue
    dispatch_queue_t queue = xjGCD();
#pragma clang diagnostic pop
    dispatch_async(xjGCD(), ^{
        NSLog(@"hello %@\n %@\n",[NSThread currentThread],pro.name);
    });
    
    
    [self pthread];
    
    
    

}


#pragma mark - lock
- (void)lock {
    pthread_mutex_lock(&_lock);
    //...
    pthread_mutex_unlock(&_lock);
}

#pragma mark - pthread
- (void)pthread {
    pthread_t threadID = NULL;
    NSString *str = @"abc";

    int result = pthread_create(&threadID, NULL, doThread, (__bridge void *)(str));

    if (result == 0) {
        NSLog(@"result ok");
    } else {
        NSLog(@"result no");
    }

    pthread_detach(threadID);
}

void *doThread(void *params) {
    NSString *str = (__bridge NSString *)(params);
   
    NSLog(@"thread is %@\n str is %@\n",[NSThread currentThread],str);
    return NULL;
}


@end


