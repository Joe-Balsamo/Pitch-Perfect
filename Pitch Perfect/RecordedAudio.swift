//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Joseph Balsamo on 11/16/15.
//  Copyright © 2015 Joseph Balsamo. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init (filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}