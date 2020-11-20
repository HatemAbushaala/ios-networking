//
//  MultipartEncoding.swift
//  MyDiary Notebook
//
//  Created by Basheer Shehabi on 24/08/2020.
//  Copyright © 2020 MyDiary Notebook. All rights reserved.
//

import Foundation

public typealias filesData = [String: Data]

extension Data{
    mutating func append(_ string : String ){
        if let data = string.data(using: .utf8){
            append(data)
        }
    }
}

public struct MultipartEncoder {
    
    
    public static func encode(urlRequest: inout URLRequest,  files: filesData,with parameters: Parameters? = nil ) throws {
        
        let boundary = UUID().uuidString
               urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = parameters {
            for (key, value) in parameters {
                body.append("--\(boundary)\(lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak)\(lineBreak)")
                body.append("\(value)\(lineBreak)")
            }
        }

            for (name, file) in files {
                body.append("--\(boundary)\(lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(name)\(lineBreak)\"\(lineBreak)")
                body.append("Content-Type: \(name.split(separator: ".").last ?? "")\(lineBreak)\(lineBreak)")
                body.append(file)
                body.append(lineBreak)

            }

        

        body.append("--\(boundary)--\(lineBreak)")
        
        urlRequest.httpBody = body
    }
    
}
