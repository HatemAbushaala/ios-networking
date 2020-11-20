//
//  JSONParameterEncoder.swift
//  MyDiary Notebook
//
//  Created by Basheer Shehabi on 2020-07-31.
//  Copyright © 2020 MyDiary Notebook. All rights reserved.
//

import Foundation

public struct JSONParameterEncoder {
    
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        
        do {
            
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
        } catch {
            throw NetworkError.encodingFailed
        }
        
    }    
    
}
