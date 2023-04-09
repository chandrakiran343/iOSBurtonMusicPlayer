//
//  ScapeGoatButton.swift
//  cloudplayer
//
//  Created by chandra kiran on 08/04/23.
//

import UIKit
import AHDownloadButton

class ScapeGoatButton: UIButton {

    var object: AHDownloadButton
    var id: Int
    init(button: inout AHDownloadButton,frame: CGRect,id:Int) {
        
        self.object = button
        self.id = id
        super.init(frame: frame)
//        self.frame = frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
