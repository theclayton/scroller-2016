//
//  Song.swift
//  Scroller
//
//  Created by Clayton Ward on 7/22/16.
//  Copyright © 2016 Flare Software. All rights reserved.
//

import Foundation

class Song {
    var songName: String
    var songComposer: String
    var songFileName: String
    
    init (songName: String, songComposer: String, songFileName: String) {
        self.songName = songName
        self.songComposer = songComposer
        self.songFileName = songFileName
    }
}
