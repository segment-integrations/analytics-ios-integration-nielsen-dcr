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


NSString *returnAdLoadType(NSDictionary *options, NSDictionary *properties)
{
    NSString *value;
    if ([options valueForKey:@"adLoadType"]){
        value = [options valueForKey:@"adLoadType"];
    } else if ([properties valueForKey:@"loadType"]){
        value = [properties valueForKey:@"loadType"];
    } else if ([properties valueForKey:@"load_type"]){
        value = [properties valueForKey:@"load_type"];
    }
    
    if ([value isEqualToString:@"dynamic"]) {
        return @"2";
    }
    return @"1";
}

NSString *returnHasAdsStatus(NSDictionary *src, NSString *key)
{
    NSNumber *value = [src valueForKey:key];
    if ([value isEqual:@YES]) {
        return @"1";
    }
    return @"0";
}

NSString *returnContentLength(NSDictionary *src, NSString *defaultKey, NSDictionary *settings)
{
    NSString *contentLengthKey = settings[@"contentLengthPropertyName"];
    NSString *contentLength;
    NSString *customContentLength = src[contentLengthKey];
    if ([contentLengthKey length] > 0 && customContentLength) {
        contentLength = [src valueForKey:contentLengthKey];
    } else if (src[@"total_length"]) {
       contentLength = [src valueForKey:@"total_length"];
    } else {
        contentLength = @"";
    }
    
    return contentLength;
}

NSString *returnCustomContentAssetId(NSDictionary *properties, NSString *defaultKey, NSDictionary *settings)
{
    NSString *customKey = settings[@"contentAssetIdPropertyName"];
    NSString *value;
    NSString *customContentAssetId = properties[customKey];
    if ([customKey length] > 0 && customContentAssetId){
        value = [properties valueForKey:customKey];
    } else if (properties[defaultKey]) {
        value = [properties valueForKey:defaultKey];
    } else {
        value = @"";
    }
    return value;
}

NSString *returnCustomAdAssetId(NSDictionary *properties, NSString *defaultKey, NSDictionary *settings)
{
    NSString *customKey = settings[@"adAssetIdPropertyName"];
    NSString *value;
    NSString *customAssetId = properties[customKey];
    if ([customKey length] > 0 && customAssetId){
        value = [properties valueForKey:customKey];
    } else if (properties[defaultKey])  {
        value = [properties valueForKey:defaultKey];
    } else {
        value = @"";
    }
    return value;
}

NSString *returnAirdate(NSDictionary *properties, NSString *defaultKey)
{
        NSString *dateSTR = [properties valueForKey:defaultKey];
        NSArray *dateArrayISO = [dateSTR componentsSeparatedByString:@"T"];
        NSArray *dateArraySimpleDate = [dateSTR componentsSeparatedByString:@"-"];
        NSDate *date;
        //Convert the string date if it was passed in ISO 8601 format ie. 2019-08-30T21:00:00Z
        if ([dateArrayISO count] > 1) {
            NSISO8601DateFormatter *ISODateFormatter = [[NSISO8601DateFormatter alloc] init];
            date = [ISODateFormatter dateFromString:dateSTR];
        }
    
        //Convert the string date if it was passed in simple date format ie. 2019-08-30
        if ([dateArraySimpleDate count] > 2 && [dateSTR length] == 10) {
            NSDateFormatter *simpleDateFormatter = [[NSDateFormatter alloc] init];
            [simpleDateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
            [simpleDateFormatter setTimeZone:timeZone];
            date = [simpleDateFormatter dateFromString:dateSTR];
        }
    
        //Manipulate the date to Nielsen format
        NSDateFormatter *nielsenDateFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [nielsenDateFormatter setTimeZone:timeZone];
        [nielsenDateFormatter setDateFormat:@"yyyyMMdd HH:mm:ss"];
        NSString *nielsenDateString = [nielsenDateFormatter stringFromDate:date];
    
        if ([nielsenDateString length] > 0) {
            return nielsenDateString;
        } else if ([dateSTR length] > 0) {
            return dateSTR;
        } else {
            return @"";
        }
}

long long returnPlayheadPosition(SEGTrackPayload *payload)
{
    long long playheadPosition = 0;

    NSDictionary *properties = payload.properties;
    // if livestream, you need to send current UTC timestamp
    if ([properties[@"livestream"] isEqual:@YES]) {
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

NSDictionary *returnMappedContentProperties(NSDictionary *properties, NSDictionary *options, NSDictionary *settings)
{
    NSDictionary *contentMetadata = @{
        @"pipmode" : options[@"pipmode"] ?: @"false",
        @"adloadtype" : returnAdLoadType(options, properties),
        @"assetid" : returnCustomContentAssetId(properties, @"asset_id", settings),
        @"type" : @"content",
        @"segB" : options[@"segB"] ?: @"",
        @"segC" : options[@"segC"] ?: @"",
        @"title" : properties[@"title"] ?: @"",
        @"program" : properties[@"program"] ?: @"",
        @"isfullepisode" : returnFullEpisodeStatus(properties, @"full_episode"),
        @"hasAds" : returnHasAdsStatus(options, @"hasAds"),
        @"airdate" : returnAirdate(properties, @"airdate"),
        @"length" : returnContentLength(properties, @"content_length", settings),
        @"crossId1" : options[@"crossId1"] ?: @"",
        @"crossId2" : options[@"crossId2"] ?: @""
    };

    NSMutableDictionary *mutableContentMetadata = [contentMetadata mutableCopy];
    if (settings[@"subbrandPropertyName"]){
        NSString *subbrandValue = properties[settings[@"subbrandPropertyName"]] ?: @"";
        [mutableContentMetadata setObject:subbrandValue forKey:@"subbrand"];
    }

    if (settings[@"clientIdPropertyName"]){
        NSString *clientIdValue = properties[settings[@"clientIdPropertyName"]] ?: @"";
        [mutableContentMetadata setObject:clientIdValue forKey:@"clientid"];
    }

    return coerceToString(mutableContentMetadata);
}

NSDictionary *returnMappedAdProperties(NSDictionary *properties, NSDictionary *options, NSDictionary *settings)
{
    NSDictionary *adMetadata = @{
        @"assetid" : returnCustomAdAssetId(properties, @"asset_id", settings),
        @"type" : properties[@"type"] ?: @"ad",
        @"title" : properties[@"title"] ?: @""

    };
    
    NSMutableDictionary *mutableAdMetadata = [adMetadata mutableCopy];

    if ([properties[@"type"] isEqualToString:@"pre-roll"]) {
        [mutableAdMetadata setObject:@"preroll" forKey:@"type"];
    }
    
    if ([properties[@"type"] isEqualToString:@"mid-roll"]) {
        [mutableAdMetadata setObject:@"midroll" forKey:@"type"];
    }
    
    if ([properties[@"type"] isEqualToString:@"post-roll"]) {
        [mutableAdMetadata setObject:@"postroll" forKey:@"type"];
    }
    
    return coerceToString(mutableAdMetadata);
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
            [appInformation addEntriesFromDictionary:@{@"nol_devDebug": @"DEBUG"}];
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
            @"channelName" : options[@"channelName"] ?: @"defaultChannelName",
            // if mediaURL is not available, Nielsen expects an empty value
            @"mediaURL" : options[@"mediaUrl"] ?: @""
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
            @"channelName" : options[@"channelName"] ?: @"defaultChannelName",
            // if mediaURL is not available, Nielsen expects an empty value
            @"mediaURL" : options[@"mediaUrl"] ?: @""
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
        NSDictionary *contentMetadata = returnMappedContentProperties(properties, options, self.settings);
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
        [self.nielsen stop];
        return;
    }

#pragma mark - Ad Events

    if ([payload.event isEqualToString:@"Video Ad Started"]) {
        NSDictionary *adMetadata = returnMappedAdProperties(properties, options, self.settings);

        // In case of ad `type` preroll, call `loadMetadata` with metadata values for content, followed by `loadMetadata` with ad (preroll) metadata
        if ([properties[@"type"] isEqualToString:@"pre-roll"]) {
            NSDictionary *contentProperties = [properties valueForKey:@"content"];
            NSDictionary *adContentMetadata = returnMappedContentProperties(contentProperties, options, self.settings);
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

/**
 @return Opt-out URL string from the Nielsen App API to display in a web view.
 */
-(NSString *)optOutURL
{
    return [self.nielsen optOutURL];
}

/**
 @param urlString URL string from user's action to denote opt-out status for the Nielsen App API. Should be one of `nielsenappsdk://1` or `nielsenappsdk://0` for opt-out and opt-in, respectively
 @seealso https://engineeringportal.nielsen.com/docs/DTVR_iOS_SDK#The_legacy_opt-out_method_works_as_follows:
 */
-(void)userOptOutStatus:(NSString *)urlString
{
    [self.nielsen userOptOut:urlString];
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
