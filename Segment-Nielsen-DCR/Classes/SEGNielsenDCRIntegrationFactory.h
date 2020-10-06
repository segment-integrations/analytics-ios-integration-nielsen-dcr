//
//  SEGNielsenDCRIntegrationFactory.h
//  Segment-Nielsen-DCR
//
//  Created by ladan nasserian on 6/19/17.
//
//

#import <Foundation/Foundation.h>
#if defined(__has_include) && __has_include(<Analytics/Analytics.h>)
#import <Analytics/SEGIntegrationFactory.h>
#else
#import <Segment/SEGIntegrationFactory.h>
#endif

@interface SEGNielsenDCRIntegrationFactory : NSObject <SEGIntegrationFactory>

+ (instancetype)instance;

@end
