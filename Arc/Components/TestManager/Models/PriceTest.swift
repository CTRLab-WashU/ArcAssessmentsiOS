//
//  PriceTest.swift
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
//For UI configuration only
public struct PriceTest : Codable{
    public struct Item : Codable {
        var item:String
        var price:String
        var alt:String
    }
    var items:Array<Item>
}
//For server communication only
public struct PriceTestResponse : ArcTestCodable {
    	public static var dataType: SurveyType = .priceTest

    public struct Choice : Codable {
        var price:String
        var alt_price:String
        var item:String
        var good_price:Int?
        var correct_index:Int?
        var selected_index:Int?
        var question_display_time:TimeInterval?
        var selection_time:TimeInterval?
        var stimulus_display_time:TimeInterval?
        
        init(item:PriceTest.Item) {
            self.price = item.price
            self.alt_price = item.alt
            self.item = item.item
        }
    }
    
    public var id: String?
    public var type: SurveyType? = .priceTest

    public var date:TimeInterval?
    var sections:Array<Choice>
    
    init(id:String) {
        self.id = id
        sections = []
    }
}
