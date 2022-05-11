//
//  Networking.swift
//  TMDb
//
//  Created by Krutika on 2022-05-06.
//

import Foundation
// network manger has urlsession methods generalised error handing
struct ErrorHandler{
    var code = 0
    var message = ""
}
struct NetworkManager {
    private var urlSession: URLSession

    // Initialization
    init() {
        urlSession = URLSession.shared
    }
    
    func httpGet(url: URL,  callback: @escaping (Data?, ErrorHandler?) -> Void) {
        let task = urlSession.dataTask(with: url) { data, response, error in
            if error != nil {
                callback(nil,ErrorHandler(code: 0, message: error?.localizedDescription ?? ""))
            }
            if let httpResponse = response as? HTTPURLResponse {
                
                if (200...299).contains(httpResponse.statusCode) {
                    callback(data,nil)
                }else {
                    let err = ErrorHandler(code: httpResponse.statusCode, message: httpResponse.description)
                    callback(nil,err)
                }
            }else {
                //
                callback(data,ErrorHandler(code: 0, message: error?.localizedDescription ?? ""))
            }
            
        }
        task.resume()
        
    }
            
}
