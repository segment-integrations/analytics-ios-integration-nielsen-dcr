Releasing
========

 1. Update the version in `Segment-Nielsen-DCR.podspec` to the latest version.
 2. Update the `CHANGELOG.md` for the impending release.
 3. Update the `README.me` for the impending release.  Version # tag in installation line.
 3. `git commit -am "Prepare for release X.Y.Z."` (where X.Y.Z is the new version).
 4. `git tag -a X.Y.Z -m "Version X.Y.Z"` (where X.Y.Z is the new version).
 5. `git push && git push --tags`.
 
 This pod cannot be pushed to trunk.
