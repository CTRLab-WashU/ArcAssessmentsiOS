//
//  StatusCode.swift
// Arc
//
// Copyright (c) 2022 Washington University in St. Louis
//
// Washington University in St. Louis hereby grants to you a non-transferable,
// non-exclusive, royalty-free license to use and copy the computer code
// provided here (the "Software").  You agree to include this license and the
// above copyright notice in all copies of the Software.  The Software may not
// be distributed, shared, or transferred to any third party.  This license does
// not grant any rights or licenses to any other patents, copyrights, or other
// forms of intellectual property owned or controlled by
// Washington University in St. Louis.
//
// YOU AGREE THAT THE SOFTWARE PROVIDED HEREUNDER IS EXPERIMENTAL AND IS PROVIDED
// "AS IS", WITHOUT ANY WARRANTY OF ANY KIND, EXPRESSED OR IMPLIED, INCLUDING
// WITHOUT LIMITATION WARRANTIES OF MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR
// PURPOSE, OR NON-INFRINGEMENT OF ANY THIRD-PARTY PATENT, COPYRIGHT, OR ANY OTHER
// THIRD-PARTY RIGHT.  IN NO EVENT SHALL THE CREATORS OF THE SOFTWARE OR WASHINGTON
// UNIVERSITY IN ST LOUIS BE LIABLE FOR ANY DIRECT, INDIRECT, SPECIAL, OR
// CONSEQUENTIAL DAMAGES ARISING OUT OF OR IN ANY WAY CONNECTED WITH THE SOFTWARE,
// THE USE OF THE SOFTWARE, OR THIS AGREEMENT, WHETHER IN BREACH OF CONTRACT, TORT
// OR OTHERWISE, EVEN IF SUCH PARTY IS ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
//

import Foundation
/**
 A convenience enum for handling status codes returned from rest apis.
    - attention: Initialize instances using:

            StatusCode.with(response:URLResponse?) -> Self
    - version: 1.0
 */
public enum StatusCode  {
	case unknown
    case code(Int)

    /**
     Create a status code with a url response
        - important: This is for use with HTTP requests only.

        - parameter response: an instance of URLResponse returned from a rest api call.
    */
    static func with(response:URLResponse?) -> Self{
        if let r = response as? HTTPURLResponse {
            return .code(r.statusCode)
        }
        return .unknown
    }

    ///Get the stored value
    var code:Int? {
        switch self {
            case .unknown:
            return nil
            case .code(let c):
            return c
        }
    }
    ///Determine success by the status code
    /// - attention: this iteration only considers values falling within 200 ... 299 as success
    /// - returns: true for any 2xx status code
    var succeeded:Bool {
        if let c = code, (200 ... 299).contains(c) {
            return true
        }
        return false
    }
    ///A localized message for end-user consumption.
    /// - returns: A string from the translation document for the current language
    var failureMessage:String? {
        if let code = code {
            if code == 401 || code == 406 {
                return "Invalid Rater ID or ARC ID".localized(ACTranslationKey.login_error1)
            }
            if code == 409 {
                return "Already enrolled on another device".localized(ACTranslationKey.login_error2)
            }
            if code > 199, code < 300{
                return nil
            }
        }
        return "Sorry, our app is currently experiencing issues. Please try again later.".localized(ACTranslationKey.login_error3)
    }
}
