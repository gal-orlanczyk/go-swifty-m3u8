//
//  TestsHelper.swift
//  SwiftyM3U8Tests
//
//  Created by Gal Orlanczyk on 13/11/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

import Foundation
import XCTest
@testable import GoSwiftyM3U8

final class TestsHelper {
    
    private init() {}
    
    static let masterPlaylistUrl = URL(fileURLWithPath: Bundle(for: TestsHelper.self).path(forResource: "Resources/AppleAdvanceStreamTS/master", ofType: "m3u8")!)
    static let videoPlaylistUrl = URL(fileURLWithPath: Bundle(for: TestsHelper.self).path(forResource: "prog_index", ofType: "m3u8", inDirectory: "Resources/AppleAdvanceStreamTS/v5")!)
    static let audioPlaylistUrl = URL(fileURLWithPath: Bundle(for: TestsHelper.self).path(forResource: "prog_index", ofType: "m3u8", inDirectory: "Resources/AppleAdvanceStreamTS/a1")!)
    static let subtitlesPlaylistUrl = URL(fileURLWithPath: Bundle(for: TestsHelper.self).path(forResource: "prog_index", ofType: "m3u8", inDirectory: "Resources/AppleAdvanceStreamTS/s1/en")!)
    static let videoPlaylistAes128Url = URL(fileURLWithPath: Bundle(for: TestsHelper.self).path(forResource: "video-aes-128", ofType: "m3u8", inDirectory: "Resources")!)
    
    static func masterPlaylistTest(masterPlaylist: MasterPlaylist) {
        XCTAssertEqual(masterPlaylist.tags.versionTag?.value, 6)
        XCTAssertEqual(masterPlaylist.tags.mediaTags.count, 5)
        XCTAssertEqual(masterPlaylist.tags.streamTags.count, 24)
        // test first stream line
        XCTAssertEqual(masterPlaylist.tags.streamTags.first?.bandwidth, 2227464)
        XCTAssertEqual(masterPlaylist.tags.streamTags.first?.resolution, "960x540")
        XCTAssertEqual(masterPlaylist.tags.streamTags.first?.uri, "v5/prog_index.m3u8")
        // test first media playlist line
        XCTAssertEqual(masterPlaylist.tags.mediaTags.first?.mediaType, .audio)
        XCTAssertEqual(masterPlaylist.tags.mediaTags.first?.groupId, "aud1")
        XCTAssertEqual(masterPlaylist.tags.mediaTags.first?.uri, "a1/prog_index.m3u8")
    }
}
