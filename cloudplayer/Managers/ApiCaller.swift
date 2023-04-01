//
//  ApiCaller.swift
//  cloudplayer
//
//  Created by chandra kiran on 31/03/23.
//

import Foundation
import SwiftyDropbox


class Api{
    private let client = DropboxClientsManager.authorizedClient
    var data: Array<String>?

//    public func getSomething()->Array<String>{
//        self.data = []
//        print("Api method called")
//        client?.files.listFolder(path: "").response{response,error in
//            if let response = response{
//                for entry in response.entries{
//                    if(entry.name.hasSuffix("mp3") || entry.name.hasSuffix("m4a")){
//                        self.data?.append(entry.name)
//                    }
//                }
//            }
//            else{
//                print("Api rippped")
//            }
//        }
//        print(data)
//        
//    }
}
