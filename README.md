*** NOTICE *** PROJECT IS CURRENTLY WORK IN PROGRESS ***
Any questions/comments please send them to yin@gfycat.com

# GfycatApiKit

## Installation

### Using CocoaPods

*GfycatApiKit* can be installed using [CocoaPods](https://cocoapods.org)
package manager. To do so, please add corresponding reference in your `Podfile`:

```ruby
pod 'GfycatApiKit'
```

Then run `pod install` to update CocoaPods installation in the project:

```sh
$ pod install
```

Please refer to [CocoaPods documentation](https://guides.cocoapods.org/using/using-cocoapods.html) for more details.

### Update Info.plist

The Gfycat API is accessible ***only*** when you provide `GfycatApiClientId` and `GfycatApiClientSecret`.
Get them for ***free*** on the [API Keys Management](https://developers.gfycat.com/signup/#/keys) page.
You need to have or create a Gfycat account and log in with those credentials to manage your keys.

Once you get those, update your `Info.plist` file accordingly.

```xml
<key>GfycatApiClientId</key>
<string>Your API Client ID goes here</string>
<key>GfycatApiClientSecret</key>
<string>Your API Client Secret goes here</string>
```

### Analytics

The Gfycat server API endpoint ***requires*** view impressions and share event analytics to be reported.

You can report view impressions like this:

```objective-c
[GfycatEventTracker.impressionsTracker trackEvent:@"video_played" withParameters:@{
    @"gfyid": @"candidimmaterialdromedary",
    @"context": @"search",
    @"keyword": @"example_keyword",
    @"flow": @"full",
    @"viewtag": @"example_tag",
}];
```

And share events like this:

```objective-c
[GfycatEventTracker.analyticsTracker trackEvent:@"send_video" withParameters:@{
    @"gfyid": @"candidimmaterialdromedary",
}];
```

Please refer to the [Gfycat Analytics documentation](https://developers.gfycat.com/analytics/#gfycat-analytics) for more details on events and parameters. 
