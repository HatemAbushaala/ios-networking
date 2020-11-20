//
//  Repo.swift
//  Networking
//
//  Created by Hatem Abushaala on 11/20/20.
//  Copyright © 2020 haten. All rights reserved.
//

import Foundation

// api request implementation
// FOR CONSISTENCY NAME THE METHOD AS API NAME
// EX: /COUNTRIES -> getCountries() -> getCountries(successHandler,errorHandler)
// writing code snippits

class DataRepo{
    
    static let API = Api()
    // take success handler and optional error handler

    static func basicGet(
        successHandler : @escaping (CodabaleResponse)->Void,
        errorHandler :  ((Error)->Void)? = nil
    ){
        
        do {
            try successHandler(API.basicGet())
        } catch  {
            
             print ("error catched in repo \(error)" )
            // error handler
            // do something with error as default
            // let client customize error handling
        }
        
    }

    
    static func getWithQuery(
        query:Parameters,
        successHandler : @escaping (CodabaleResponse)->Void,
        errorHandler :  ((Error)->Void)? = nil
    ){
        
        do {
            try successHandler(API.getWithQuery(query: query))
        } catch  {
            // error handler
            // do something with error as default
            // let client customize error handling
        }
        
    }
    
    
    static func request3Imp(
        code:String,
        successHandler : @escaping (CodabaleResponse)->Void,
        errorHandler :  ((Error)->Void)? = nil
    ){
        
        do {
            try successHandler(API.request3(code: code))
        } catch  {
            // error handler
            // do something with error as default
            // let client customize error handling
        }
        
    }
    
    static func getWithSubroute(
        id:String,
        successHandler : @escaping (CodabaleResponse)->Void,
        errorHandler :  ((Error)->Void)? = nil
    ){
        
        do {
            try successHandler(API.getWithSubroute(id: id))
        } catch  {
            // error handler
            // do something with error as default
            // let client customize error handling
        }
        
    }
    
    static func contact(
        _ contact:Contact,
        successHandler : @escaping (CodabaleResponse)->Void,
        errorHandler :  ((Error)->Void)? = nil
    ){
        
        do {
            try successHandler(API.postBody(body: contact))
        } catch  {
            print ("error catched in repo \(error)" )
            // error handler
            // do something with error as default
            // let client customize error handling
        }
        
    }
    
    
    static func uploadImage(
        _ img:Data,
        successHandler : @escaping (CodabaleResponse)->Void,
        errorHandler :  ((Error)->Void)? = nil
    ){
        
        do {
            try successHandler(API.postMultiPart(files: ["img":img]))
        } catch  {
            print ("error catched in repo \(error)" )
            // error handler
            // do something with error as default
            // let client customize error handling
        }
        
    }
    
    
}

/*

snippit

static func $1$(
    successHandler : @escaping ($2$)->Void,
    errorHandler :  ((Error)->Void)? = nil
){
    
    do {
        try successHandler(API.$1$())
    } catch  {
        
         print ("error catched in repo \(error)" )
        // error handler
        // do something with error as default
        // let client customize error handling
    }
    
}

*/
