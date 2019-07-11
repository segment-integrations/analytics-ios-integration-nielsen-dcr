//
//  SEGNielsenDCRIntegration.m
//  Pods
//
//  Created by ladan nasserian on 6/19/17.
//
//

#import "SEGNielsenDCRIntegration.h"
#import <Analytics/SEGAnalyticsUtils.h>
#import <NielsenAppApi/NielsenAppApi.h>

#pragma mark -
#pragma mark Property Conversion
#pragma mark -

NSString *returnFullEpisodeStatus(NSDictionary *src, NSString *key)
{
    NSNumber *value = [src valueForKey:key];
    if ([value isEqual:@YES]) {
        return @"y";
    }
    return @"n";
}


NSString *returnAdLoadType(NSDictionary *src, NSString *key)
{
    NSString *value = [src valueForKey:key];
    if ([value isEqualToString:@"dynamic"]) {
        return @"2";
    }
    return @"1";
}

NSString *returnHasAdsStatus(NSDictionary *src, NSString *key)
{
    NSString *value = [src valueForKey:key];
    if ([value isEqualToString:@YES]) {
        return @"1";
    }
    return @"0";
}

long long returnPlayheadPosition(SEGTrackPayload *payload)
{
    long long playheadPosition = 0;

    NSDictionary *properties = payload.properties;
    // if livestream, you need to send current UTC timestamp
    if ([properties[@"type"] isEqualToString:@"content"] && [properties[@"livestream"] isEqual:@YES]) {
        long long position = 0;
        position = [properties[@"position"] longLongValue];
        long long currentTime = [[NSDate date] timeIntervalSince1970];
        // for livestream, properties.position is a negative integer representing offset in seconds from current time
        playheadPosition = currentTime + position;
    } else if (properties[@"position"]) {
        // if position is passed in we should override the state of the counter with the explicit position given from the customer
        playheadPosition = [properties[@"position"] longLongValue];
    };

    return playheadPosition;
}

// Nielsen expects all value type String.
NSDictionary *coerceToString(NSDictionary *map)
{
    NSMutableDictionary *newMap = [NSMutableDictionary dictionaryWithDictionary:map];

    for (id key in map) {
        id value = [map objectForKey:key];
        if (![value isKindOfClass:[NSString class]]) {
            [newMap setObject:[NSString stringWithFormat:@"%@", value] forKey:key];
        }
    }

    return [newMap copy];
}

#pragma mark -
#pragma mark Metadata Mapping
#pragma mark -

NSDictionary *returnMappedContentProperties(NSDictionary *properties, NSDictionary *options)
{
    NSDictionary *contentMetadata = @{
        @"pipmode" : options[@"pipmode"] ?: @"false",
        @"adloadtype" : returnAdLoadType(options, @"adLoadType"),
        @"assetid" : properties[@"asset_id"] ?: @"",
        @"type" : @"content",
        @"segB" : options[@"segB"] ?: @"",
        @"segC" : options[@"segC"] ?: @"",
        @"title" : properties[@"title"] ?: @"",
        @"program" : properties[@"program"] ?: @"",
        @"isfullepisode" : returnFullEpisodeStatus(properties, @"full_episode"),
        @"hasAds" : returnHasAdsStatus(options, @"hasAds"),
        @"airdate" : properties[@"airdate"] ?: @"",
        @"length" : properties[@"total_length"] ?: @"",
        @"crossId1" : options[@"crossId1"] ?: @"",
        @"crossId2" : options[@"crossId2"] ?: @""
    };

    return coerceToString(contentMetadata);
}

NSDictionary *returnMappedAdProperties(NSDictionary *properties, NSDictionary *options)
{
    NSDictionary *adMetadata = @{
        @"assetid" : properties[@"asset_id"] ?: @"",
        @"type" : properties[@"type"] ?: @"",
        @"title" : properties[@"title"] ?: @""

    };
    return coerceToString(adMetadata);
}

// In case of ad type preroll, we need to map content metadata on ad events
NSDictionary *returnMappedAdContentProperties(NSDictionary *properties, NSDictionary *options)
{
    NSDictionary *adContentMetadata = @{
        @"assetid" : properties[@"content_asset_id"] ?: @"",
        @"pipmode" : options[@"pipmode"] ?: @"false",
        @"adloadtype" : returnAdLoadType(properties, @"load_type"),
        @"type" : @"content",
        @"segB" : options[@"segB"] ?: @"",
        @"segC" : options[@"segC"] ?: @"",
        @"title" : properties[@"title"] ?: @"",
        @"program" : properties[@"program"] ?: @"",
        @"isfullepisode" : returnFullEpisodeStatus(properties, @"full_episode"),
        @"hasAds" : returnHasAdsStatus(options, @"hasAds"),
        @"airdate" : properties[@"airdate"] ?: @"",
        @"length" : properties[@"total_length"] ?: @"",
        @"crossId1" : options[@"crossId1"] ?: @""
        @"crossId2" : options[@"crossId2"] ?: @""

    };
    return coerceToString(adContentMetadata);
}

#pragma mark - Integration


@interface SEGNielsenDCRIntegration () <NielsenAppApiDelegate>

@end


@implementation SEGNielsenDCRIntegration

- (instancetype)initWithSettings:(NSDictionary *)settings andNielsen:(NielsenAppApi *)nielsen
{
    if (self = [super init]) {
        self.settings = settings;
        self.nielsen = nielsen;

        NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
        NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        NSString *sfCode;

        if (settings[@"sfCode"]) {
            sfCode = @"dcr";
        } else {
            sfCode = @"dcr-cert";
        }

        NSMutableDictionary *appInformation = [[NSMutableDictionary alloc] initWithDictionary: @{
            @"appid" : settings[@"appId"] ?: @"",
            @"appname" : appName ?: @"",
            @"appversion" : appVersion ?: @"",
            @"sfcode" : sfCode
        }];

        if ([settings[@"nolDevDebug"] boolValue]) {
            [appInfo addEntriesFromDictionary:@{@"nol_devDebug": @"DEBUG"}];
        }

        if (nielsen == nil) {
            self.nielsen = [[NielsenAppApi alloc] initWithAppInfo:appInformation delegate:nil];
            SEGLog(@"[NielsenAppApi alloc] initWithAppInfo: %@ delegate:nil]", appInformation);
        }
    }

    return self;
}

#pragma mark -
#pragma mark Heartbeat Timers
#pragma mark -

- (void)playHeadTimeEvent:(NSTimer *)timer
{
    self.startingPlayheadPosition = self.startingPlayheadPosition + 1;

    [self.nielsen playheadPosition:self.startingPlayheadPosition];
    SEGLog(@"[NielsenAppApi playheadPosition: %d]", self.startingPlayheadPosition);
}


- (void)startPlayheadTimer:(SEGTrackPayload *)payload
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.playheadTimer == nil) {
            self.startingPlayheadPosition = returnPlayheadPosition(payload);
            self.playheadTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(playHeadTimeEvent:) userInfo:nil repeats:YES];
        }
    });
}

- (void)stopPlayheadTimer:(SEGTrackPayload *)payload
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.nielsen playheadPosition:self.startingPlayheadPosition];
        SEGLog(@"[NielsenAppApi playheadPosition: %d]", self.startingPlayheadPosition);

        if (self.playheadTimer) {
            [self.playheadTimer invalidate];
            self.playheadTimer = nil;
        }
    });
}

#pragma mark - Track

- (void)track:(SEGTrackPayload *)payload
{
    NSDictionary *properties = payload.properties;
    NSDictionary *options = [payload.integrations valueForKey:@"nielsen-dcr"];
#pragma mark Playback Events

    if ([payload.event isEqualToString:@"Video Playback Started"]) {
        NSDictionary *channelInfo = @{
            // channelName is optional for DCR, if not present Nielsen asks to set default
            @"channelName" : options[@"channel_name"] ?: @"defaultChannelName",
            // if mediaURL is not available, Nielsen expects an empty value
            @"mediaURL" : options[@"media_url"] ?: @""
        };


        [self.nielsen play:channelInfo];
        SEGLog(@"[NielsenAppApi play: %@]", channelInfo);
        return;
    }

    if ([payload.event isEqualToString:@"Video Playback Paused"]) {
        [self stopPlayheadTimer:payload];
        [self.nielsen stop];
        SEGLog(@"[NielsenAppApi stop]");
        return;
    }

    if ([payload.event isEqualToString:@"Video Playback Interrupted"]) {
        [self stopPlayheadTimer:payload];
        [self.nielsen stop];
        SEGLog(@"[NielsenAppApi stop]");
        return;
    }

    if ([payload.event isEqualToString:@"Video Playback Buffer Started"]) {
        [self stopPlayheadTimer:payload];
        return;
    }

    if ([payload.event isEqualToString:@"Video Playback Buffer Completed"]) {
        [self startPlayheadTimer:payload];
        return;
    }

    if ([payload.event isEqualToString:@"Video Playback Seek Completed"]) {
        [self startPlayheadTimer:payload];
        return;
    }

    if ([payload.event isEqualToString:@"Video Playback Resumed"]) {
        NSDictionary *channelInfo = @{
            // channelName is optional for DCR, if not present Nielsen asks to set default
            @"channelName" : options[@"channel_name"] ?: @"defaultChannelName",
            // if mediaURL is not available, Nielsen expects an empty value
            @"mediaURL" : options[@"media_url"] ?: @""
        };

        [self startPlayheadTimer:payload];
        [self.nielsen play:channelInfo];
        SEGLog(@"NielsenAppApi play: %@", channelInfo);
        return;
    }

    if ([payload.event isEqualToString:@"Video Playback Completed"]) {
        [self stopPlayheadTimer:payload];
        [self.nielsen end];
        SEGLog(@"[NielsenAppApi end]");
        return;
    }

#pragma mark - Content Events

    if ([payload.event isEqualToString:@"Video Content Started"]) {
        NSDictionary *contentMetadata = returnMappedContentProperties(properties, options);
        [self.nielsen loadMetadata:contentMetadata];
        SEGLog(@"[NielsenAppApi loadMetadata:%@]", contentMetadata);
        [self startPlayheadTimer:payload];
        return;
    }

    if ([payload.event isEqualToString:@"Video Content Playing"]) {
        [self startPlayheadTimer:payload];
        return;
    }

    if ([payload.event isEqualToString:@"Video Content Completed"]) {
        [self stopPlayheadTimer:payload];
        [self.nielsen end];
        return;
    }

#pragma mark - Ad Events

    if ([payload.event isEqualToString:@"Video Ad Started"]) {
        NSDictionary *adMetadata = returnMappedAdProperties(properties, options);

        // In case of ad `type` preroll, call `loadMetadata` with metadata values for content, followed by `loadMetadata` with ad (preroll) metadata
        if ([properties[@"type"] isEqualToString:@"pre-roll"]) {
            NSDictionary *adContentMetadata = returnMappedAdContentProperties(properties, options);
            [self.nielsen loadMetadata:adContentMetadata];
            SEGLog(@"[NielsenAppApi loadMetadata:%@]", adContentMetadata);
        }

        [self.nielsen loadMetadata:adMetadata];
        SEGLog(@"[NielsenAppApi loadMetadata:%@]", adMetadata);
        [self startPlayheadTimer:payload];
        return;
    }

    if ([payload.event isEqualToString:@"Video Ad Playing"]) {
        [self startPlayheadTimer:payload];
        return;
    }

    if ([payload.event isEqualToString:@"Video Ad Completed"]) {
        [self stopPlayheadTimer:payload];
        [self.nielsen stop];
        return;
    }
}


#pragma mark - Screen

- (void)screen:(SEGScreenPayload *)payload
{
    NSDictionary *options = [payload.integrations valueForKey:@"nielsen-dcr"];

    NSDictionary *metadata = @{
        @"type" : @"static",
        @"section" : payload.name ?: @"Unknown",
        @"segA" : options[@"segA"] ?: @"",
        @"segB" : options[@"segB"] ?: @"",
        @"segC" : options[@"segC"] ?: @"",
        @"crossId1" : options[@"crossId1"] ?: @""
    };
    [self.nielsen loadMetadata:metadata];
    SEGLog(@"[NielsenAppApi loadMetadata:%@]", metadata);
}

@end
