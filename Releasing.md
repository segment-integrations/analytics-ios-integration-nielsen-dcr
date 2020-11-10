Releasing
=========

 1. Update the version in `Segment-Nielsen-DCR.podspec` to the latest version.
 2. Update the `CHANGELOG.md` for the impending release.
 3. `git commit -am "Prepare for release X.Y.Z."` (where X.Y.Z is the new version).
 4. `git tag -a X.Y.Z -m "Version X.Y.Z"` (where X.Y.Z is the new version).
 5. `git push && git push --tags`.
 6. `pod trunk push Segment-Nielsen-DCR.podspec --use-libraries --sources=https://cdn.cocoapods.org,https://github.com/NielsenDigitalSDK/nielsenappsdk-ios-specs-dynamic.git`.

NOTE: The addition of the --sources flag above is required since Nielsen's SDK is private.