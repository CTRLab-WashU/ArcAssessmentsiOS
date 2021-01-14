//
//  AuthDetailsResponse.swift
//  Arc
//
//  Created by Philip Hayes on 12/16/20.
//  Copyright © 2020 HealthyMedium. All rights reserved.
//

import Foundation
public enum AuthDetailType : String, Codable {
    case rater
    case confirm_code
    case manual
}
/**
 {
 "response": {
 "success": true,
 "study_name": "EEE",
 "auth_type": "rater",
 "auth_code_length": 6
 },
 "errors": {}
 }
 */
public struct AuthDetailsResponse : Codable {
    public struct ResponseBody : Codable {
        public var success:Bool
        public var study_name:String
        public var auth_type:AuthDetailType
        public var auth_code_length:Int
    }


    public var response:ResponseBody
    public var errors:[String:[String]]
    
    static let debug:AuthDetailsResponse = AuthDetailsResponse(response: ResponseBody(success: true, study_name: "debug", auth_type: .manual, auth_code_length: 6), errors: [:])
}
