//
//  Segment-Nielsen-DCRTests.m
//  Segment-Nielsen-DCRTests
//
//  Created by ladanazita on 06/19/2017.
//  Copyright (c) 2017 ladanazita. All rights reserved.
//

// https://github.com/Specta/Specta

SpecBegin(InitialSpecs);

describe(@"SEGNielsenDCRIntegration", ^{
    __block __strong NielsenAppApi *mockNielsenAppApi;
    __block SEGNielsenDCRIntegration *integration;

    beforeEach(^{
        mockNielsenAppApi = mock([NielsenAppApi class]);

        NSDictionary *appInformation = @{
            @"appid" : @"TXXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
            @"appname" : @"Test",
            @"appversion" : @"0.1",
            @"sfcode" : @"dcr-cert"
        };


        [given([mockNielsenAppApi initWithAppInfo:appInformation delegate:nil]) willReturn:mockNielsenAppApi];

        integration = [[SEGNielsenDCRIntegration alloc] initWithSettings:@{
            @"appid" : @"TXXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
        } andNielsen:mockNielsenAppApi];

    });

    it(@"calls screen with default values", ^{
        SEGScreenPayload *payload = [[SEGScreenPayload alloc] initWithName:@"Main" properties:@{} context:@{} integrations:@{}];

        [integration screen:payload];

        [verify(mockNielsenAppApi) loadMetadata:@{
            @"type" : @"static",
            @"section" : @"Main",
            @"segA" : @"",
            @"segB" : @"",
            @"segC" : @"",
            @"crossId1" : @""

        }];
    });

    it(@"calls screen with integration specific options", ^{
        SEGScreenPayload *payload = [[SEGScreenPayload alloc] initWithName:@"Main" properties:@{} context:@{} integrations:@{
            @"nielsen-dcr" : @{
                @"segA" : @"segmentA",
                @"segB" : @"segmentB",
                @"segC" : @"segmentC",
                @"crossId1" : @"crossIdValue"
            }
        }];
        [integration screen:payload];

        [verify(mockNielsenAppApi) loadMetadata:@{
            @"type" : @"static",
            @"section" : @"Main",
            @"segA" : @"segmentA",
            @"segB" : @"segmentB",
            @"segC" : @"segmentC",
            @"crossId1" : @"crossIdValue"

        }];
    });

    it(@"tracks Video Playback Started", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"Video Playback Started" properties:@{
            @"content_asset_id" : @"1234",
            @"ad_type" : @"pre-roll",
            @"video_player" : @"youtube",
            @"position" : @1
        } context:@{}
            integrations:@{}];


        [integration track:payload];

        [verify(mockNielsenAppApi) play:@{
            @"channelName" : @"defaultChannelName",
            @"mediaURL" : @""
        }];
    });

    it(@"tracks Video Playback Paused", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"Video Playback Paused" properties:@{
            @"content_asset_id" : @"7890",
            @"ad_type" : @"mid-roll",
            @"video_player" : @"vimeo",
            @"position" : @30,
            @"sound" : @100,
            @"full_screen" : @YES,
            @"bitrate" : @50
        }
            context:@{}
            integrations:@{}];
        [integration track:payload];
        [verify(mockNielsenAppApi) stop];
    });

    it(@"tracks Video Playback Interrupted", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"Video Playback Interrupted" properties:@{
            @"content_asset_id" : @"7890",
            @"ad_type" : @"mid-roll",
            @"video_player" : @"vimeo",
            @"position" : @30,
            @"sound" : @100,
            @"full_screen" : @YES,
            @"bitrate" : @50
        }
            context:@{}
            integrations:@{}];

        [integration track:payload];
        [verify(mockNielsenAppApi) stop];
    });

    it(@"tracks Video Playback Completed", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"Video Playback Completed" properties:@{
            @"content_asset_id" : @"7890",
            @"ad_type" : @"mid-roll",
            @"video_player" : @"vimeo",
            @"position" : @30,
            @"sound" : @100,
            @"full_screen" : @YES,
            @"bitrate" : @50
        }
            context:@{}
            integrations:@{}];

        [integration track:payload];
        [(NielsenAppApi *)verify(mockNielsenAppApi) end];
    });

    it(@"tracks Video Content Started", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"Video Content Started" properties:@{
            @"asset_id" : @"3543",
            @"pod_id" : @"65462",
            @"title" : @"Big Trouble in Little Sanchez",
            @"season" : @"2",
            @"episode" : @"7",
            @"genre" : @"cartoon",
            @"program" : @"Rick and Morty",
            @"total_length" : @400,
            @"full_episode" : @YES,
            @"publisher" : @"Turner Broadcasting Network",
            @"position" : @22,
            @"channel" : @"Cartoon Network"
        } context:@{}
            integrations:@{}];
        [integration track:payload];
        [verify(mockNielsenAppApi) loadMetadata:@{
            @"pipmode" : @"false",
            @"adloadtype" : @"1",
            @"assetid" : @"3543",
            @"type" : @"content",
            @"segB" : @"cartoon",
            @"segC" : @"cartoon",
            @"title" : @"Big Trouble in Little Sanchez",
            @"program" : @"Rick and Morty",
            @"isfullepisode" : @"y",
            @"airdate" : @"",
            @"length" : @"400",
            @"airdate" : @""
        }];
    });

    it(@"tracks Video Content Completed", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"Video Content Completed" properties:@{
            @"asset_id" : @"3543",
            @"pod_id" : @"65462",
            @"title" : @"Big Trouble in Little Sanchez",
            @"season" : @"2",
            @"episode" : @"7",
            @"genre" : @"cartoon",
            @"program" : @"Rick and Morty",
            @"total_length" : @400,
            @"full_episode" : @"true",
            @"publisher" : @"Turner Broadcasting Network",
            @"channel" : @"Cartoon Network",
            @"position" : @100
        } context:@{}
            integrations:@{}];

        [integration track:payload];
        [(NielsenAppApi *)verify(mockNielsenAppApi) end];
    });

    it(@"tracks Video Ad Started", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"Video Ad Started"
            properties:@{
                @"asset_id" : @"1231312",
                @"pod_id" : @"43434234534",
                @"type" : @"mid-roll",
                @"total_length" : @110,
                @"position" : @43,
                @"publisher" : @"Adult Swim",
                @"title" : @"Rick and Morty Ad"
            }
            context:@{}
            integrations:@{}];

        [integration track:payload];
        [verify(mockNielsenAppApi) loadMetadata:@{
            @"assetid" : @"1231312",
            @"type" : @"mid-roll",
            @"title" : @"Rick and Morty Ad"
        }];
    });

    it(@"tracks preroll Video Ad Started", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"Video Ad Started"
            properties:@{
                @"content_asset_id" : @"934",
                @"asset_id" : @"1231312",
                @"pod_id" : @"43434234534",
                @"type" : @"pre-roll",
                @"total_length" : @110,
                @"position" : @43,
                @"publisher" : @"Adult Swim",
                @"title" : @"Rick and Morty Ad"
            }
            context:@{}
            integrations:@{}];

        [integration track:payload];
        [verify(mockNielsenAppApi) loadMetadata:@{
            @"type" : @"content",
            @"title" : @"Rick and Morty Ad",
            @"assetid" : @"934",
            @"pipmode" : @"false",
            @"adloadtype" : @"1",
            @"type" : @"content",
            @"segB" : @"",
            @"segC" : @"",
            @"title" : @"",
            @"program" : @"",
            @"isfullepisode" : @"sf",
            @"airdate" : @"",
            @"length" : @"110"
        }];

        [verify(mockNielsenAppApi) loadMetadata:@{
            @"assetid" : @"1231312",
            @"type" : @"pre-roll",
            @"title" : @"Rick and Morty Ad"
        }];
    });

    it(@"tracks Video Ad Completed", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"Video Ad Completed" properties:@{
            @"asset_id" : @"1231312",
            @"pod_id" : @"43434234534",
            @"type" : @"mid-roll",
            @"total_length" : @110,
            @"position" : @110,
            @"title" : @"Rick and Morty Ad"

        } context:@{}
            integrations:@{}];

        [integration track:payload];
        [verify(mockNielsenAppApi) stop];
    });


});


SpecEnd
