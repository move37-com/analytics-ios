//
//  SEGIntegrationsManager.h
//  Analytics
//
//  Created by Tony Xiao on 9/20/16.
//  Copyright © 2016 Segment. All rights reserved.
//

#import "SEGAnalyticsConfiguration.h"
#import "SEGCrypto.h"


#if TARGET_OS_OSX
@implementation NSApplication (SEGApplicationProtocol)

- (NSBackgroundTaskIdentifier)seg_beginBackgroundTaskWithName:(nullable NSString *)taskName expirationHandler:(void (^__nullable)(void))handler
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (handler)
        {
            handler();
        }
    });
    
    return 0;
}

- (void)seg_endBackgroundTask:(NSBackgroundTaskIdentifier)identifier
{}

@end

#else
@implementation UIApplication (SEGApplicationProtocol)

- (UIBackgroundTaskIdentifier)seg_beginBackgroundTaskWithName:(nullable NSString *)taskName expirationHandler:(void (^__nullable)(void))handler
{
    return [self beginBackgroundTaskWithName:taskName expirationHandler:handler];
}

- (void)seg_endBackgroundTask:(UIBackgroundTaskIdentifier)identifier
{
    [self endBackgroundTask:identifier];
}

@end

#endif

@interface SEGAnalyticsConfiguration ()

@property (nonatomic, copy, readwrite) NSString *writeKey;
@property (nonatomic, strong, readonly) NSMutableArray *factories;
@property (nonatomic, strong) SEGAnalyticsExperimental *experimental;

@end


@implementation SEGAnalyticsConfiguration

+ (instancetype)configurationWithWriteKey:(NSString *)writeKey
{
    return [[SEGAnalyticsConfiguration alloc] initWithWriteKey:writeKey];
}

- (instancetype)initWithWriteKey:(NSString *)writeKey
{
    if (self = [self init]) {
        self.writeKey = writeKey;
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.experimental = [[SEGAnalyticsExperimental alloc] init];
        self.shouldUseLocationServices = NO;
        self.enableAdvertisingTracking = YES;
        self.shouldUseBluetooth = NO;
        self.flushAt = 20;
        self.flushInterval = 30;
        self.maxQueueSize = 1000;
        self.payloadFilters = @{
            @"(fb\\d+://authorize#access_token=)([^ ]+)": @"$1((redacted/fb-auth-token))"
        };
        _factories = [NSMutableArray array];
        
#if TARGET_OS_OSX
        Class applicationClass = NSClassFromString(@"NSApplication");
#else
        Class applicationClass = NSClassFromString(@"UIApplication");
#endif

        if (applicationClass) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            _application = [applicationClass performSelector:NSSelectorFromString(@"sharedApplication")];
#pragma clang diagnostic pop
        }
    }
    return self;
}

- (void)use:(id<SEGIntegrationFactory>)factory
{
    [self.factories addObject:factory];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%p:%@, %@>", self, self.class, [self dictionaryWithValuesForKeys:@[ @"writeKey", @"shouldUseLocationServices", @"flushAt" ]]];
}

// MARK: remove these when `middlewares` property is removed.

- (void)setMiddlewares:(NSArray<id<SEGMiddleware>> *)middlewares
{
    self.sourceMiddleware = middlewares;
}

- (NSArray<id<SEGMiddleware>> *)middlewares
{
    return self.sourceMiddleware;
}

@end
