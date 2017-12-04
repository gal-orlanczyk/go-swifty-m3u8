//
//  M3U8ParserTests.swift
//  SwiftyM3U8Tests
//
//  Created by Gal Orlanczyk on 12/11/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

import XCTest
import GoSwiftyM3U8

class M3U8ParserTests: XCTestCase {
    
    func testParserWithMasterPlaylist() {
        let parser = M3U8Parser()
        let playlist = try! String.init(contentsOf: TestsHelper.masterPlaylistUrl)
        let params = M3U8Parser.Params(playlist: playlist, playlistType: .master, baseUrl: TestsHelper.masterPlaylistUrl.deletingLastPathComponent())
        let playlistResult = try! parser.parse(params: params)
        
        guard case let .master(masterPlaylist) = playlistResult else {
            XCTFail("result must be of type master playlist")
            return
        }
        TestsHelper.masterPlaylistTest(masterPlaylist: masterPlaylist)
    }
    
    func testParserWithMasterPlaylistPerformance() {
        let parser = M3U8Parser()
        let playlist = try! String.init(contentsOf: TestsHelper.masterPlaylistUrl)
        let params = M3U8Parser.Params(playlist: playlist, playlistType: .master, baseUrl: TestsHelper.masterPlaylistUrl.deletingLastPathComponent())
        self.measure {
            let _ = try! parser.parse(params: params)
        }
    }
    
    func testParserWithAudioMediaPlaylist() {
        self.testMediaPlaylist(url: TestsHelper.audioPlaylistUrl, playlistType: .audio, version: 3, targetDuration: 6,
                               mediaSequence: 0, playlistTagType: .vod, mediaSegmentsCount: 101, mediaSegmentFirstValue: 5.99467,
                               mediaSegmentFirstUri: "fileSequence0.aac", mediaSegmentLastUri: "fileSequence100.aac")
    }
    
    func testParserWithAudioMediaPlaylistPerformance() {
        let parser = M3U8Parser()
        let playlist = try! String.init(contentsOf: TestsHelper.audioPlaylistUrl)
        let params = M3U8Parser.Params(playlist: playlist, playlistType: .audio, baseUrl: TestsHelper.audioPlaylistUrl.deletingLastPathComponent())
        let extraParams = M3U8Parser.ExtraParams(extraTypes: [EXT_X_MEDIA_SEQUENCE.self])
        self.measure {
            let _ = try! parser.parse(params: params, extraParams: extraParams)
        }
    }
    
    func testParserWithVideoMediaPlaylist() {
        self.testMediaPlaylist(url: TestsHelper.videoPlaylistUrl, playlistType: .video, version: 3, targetDuration: 6,
                               mediaSequence: 0, playlistTagType: .vod, mediaSegmentsCount: 100, mediaSegmentFirstValue: 6,
                               mediaSegmentFirstUri: "fileSequence0.ts", mediaSegmentLastUri: "fileSequence99.ts")
    }
    
    func testParserWithVideoMediaPlaylistPerformance() {
        let parser = M3U8Parser()
        let playlist = try! String.init(contentsOf: TestsHelper.videoPlaylistUrl)
        let params = M3U8Parser.Params(playlist: playlist, playlistType: .video, baseUrl: TestsHelper.videoPlaylistUrl.deletingLastPathComponent())
        let extraParams = M3U8Parser.ExtraParams(extraTypes: [EXT_X_MEDIA_SEQUENCE.self])
        self.measure {
            let _ = try! parser.parse(params: params, extraParams: extraParams)
        }
    }
    
    func testParserWithSubtitlesMediaPlaylist() {
        self.testMediaPlaylist(url: TestsHelper.subtitlesPlaylistUrl, playlistType: .subtitles, version: 3, targetDuration: 6,
                               mediaSequence: 0, playlistTagType: .vod, mediaSegmentsCount: 100, mediaSegmentFirstValue: 6,
                               mediaSegmentFirstUri: "fileSequence0.webvtt", mediaSegmentLastUri: "fileSequence99.webvtt")
    }
    
    func testParserWithSubtitlesMediaPlaylistPerformance() {
        let parser = M3U8Parser()
        let playlist = try! String.init(contentsOf: TestsHelper.subtitlesPlaylistUrl)
        let params = M3U8Parser.Params(playlist: playlist, playlistType: .subtitles, baseUrl: TestsHelper.subtitlesPlaylistUrl.deletingLastPathComponent())
        let extraParams = M3U8Parser.ExtraParams(extraTypes: [EXT_X_MEDIA_SEQUENCE.self])
        self.measure {
            let _ = try! parser.parse(params: params, extraParams: extraParams)
        }
    }
    
    private func testMediaPlaylist(url: URL, playlistType: PlaylistType, version: Int, targetDuration: Int, mediaSequence: Int,
                                   playlistTagType: PlaylistTagType, mediaSegmentsCount: Int, mediaSegmentFirstValue: Double,
                                   mediaSegmentFirstUri: String, mediaSegmentLastUri: String) {
        
        let parser = M3U8Parser()
        let playlist = try! String.init(contentsOf: url)
        let params = M3U8Parser.Params(playlist: playlist, playlistType: playlistType, baseUrl: url)
        let extraParams = M3U8Parser.ExtraParams(extraTypes: [EXT_X_MEDIA_SEQUENCE.self])
        let playlistResult = try! parser.parse(params: params, extraParams: extraParams)
        
        guard case let .media(mediaPlaylist) = playlistResult else {
            XCTFail("result must be of type media playlist")
            return
        }
        
        XCTAssertEqual(mediaPlaylist.tags.versionTag?.value, version)
        XCTAssertEqual(mediaPlaylist.tags.targetDurationTag.value, targetDuration)
        XCTAssertEqual(mediaPlaylist.tags.mediaSequence?.value, mediaSequence)
        XCTAssertEqual(mediaPlaylist.tags.playlistTypeTag?.value, playlistTagType)
        XCTAssertEqual(mediaPlaylist.tags.mediaSegments.count, mediaSegmentsCount)
        XCTAssertEqual(mediaPlaylist.tags.mediaSegments.first?.value, mediaSegmentFirstValue)
        XCTAssertEqual(mediaPlaylist.tags.mediaSegments.first?.uri, mediaSegmentFirstUri)
        XCTAssertEqual(mediaPlaylist.tags.mediaSegments.last?.uri, mediaSegmentLastUri)
    }
    
    func testParserVideoPlaylistWithAES128() {
        let parser = M3U8Parser()
        let playlist = try! String.init(contentsOf: TestsHelper.videoPlaylistAes128Url)
        let params = M3U8Parser.Params(playlist: playlist, playlistType: .video, baseUrl: TestsHelper.videoPlaylistAes128Url.deletingLastPathComponent())
        let playlistResult = try! parser.parse(params: params)
        
        guard case let .media(mediaPlaylist) = playlistResult else {
            XCTFail("result must be of type media playlist")
            return
        }
        
        XCTAssertEqual(mediaPlaylist.tags.versionTag?.value, 3)
        XCTAssertEqual(mediaPlaylist.tags.targetDurationTag.value, 5)
        XCTAssertEqual(mediaPlaylist.tags.mediaSegments.count, 149)
        XCTAssertEqual(mediaPlaylist.tags.keySegments.count, 149)
        XCTAssertEqual(mediaPlaylist.tags.keySegments.first?.method, "AES-128")
        XCTAssertEqual(mediaPlaylist.tags.keySegments.first?.uri, "segment-00000.key")
        XCTAssertEqual(mediaPlaylist.tags.mediaSegments.first?.value, 4.458667)
        XCTAssertEqual(mediaPlaylist.tags.mediaSegments.first?.uri, "segment-00000.ts.enc")
        XCTAssertEqual(mediaPlaylist.tags.mediaSegments.last?.uri, "segment-00148.ts.enc")
    }
    
    func testParserPostProcess() {
        let parser = M3U8Parser()
        let playlist = try! String.init(contentsOf: TestsHelper.masterPlaylistUrl)
        let params = M3U8Parser.Params(playlist: playlist, playlistType: .master, baseUrl: TestsHelper.masterPlaylistUrl.deletingLastPathComponent())
        // set post process handler to delete first character when possible
        let extraParams = M3U8Parser.ExtraParams(customRequiredTags: nil, extraTypes: nil) { (lines) -> [String] in
            var mutableLines = lines
            for (index, line) in lines.enumerated() {
                if line.count > 0 {
                    mutableLines[index] = String(line[line.index(line.startIndex, offsetBy: 1)..<line.endIndex])
                }
            }
            return mutableLines
        }
        let playlistResult = try! parser.parse(params: params, extraParams: extraParams)
        guard case let .master(masterPlaylist) = playlistResult else {
            XCTFail("result must be of type master playlist")
            return
        }
        XCTAssertNotEqual(masterPlaylist.originalText, masterPlaylist.alteredText)
    }
    
    func testParserCancellation() {
        let exp = expectation(description: "async expectation")
        let parser = M3U8Parser()
        let playlist = try! String.init(contentsOf: TestsHelper.videoPlaylistAes128Url)
        let params = M3U8Parser.Params(playlist: playlist, playlistType: .video, baseUrl: TestsHelper.videoPlaylistAes128Url.deletingLastPathComponent())
        DispatchQueue.global().async {
            let playlistResult = try! parser.parse(params: params)
            switch playlistResult {
            case .master(_): XCTFail("wrong result")
            case .media(_): XCTFail("wrong result")
            case .cancelled: print("parser was cancelled successfully")
            }
            exp.fulfill()
        }
        parser.cancel()
        waitForExpectations(timeout: 10, handler: nil)
    }
}
