Change Log
==========

Version 1.3.2 *(21st June, 2020)*
-------------------------------------------
* Relaxes Segment Analytics library dependency.

Version 1.3.1 *(19th May, 2020)*
-------------------------------------------
* Updates `returnPlayheadPosition` to set the `playheadPosition` to the  `currentTime` when the new setting `sendCurrentTimeLivestream` is enabled on livestream videos.

Version 1.3.0 *(18th October, 2019)*
-------------------------------------------
* [DEST-1241]
* Supports playback events "Video Playback Seek Started", "Video Playback   Buffer Started" and "Video Playback Buffer Completed".
* sfCode setting hard-coded to "dcr" per Nielsen request.
* Timer supports livestream offset as value of "position" property.

Version 1.2.8 *(17th September, 2019)*
-------------------------------------------
* Updates `returnAdLoadType` helper method to check for a load type in `properties.load_type`.

Version 1.2.7 *(9th September, 2019)*
-------------------------------------------
* Updates `returnAdLoadType` helper method to check for a load type in `properties.loadType`. Will fallback to `adLoadType` in integrations specific options.

Version 1.2.6 *(30th August, 2019)*
-------------------------------------------
* Adds a helper functions `returnAirdate` that will convert a date passed in ISO 8601 format or in format 2019-30-08 to Nielsen yyyyMMdd HH:MM:SS `airdate` format.
* Removes hyphens for ad `type` of "post-roll" and "mid-roll"

Version 1.2.5 *(14th August, 2019)*
-------------------------------------------
* Fixes a bug in helper functions setting nil values in contentMetadata.
* Adds support for retrieving `optOutURL`.

Version 1.2.4 *(5th August, 2019)*
-------------------------------------------
* Fixes a bug with `content_length` helper function
* Updates pre-roll ad loadMetadata. Previously we were retrieving properties for content on  pre-roll ads from `properties.content` to adhere to the Segment video spec.

Version 1.2.3 *(25th July, 2019)*
-------------------------------------------
* Adds support for Nielsen's ad `assetId` to be  assigned using the setting: `adAssetIdPropertyName` and custom property mapping.
* Changes naming convention of `assetIdPropertyName` to `contentAssetIdPropertyName` for custom content assetId mapping.

Version 1.2.2 *(25th July, 2019)*
-------------------------------------------
* Fixes param values passed to `returnContentLength`.

Version 1.2.1 *(19th July, 2019)*
-------------------------------------------
* Adds functionality support setting custom length property ("contentLengthPropertyName") in Segment UI. This is mapped to Nielsen's length. If a property is not provided in the settings, Segment will default to Segment specced property, `total_length`.

Version 1.2.0 *(17th July, 2019)*
-------------------------------------------
* Adds functionality support setting custom assetid ("assetIdPropertyName") in Segment UI. This is used to override default property mapping for Segment property 'asset_id' to Nielsen 'assetid' when present.
* Adds functionality support setting custom clientid ("clientIdPropertyName") in Segment UI. This is used to override the 'cid'/'clientid' value sent to Nielsen in 'loadMetadata()' events.
* Adds functionality support setting custom subbrand ("subbrandPropertyName") in Segment UI. This is used to override the 'vcid'/'subbrand' value sent to Nielsen in 'loadMetadata()' events.

Version 1.1.2 *(16th July, 2019)*
-------------------------------------------
* Fix syntax errors of Content Metadata and AppInformation.

Version 1.1.1 *(15th July, 2019)*
-------------------------------------------
* Fix casing of mediaUrl and channelName to have  parity with Android.

Version 1.1.0 *(11th July, 2019)*
-------------------------------------------
* Add debug flag/setting
* Migrates from travis to CircleCI
* Updates build and Readme per SDK bundling
* Adds `hasAds` and `crossId2` to content metadata

Version 1.0.0-beta *(13th September, 2017)*
-------------------------------------------
*(Supports analytics-ios 3.6.+ and Nielsen-DCR 5.1.1.25+)*

Initial release.
