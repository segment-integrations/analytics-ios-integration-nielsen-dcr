//
//  SEGNielsenDCRIntegration.h
//  Segment-Nielsen-DCR
//
//  Created by ladan nasserian on 7/19/17.
//

#import <Foundation/Foundation.h>
#if defined(__has_include) && __has_include(<Analytics/Analytics.h>)
#import <Analytics/SEGIntegration.h>
#else
#import <Segment/SEGIntegration.h>
#endif
#import <NielsenAppApi/NielsenAppApi.h>


@interface SEGNielsenDCRIntegration : NSObject <SEGIntegration>

@property (nonatomic, strong) NSDictionary *settings;
@property (nonatomic, strong) NielsenAppApi *nielsen;
@property (nonatomic, strong) NSTimer *playheadTimer;
@property (nonatomic, assign) long long startingPlayheadPosition;


- (instancetype)initWithSettings:(NSDictionary *)settings andNielsen:(NielsenAppApi *)nielsen;
- (NSString *)optOutURL;
- (void)userOptOutStatus:(NSString *)urlString;

@end
