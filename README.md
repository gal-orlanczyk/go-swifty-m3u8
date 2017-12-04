
 [![Build Status](https://travis-ci.org/gal-orlanczyk/go-swifty-m3u8.svg?branch=master)](https://travis-ci.org/gal-orlanczyk/go-swifty-m3u8.svg?branch=master)
[![badge-language](https://img.shields.io/badge/Swift-4-orange.svg?style=flat)](swift.org)
[![badge-platforms](https://img.shields.io/badge/Platforms-macOS%20%7C%20iOS%20%7C%20tvOS-lightgray.svg?style=flat)](swift.org)
[![badge-license](https://img.shields.io/badge/License-MIT-lightgrey.svg?style=flat)](https://github.com/gal-orlanczyk/go-swifty-m3u8/blob/master/LICENSE)
[![badge-cocoapods](https://img.shields.io/cocoapods/v/GoSwiftyM3U8.svg?style=flat)](https://cocoapods.org/pods/GoSwiftyM3U8)
[![badge-documentation](https://gal-orlanczyk.github.io/go-swifty-m3u8/API/badge.svg)](https://gal-orlanczyk.github.io/go-swifty-m3u8/API)

# GoSwiftyM3U8
M3U8 Framework for parsing and handling .m3u8 index files

## Installation

### [Cocoapods](https://cocoapods.org/pods/GoSwiftyM3U8)

Use something like the following in your `Podfile` (some adjustments might be needed depending on the case).

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'GoSwiftyM3U8', '~> 1.0.0'
```

Afterwards run `pod install` from the terminal in the same folder of the `Podfile` (for details of the installation and usage of CocoaPods, visit [it's official web site](https://cocoapods.org)).

It is possible to have multiple pods with different versions of Swift, this might force you to add post install handling in your `Podfile`.

## Usage Guide

For technical docs please see [API](https://gal-orlanczyk.github.io/go-swifty-m3u8/API).
Here are some basic usage examples of usage, there are 2 main ways for using the framework:

1. Fetching the playlist text on your own and only use the parser.
2. Use `M3U8Manager` to fetch and parse the playlist (a custom playlist fetcher can be provided if needed).

* Another option can be using the `PlaylistOperation` with your own queue and write the logic for fetching whichever playlists are needed.

### Using [`M3U8Parser`](https://gal-orlanczyk.github.io/go-swifty-m3u8/API/Classes/M3U8Parser.html)

A simple example of parsing a playlist:

```swift
let playlist = /* your playlist text from local/remote content */
let baseUrl = /* base url for the provided playlist */
let playlistType = /* the type of the playlist, can be: master/video/audio/subtitles */
let parser = M3U8Parser()
let params = M3U8Parser.Params(playlist: playlist, playlistType: .master, baseUrl: baseUrl)
let extraParams = M3U8Parser.ExtraParams(customRequiredTags: nil, extraTypes: nil, linePostProcessHandler: nil) // optional
do {
    let playlistResult = try parser.parse(params: params, extraParams: extraParams)
    // if our playlist was of type master you can unwrap the result like this:
    if case let .master(masterPlaylist) = playlistResult else {
        // use masterPlaylist
    }
} catch {
    // handle error
}            
```

Additional Info:
* The parser is synchronous meaning if you want it on a background queue you will need to handle it.
* The parser can be cancelled but because it is synchronous to be able to cancel the call to `parse()` must be async.
* You can reuse the parser object to parser multiple list synchronously.

### Using [`M3U8Manager`](https://gal-orlanczyk.github.io/go-swifty-m3u8/API/Classes/M3U8Manager.html)

`M3U8Manager` can fetch and parse single playlist or multiple ones, only media playlists for multiple because we must have master playlist before fetching media playlists.
You can also cancel all manager tasks using `cancel()`.

Single playlist handling:

```swift
let manager = M3U8Manager()
let playlistFetcher = /* You can use a custom playlist fetcher or nil to use the default one */
let params = PlaylistOperation.Params(fetcher: playlistFetcher, url: playlistUrl, playlistType: playlistType)
let parserExtraParams = M3U8Parser.ExtraParams(customRequiredTags: nil, extraTypes: nil, linePostProcessHandler: nil) // optional
let extraParams = PlaylistOperation.ExtraParams(parser: parserExtraParams) // optional
let operationData = M3U8Manager.PlaylistOperationData(params: params, extraParams: extraParams)
let playlistType = /* the type of the playlist from the result (can be MasterPlaylist.self/MediaPlaylist.self) */
manager.fetchAndParsePlaylist(from: operationData, playlistType: playlistType) { (result) in
    switch result {
    case .success(let playlist):
        // handle playlist
    case .failure(let error): // handle the error
    case .cancelled: // handle cancelled
    }
}
```

Multiple playlists:

```swift
let manager = M3U8Manager()
let playlistFetcher = /* You can use a custom playlist fetcher or nil to use the default one */

let params1 = PlaylistOperation.Params(fetcher: playlistFetcher, url: firstUrl, playlistType: playlistType)
let parserExtraParams1 = M3U8Parser.ExtraParams(customRequiredTags: nil, extraTypes: nil, linePostProcessHandler: nil)
let extraParams1 = PlaylistOperation.ExtraParams(parser: parserExtraParams1)
let operationData1 = M3U8Manager.PlaylistOperationData(params: params1, extraParams: extraParams1)
        
let params2 = PlaylistOperation.Params(fetcher: playlistFetcher, url: secondUrl, playlistType: playlistType)
let parserExtraParams2 = M3U8Parser.ExtraParams(customRequiredTags: nil, extraTypes: nil, linePostProcessHandler: nil)
let extraParams2 = PlaylistOperation.ExtraParams(parser: parserExtraParams2)
let operationData2 = M3U8Manager.PlaylistOperationData(params: params2, extraParams: extraParams2)

let operationsData = [operationData1, operationData2]
manager.fetchAndParseMediaPlaylists(from: operationsData) { (result) in
    switch result {
    case .success(let playlists):
        // handle playlists
    case .failure(let error): // handle the error
    case .cancelled: // handle cancelled
    }
}
```
