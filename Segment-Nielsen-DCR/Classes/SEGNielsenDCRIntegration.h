//
//  SEGNielsenDCRIntegration.h
//  Segment-Nielsen-DCR
//
//  Created by ladan nasserian on 7/19/17.
//

#import <Foundation/Foundation.h>
#import <Analytics/SEGIntegration.h>
#import <NielsenAppApi/NielsenAppApi.h>

@interface SEGNielsenDCRIntegration : NSObject <SEGIntegration>

@property (nonatomic, strong) NSDictionary *settings;
@property (nonatomic, strong) NielsenAppApi *nielsen;
@property (nonatomic, strong) NSTimer *playheadTimer;
@property (nonatomic, assign) long long startingPlayheadPosition;


- (instancetype)initWithSettings:(NSDictionary *)settings andNielsen:(NielsenAppApi *)nielsen;

@end

