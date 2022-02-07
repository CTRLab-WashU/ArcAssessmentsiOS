//
//  SymbolsTest.swift
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
/*
public struct DNSymbolSet {
    
    var symbols:[Int]
    
}

public struct DNSymbolDataSet{
    
    var options:[DNSymbolSet]
    var choices:[DNSymbolSet]
    var correct:Int
}
public struct DNSymbolInputData {
    var choice:Int
    var timeTouched:NSDate
    var referenceTime:NSDate
    var touchLocation:CGPoint = CGPoint.zero
    
    init() {
        choice = -1
        timeTouched = NSDate()
        referenceTime = NSDate()
    }
}
 */
import Foundation
//For UI configuration
public struct SymbolsTest : Codable {
    public struct SymbolSet: Codable, Equatable {
        var symbols:[Int]
        
    }

    public struct Section : Codable {
        var options:Array<SymbolSet>
        var choices:Array<SymbolSet>
        var correct:Int
        
    }
    var sections:Array<Section> = []
    
    
}


//For server communication
public struct SymbolsTestResponse : ArcTestCodable {
	public static var dataType: SurveyType = .symbolsTest

    public struct Section : Codable {
        
        var appearance_time:TimeInterval?
        var selection_time:TimeInterval?
        var correct:Int?
        var selected:Int = -1
        var choices:Array<Array<String>>? = []
        var options:Array<Array<String>>? = []
    }
    
    public var id: String?
    
    public var type: SurveyType? = .symbolsTest
    
    public var date:TimeInterval?
    
    var sections:Array<Section> = []
    
    init(id:String) {
        self.id = id
    }
    
}
