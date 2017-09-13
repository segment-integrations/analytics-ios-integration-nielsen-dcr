//
//  SEGNielsenDCRIntegrationFactory.m
//  Segment-Nielsen-DCR
//
//  Created by ladan nasserian on 6/19/17.
//
//

#import "SEGNielsenDCRIntegration.h"
#import "SEGNielsenDCRIntegrationFactory.h"


@implementation SEGNielsenDCRIntegrationFactory

+ (instancetype)instance
{
    static dispatch_once_t once;
    static SEGNielsenDCRIntegrationFactory *sharedInstance;

    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    return self;
}

- (id<SEGIntegration>)createWithSettings:(NSDictionary *)settings forAnalytics:(SEGAnalytics *)analytics
{
    return [[SEGNielsenDCRIntegration alloc] initWithSettings:settings andNielsen:nil];
}

- (NSString *)key
{
    return @"Nielsen DCR";
}

@end
