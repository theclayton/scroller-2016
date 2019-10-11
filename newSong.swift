//
//  newSong.swift
//  Scroller
//
//  Created by Clayton Ward on 1/30/17.
//  Copyright © 2017 Flare Software. All rights reserved.
//

import Foundation

class newSong {
    var songName: String
    var songComposer: String
    var textFound: String
    var songFileName: String
    
    init (songName: String, songComposer: String, textFound: String, songFileName: String) {
        self.songName = songName
        self.songComposer = songComposer
        self.textFound = textFound
        self.songFileName = songFileName
    }
}
