//
//  GridTestController.swift
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
import UIKit

open class GridTestController : TestController<GridTestResponse> {
    
    
    public enum GridType {
        case image
        case distraction
    }
    public enum GridTestError: Error {
        case invalidConfiguration(String)
    }
    
    var currentTests:[GridTest] = []
	private var symbols:[String] = ["key",
									"phone",
									"pen"]
    //Load a test
    public func createTest(numberOfTests:Int) -> [GridTest] {
        var tests = [GridTest]()
        for _ in 0 ..< numberOfTests {
            let imageGridSize = GridTest.Size(width: 5,
                                              height: 5)
            var fGridSize:GridTest.Size
            if Arc.environment?.gridTestType == .extended {
                fGridSize = GridTest.Size(width: 6, height: 9)
            } else {
                fGridSize = GridTest.Size(width: 6,
                height: 10)
            }

            
            var gridTest = GridTest(imageGridSize: imageGridSize,
                                    fGridSize: fGridSize)
            
                gridTest.imageGrid = populateImages(for: gridTest.imageGrid, numSymbols: 3)
                gridTest.fGrid = populateFs(for: gridTest.fGrid, numFs: 8)
                
                tests.append(gridTest)
           
            
        }
        currentTests = tests
        return tests
    }
    
    public func createTutorialTest() -> [GridTest] {
        var tests = [GridTest]()

        guard let asset = Arc.shared.dataAsset(named: "grid_test_tutorial") else {
            fatalError("Couldn't find grid tutorial json asset")
        }
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: asset.data, options: .allowFragments)
            let tutorialDict = jsonResult as! [String:Array<[String:Int]>]
            let imageGridSize = GridTest.Size(width: 5, height: 5)
            let fGridSize = GridTest.Size(width: 6, height: 10)
            var gridTest = GridTest(imageGridSize: imageGridSize, fGridSize: fGridSize)
            for symbol in tutorialDict["symbols"]! {
                let x = symbol["x"]! as Int
                let y = symbol["y"]! as Int
                let id = symbol["image_id"]! as Int
                gridTest.imageGrid.values[y][x] = id
                gridTest.imageGrid.symbols.append(GridTest.Grid.Symbol(symbol: id, x: x, y: y))
            }
            
            for f in tutorialDict["f_locations"]! {
                let x = f["x"]! as Int
                let y = f["y"]! as Int
                gridTest.fGrid.values[y][x] = 1
                gridTest.fGrid.symbols.append(GridTest.Grid.Symbol(symbol: 1, x: x, y: y))
            }

            tests.append(gridTest)

        } catch {
            fatalError("Couldn't convert asset to json")
        }
        
        currentTests = tests
        return tests
    }
	
    private func populateImages(for grid:GridTest.Grid, numSymbols:Int) -> GridTest.Grid {
        if grid.size.height < numSymbols {
            fatalError("Image Grids height: \(grid.size.height) must be >= \(numSymbols)")
        }
        
        if grid.values.count == 0 {
            fatalError("Grid contains no values.")
        }
        var grid = grid

        var rowsWithSymbols:Set<Int> = []
        
        var usedSymbols:Set<Int> = []
    
        //Pick a unique rows that will contain a symbol
        //Sets cannot contain duplicate values
        while rowsWithSymbols.count < numSymbols {
            rowsWithSymbols.insert(Int.random(in: 0..<grid.size.height))
        }
        
        for row in 0 ..< grid.values.count {
            if rowsWithSymbols.contains(row) {
                let index = Int(Int.random(in: 0..<grid.size.width))
                
                let imageId = Set<Int>(Array(0..<numSymbols)) //Create a Set
                    .subtracting(usedSymbols) //That doesn't contain anything we've used
                    .randomElement()! //return a random item
                
                
                usedSymbols.insert(imageId)
            
                grid.values[row][index] = imageId;
                grid.symbols.append(GridTest.Grid.Symbol(symbol: imageId, x: index, y: row))
            }
            
        }
        
        return grid
    }
    
    private func populateFs(for grid:GridTest.Grid, numFs:Int) -> GridTest.Grid {
        
        var grid = grid
        var items:Array<Int> = Array();
        
        items.append(-1);
        items.append(grid.size.width * grid.size.height);
        
        var count = 0;
        while count < numFs
        {
            items.sort();
            let minMax = findGap(items: items);
            
            items.append( (minMax.min + 1) + Int( arc4random_uniform(UInt32( minMax.max - minMax.min - 1))));
            count += 1;
        }
        
        items.sort();
        
        items.removeFirst();
        items.removeLast();
        
        for i in items
        {
            let row = i / grid.size.width;
            let col = i % grid.size.width;
            grid.values[row][col] = 1;
            grid.symbols.append(GridTest.Grid.Symbol(symbol: 1, x: col, y: row))
        }
        
        return grid
    }
    
    
    private func findGap(items:Array<Int>) -> (min:Int, max:Int)
    {
        var gap = 0;
        var min = 0;
        var max = 0;
        for i in 0..<items.count - 1
        {
            if items[i + 1] - items[i] > gap
            {
                gap = items[i + 1] - items[i];
                min = items[i];
                max = items[i + 1];
            }
        }
        
        return (min:min, max:max);
    }
    
    
    
    
    
    
    //create a response
    public func createResponse(id:String = UUID().uuidString, numSections:Int) -> String {
        let gridTest = self.createGridTestResponse(id: id, numSections: numSections);
        
        //We must return an id
        return save(id: id, obj: gridTest).id!
    }
    
    public func createGridTestResponse(id:String = UUID().uuidString, numSections: Int) -> GridTestResponse
    {
        let gridTest = GridTestResponse(id: id, numSections:numSections)
        return gridTest;
    }
    
    //read in a response
    
    private func coordinate(for index:Int, section:Int, gridType:GridTestController.GridType) -> (Int, Int) {
        var grid:Array<Array<Int>> = []
        switch gridType {
        case .image:
            grid = currentTests[section].imageGrid.values
        case .distraction:
            grid = currentTests[section].fGrid.values
        }
        let row = (index / grid[0].count)
        let col = (index % grid[0].count)
        
       return (col, row)
    }
    public func get(item index:Int, section:Int, gridType:GridTestController.GridType) -> Int {
            var grid:Array<Array<Int>> = []
            switch gridType {
            case .image:
                grid = currentTests[section].imageGrid.values
            case .distraction:
                grid = currentTests[section].fGrid.values
            }
        
        return grid[index / (grid[0].count)][index % (grid[0].count)]


    }
    public func get(numChoicesFor id:String, testIndex:Int) -> Int {
        do {
            var test = try self.get(response: id)
            if testIndex < test.sections.count {
                return test.sections[testIndex].choices.count
            }
            return 0
        } catch {
            fatalError(error.localizedDescription)
        }
    }
	public func get(testCount id:String) -> Int {
		do {
			let test = try self.get(response: id)
			return test.sections.count
		} catch {
			fatalError(error.localizedDescription)
		}
	}
    
    public func get(selectedResponse index:Int, responseData:Int, id:String, questionIndex:Int, gridType:GridTestController.GridType) -> Bool {
        let coord = coordinate(for: index, section: questionIndex, gridType: gridType)
        let x = coord.0
        let y = coord.1
        do {
            var test = try get(response: id)
            guard questionIndex < test.sections.count else {
                fatalError("Invalid question index: \(questionIndex)")
                
            }
            
            let timeSinceStart = try get(timeSinceStart: id)
            let choice = GridTestResponse.Section.Choice(x: x,
                                                         y: y,
                                            selection_time: timeSinceStart,
                                            selection: responseData)
            
            let set = Set<GridTestResponse.Section.Choice> (test.sections[questionIndex].choices)
            if set.contains(choice) {
                return true
            } else {
                return false
            }
        } catch {
            fatalError(error.localizedDescription)
        }
        
    }
    
    public func get(selectedData index:Int, id:String, questionIndex:Int, gridType:GridTestController.GridType) -> GridTestResponse.Section.Choice? {
        let coord = coordinate(for: index, section: questionIndex, gridType: gridType)
        let x = coord.0
        let y = coord.1
        do {
            let test = try get(response: id)
            guard questionIndex < test.sections.count else {
                fatalError("Invalid question index: \(questionIndex)")
                
            }
            
            //let timeSinceStart = try get(timeSinceStart: id)
//            let choice = GridTestResponse.Section.Choice(x: x,
//                                                         y: y,
//                                            selection_time: timeSinceStart
//                                            )
            
            let set = Set<GridTestResponse.Section.Choice> (test.sections[questionIndex].choices)
            
                return set.first{ $0.x == x && $0.y == y}
             
        } catch {
            fatalError(error.localizedDescription)
        }
        
    }
    
    //update a response
	public func set(symbols id:String, gridTests:[GridTest]) -> GridTestResponse {
		do {
			for (index, test) in gridTests.enumerated() {
				_ = try set(symbols: id, gridTest: test, questionIndex:index)
			}
			return try get(response: id)
		} catch {
			fatalError(error.localizedDescription)
		}
	}
	
    private func set(symbols id:String, gridTest:GridTest, questionIndex:Int) throws -> GridTestResponse {
        var test = try get(response: id)
		
        for symbol in gridTest.imageGrid.symbols {
            test.sections[questionIndex].images.append(GridTestResponse.Section.Image(x: symbol.x,
                                                                                      y: symbol.y,
                                                                                      image: symbols[symbol.symbol]))
            
        }
        return save(id: id, obj: test)
    }
    
   
    public func markTime(gridDisplayedTestGrid id:String, questionIndex:Int) -> GridTestResponse? {
        do {
            
            var response = try get(response: id)
            let startDate = try get(testStartTime: id)
            response.sections[questionIndex].display_test_grid = Date().timeIntervalSince(startDate)

            return save(id: id, obj: response)

        } catch {
            
            delegate?.didCatch(errors: error)
        }
        return nil
    }
    
    public func markTime(gridDisplayedSymbols id:String, questionIndex:Int) -> GridTestResponse? {
        do {

            var response = try get(response: id)
            let startDate = try get(testStartTime: id)
            response.sections[questionIndex].display_symbols = Date().timeIntervalSince(startDate)
            
            return save(id: id, obj: response)

        } catch {
            delegate?.didCatch(errors: error)

        }
        return nil
        
    }
    
    public func markTime(gridDisplayedFs id:String, questionIndex:Int) -> GridTestResponse? {
        do {
        var test = try get(response: id)
        let startDate = try get(testStartTime: id)

        
        test.sections[questionIndex].display_distraction = Date().timeIntervalSince(startDate)
        return save(id: id, obj: test)
        } catch {
            delegate?.didCatch(errors: error)
        }
        
        return nil
    }
    
    public func update(fCountSteps: Int, testIndex:Int, id:String) -> GridTestResponse {
        do {
            var test = try get(response: id)
            guard testIndex < test.sections.count else {
                fatalError("Invalid question index: \(testIndex)")
                
            }
            test.sections[testIndex].f_count += fCountSteps
           
            return save(id: id, obj: test)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    public func update(eCountSteps: Int, testIndex:Int, id:String) -> GridTestResponse? {
        do {
            var test = try get(response: id)
            guard testIndex < test.sections.count else {
                fatalError("Invalid question index: \(testIndex)")
                
            }
            test.sections[testIndex].e_count += eCountSteps
            
            return save(id: id, obj: test)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func unsetValue(responseIndex index:Int, questionIndex:Int, gridType:GridTestController.GridType, id:String) -> GridTestResponse {
        let coord = coordinate(for: index, section: questionIndex, gridType: gridType)
        let x = coord.0
        let y = coord.1
        do {
            var test = try get(response: id)
            guard questionIndex < test.sections.count else {
                fatalError("Invalid question index: \(questionIndex)")

            }
            
            let timeSinceStart = try get(timeSinceStart: id)
            let choice = GridTestResponse.Section.Choice(x: x,
                                                         y: y,
                                                         selection_time: timeSinceStart, selection: nil)
            
            var set = Set<GridTestResponse.Section.Choice> (test.sections[questionIndex].choices)
            if set.contains(choice) {
                set.remove(choice)
                test.sections[questionIndex].choices = set.sorted()

            }
            
            return save(id: id, obj: test)
        } catch {
            fatalError(error.localizedDescription)
        }
        
    }
    public func setValue(responseIndex index:Int, responseData: Int?, questionIndex:Int, gridType:GridTestController.GridType, time:Date, confirm_time:Date? = nil, id:String) -> GridTestResponse {
        let coord = coordinate(for: index, section: questionIndex, gridType: gridType)
        let x = coord.0
        let y = coord.1
        do {
            var test = try get(response: id)
            guard questionIndex < test.sections.count else {
                fatalError("Invalid question index: \(questionIndex)")
                
            }
            
            let startTime = try get(testStartTime: id)
            let timeSinceStart = time.timeIntervalSince(startTime)

            var choice = GridTestResponse.Section.Choice(x: x,
                                                         y: y,
                                                         selection_time: timeSinceStart,
                                                         selection: responseData)

            if let confirmTimeSinceStart = confirm_time?.timeIntervalSince(startTime) {
                choice = GridTestResponse.Section.Choice(x: x,
                                                             y: y,
                                                             grid_selection_time: timeSinceStart,
                                                             image_selection_time: confirmTimeSinceStart,
                                                             selection: responseData)
            }
            
            var set = Set<GridTestResponse.Section.Choice> (test.sections[questionIndex].choices)
            if responseData != nil, let repeated = set.filter({$0.selection == responseData}).first {
                if repeated.selection == choice.selection
                {
                    set.remove(repeated)
                }
            }
            if set.contains(choice) {
                set.remove(choice)
                set.insert(choice)
            }else {
                set.insert(choice)
            }
            test.sections[questionIndex].choices = set.sorted()
            return save(id: id, obj: test)
        } catch {
            fatalError(error.localizedDescription)
        }
        
    }
    
}
