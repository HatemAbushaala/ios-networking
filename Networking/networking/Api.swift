//
//  Api.swift
//  Networking
//
//  Created by Hatem Abushaala on 11/20/20.
//  Copyright © 2020 haten. All rights reserved.
//

import Foundation


/*
============
------------
GET request
------------
============

*/

// build the request only
class Api{
    
    //@GET api/
    func basicGet() throws -> CodabaleResponse  {
        return try NetworkRequest<CodabaleResponse>.get(endpoint: "countries")
    }
    
    //@GET api?key=value&key2=value2......
    func getWithQuery(query:Parameters) throws -> CodabaleResponse  {
        return try NetworkRequest<CodabaleResponse>.get(endpoint: "route",query: query)
    }
    
    // predefined query
    //@GET api?code=value
    func request3(code:String) throws -> CodabaleResponse  {
        return try NetworkRequest<CodabaleResponse>.get(endpoint: "route",query: ["code":code])
    }
    
    // sub route
    //@GET api/:id
    func getWithSubroute(id:String) throws -> CodabaleResponse  {
        return try NetworkRequest<CodabaleResponse>.get(endpoint: "cities/\(id)")
    }
}

/*
 ============
 ------------
 POST request
 ------------
 ============
 
 */

extension Api{
    
  //   fieldMap , field , body , multipart
    func postField(field1:String)throws -> CodabaleResponse {
        return try NetworkRequest<CodabaleResponse>.post(endpoint: "route",.FormUrlEncoded(body: ["field1":field1]))
    }

    func postFieldMap(fieldMap:Parameters)throws -> CodabaleResponse {
        return try NetworkRequest<CodabaleResponse>.post(endpoint: "contacts",.FormUrlEncoded(body: fieldMap))
    }
    
    func postBody(body:Contact)throws -> CodabaleResponse {
        return try NetworkRequest<CodabaleResponse>.post(endpoint: "contacts",.Body(body: body))
    }
    
    func postMultiPart(files:filesData)throws -> CodabaleResponse {
        return try NetworkRequest<CodabaleResponse>.post(endpoint: "personal_image",.MultiPart(files: files))
    }
}
/*

snippit

 1.if get
 // how to camelCase first letter ?
 func get$endpoint$() throws -> CodabaleResponse  {
     return try NetworkRequest<$response$>.get(endpoint: "$endpoint$")
 }

*/
