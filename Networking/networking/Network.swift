//
//  Network.swift
//  Networking
//
//  Created by Hatem Abushaala on 11/17/20.
//  Copyright © 2020 haten. All rights reserved.
//

import Foundation

class NetworkRequest<Response:Codable>{
    
    static func checkStatusCodeError(code:Int)->HttpError{
        
        switch code {
            
        case 400:
            return HttpError.badRequest
            
        case 301: // this wrong but needed for my work
            return HttpError.validation
            
        case 401:
            return HttpError.unAuthorized
            
        case 404:
            return HttpError.notfound
            
        case 500:
            return HttpError.internalServerError
            
        default:
            return HttpError.standard
        }
        
    }
    
    static func serializeResponse(data:Data) throws -> Response{
        return try JSONDecoder().decode(Response.self, from: data)
    }
    
    static func handleGenericError(_ error:Error) -> Error{
        
        print("request building error")
        print(error )
        return error
        
        
    }
    
    static func buildRequest(endpoint:String)->URLRequest{
        print("--------------NETWORK CALL---------------------")
        let requestUrl =  "\(BASE_URL)\(endpoint)"
        print("url : \(requestUrl)")
        var urlRequest = URLRequest(url: URL(string: requestUrl)!)
        urlRequest.setValue("Application/json", forHTTPHeaderField: "Accept")
        let token: String? = UserDefaults.standard.string(forKey: "access_token")
        if  token != nil {
            urlRequest.setValue(token, forHTTPHeaderField: "authorization")
        }
        print("headers : \( String(describing: urlRequest.allHTTPHeaderFields))")
        
        return urlRequest
    }
    
    static func post(endpoint:String,_ requestType:RequestType  ) throws -> Response   {
        
        let session = URLSession(configuration: .default)
        var urlRequest = buildRequest(endpoint: endpoint)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        
        // add body ------------------------------------------------------------
        switch requestType {
        case .FormUrlEncoded(body: let _body):
            do{
                urlRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
                let httpBody = try JSONSerialization.data(withJSONObject: _body,options: .prettyPrinted)
                urlRequest.httpBody = httpBody
            }
            
        case .Body(body: let _body):
            do{
                urlRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
                let httpBody = try JSONEncoder().encode(AnyEncodable(_body))
                urlRequest.httpBody = httpBody
            }
            
        case .MultiPart(files: let files,let parameters):
            do {
                try  MultipartEncoder.encode(urlRequest: &urlRequest, files: files,with: parameters)
            } catch  {
                print("error encoding files \(error)" )
            }
            
        }
        
        var data : Data?
        var error : Error?
        var response : URLResponse?
        
        let semephore = DispatchSemaphore(value: 0)
        
        // execute request ------------------------------------------------------------
        
        session.dataTask(with: urlRequest){ (d, r, e) in
            
            error = e
            response = r
            data = d
            print("signal")
            
            semephore.signal()
            
        }.resume()
        print("waiting")
        
        semephore.wait()
        
        print("finish waiting")
        
         if error != nil {throw handleGenericError(error!)}

        if let httpUrlResponse = response as? HTTPURLResponse {
            
            let statusCode = httpUrlResponse.statusCode
            print("status code : \(statusCode)" )
            
            if statusCode != 200 {
                throw checkStatusCodeError(code: statusCode)
            }
        }
        
        do{
            return try serializeResponse(data: data!)
        }catch let error{
            print("json response serialization error : \(error)")
            throw HttpError.jsonSerializationError
        }
        
    }
    
    static func get(endpoint:String,query:Parameters? = nil)  throws -> Response{
        
        let session = URLSession(configuration: .default)
        var urlRequest = buildRequest(endpoint: endpoint)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        
        // query params ------------------------------------------------------------
        if query != nil {
            do {
                try  URLParameterEncoder().encode(urlRequest: &urlRequest, with: query!)
            } catch  {
                print("error encoding query params : \(error) ")
            }
        }
        
        // execute request ------------------------------------------------------------
        print("starting request")
        
        var data : Data?
        var error : Error?
        var response : URLResponse?
        
        let semephore = DispatchSemaphore(value: 0)
        session.dataTask(with: urlRequest){ (d, r, e) in
            
            
            error = e
            response = r
            data = d
            
            print("signal")
            
            semephore.signal()
            
        }.resume()
        
        print("Waiting")
        
        semephore.wait()
        
        print("finish wating")
        
        
        // after complete executing request we have 3 steps of validation : request error , request status code , request response serialization....
        
        if error != nil {throw handleGenericError(error!)}
        
        if let httpUrlResponse = response as? HTTPURLResponse {
            
            let statusCode = httpUrlResponse.statusCode
            print("status code : \(statusCode)" )
            
            if statusCode != 200 {
                throw checkStatusCodeError(code: statusCode)
            }
        }
        
        do{
            return try serializeResponse(data: data!)
        }catch let error{
            print("json response serialization error : \(error)")
            throw HttpError.jsonSerializationError
        }
        
        
    }
    
    
    
}


public typealias Parameters = [String: Any]

enum RequestType {
    
    case FormUrlEncoded(body:Parameters)
    case MultiPart(files:filesData,parameters:Parameters? = nil)
    case Body(body:Encodable)
}

public enum NetworkError: String, Error {
    case parametersNil = "Parameters were nil"
    case encodingFailed = "Parameters encoding failed"
    case missingURL = "URL is nil"
}


class CodabaleResponse : Codable{
    let code : Int
    let msg : String 
}


enum HttpError : Error{
    case notfound // 404
    case badRequest // 400
    case unAuthorized // 401
    case internalServerError // 500
    case jsonSerializationError
    case validation // optionaly pass the responsen in order to let user what is wrong
    case standard
}

class AnyEncodable: Encodable {
    var _encodeFunc: (Encoder) throws -> Void
    
    init(_ encodable: Encodable) {
        func _encode(to encoder: Encoder) throws {
            try encodable.encode(to: encoder)
        }
        self._encodeFunc = _encode
    }
    func encode(to encoder: Encoder) throws {
        try _encodeFunc(encoder)
    }
}

class Contact : Codable{
    let name = "hagdtem"
}

 
