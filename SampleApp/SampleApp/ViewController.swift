//
//  ViewController.swift
//  SampleApp
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

import UIKit
import Arc

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ArcAssessmentDelegate, ArcAssessmentNavigationDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellRows.allCases.count
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var signatureImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let customCell = self.tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.cellName, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        let row = CellRows(rawValue: indexPath.row)
        customCell.titleLabel.text = row?.title
        return customCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let row = CellRows(rawValue: indexPath.row)
        let stateList = row?.stateList ?? [.context]
                
        // This is supplemental information about this specific session
        // within the context of the study schedule
        // The only thing that is relevant, is that the sessionID controls
        // Which price test the user sees, so you should make it unique
        // to the session run, by specifying a random number,
        // or the index of the session within your schedule of coginitive sessions.
        let arcSupplementalInfo = ArcAssessmentSupplementalInfo(
            sessionID: Int64(Int.random(in: 0...1000)), sessionAvailableDate: Date(), weekInStudy: 0, dayInWeek: 0, sessionInDay: 0)
        
        ACState.totalTestCountInSession = (stateList.count > 1) ? 3 : 1
        if let sampleAppNavController = Arc.shared.appNavigation as? SampleAppNavigationController,
           let vc = sampleAppNavController.startTest(stateList: stateList, info: arcSupplementalInfo) {
            Arc.shared.delegate = self
            Arc.shared.navigationDelegate = self
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func assessmentComplete(result: ArcAssessmentResult?) {
        self.dismiss(animated: true, completion: {
            let signatureResults = result?.signatures
            if let firstSignatureData = signatureResults?.first?.data {
                self.signatureImageView?.image = UIImage(data: firstSignatureData)
            } else {
                self.signatureImageView?.image = nil
            }
            if let jsonResult = result?.fullTestSession?.tests.first?.data as? CognitiveTest,
               let jsonData = jsonResult.encode(outputFormatting: .prettyPrinted),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            }
        })
    }
    
    func onAssessmentSkipRequested() {
        self.dismiss(animated: true)
    }
    
    func onAssessmentCancelRequested() {
        self.dismiss(animated: true)
    }
}

enum CellRows: Int, CaseIterable {
    case contextSurvey = 0
    case wakeSurvey
    case chronotypeSurvey
    case symbolsTest
    case gridsTest
    case pricingTest
    case all
    
    var title: String {
        switch(self) {
        case .contextSurvey:
            return "Context Survey"
        case .wakeSurvey:
            return "Wake Survey"
        case .chronotypeSurvey:
            return "Chronotype Survey"
        case .symbolsTest:
            return "Symbols Test"
        case .gridsTest:
            return "Grids Test"
        case .pricingTest:
            return "Pricing Test"
        case .all:
            return "All Tests"
        }
    }
    
    var stateList: [SampleAppState] {
        switch(self) {
        case .contextSurvey:
            return [.signatureStart, .context, .signatureEnd]
        case .wakeSurvey:
            return [.wake]
        case .chronotypeSurvey:
            return [.chronotype]
        case .symbolsTest:
            return [.symbolsTest]
        case .gridsTest:
            return [.gridTest]
        case .pricingTest:
            return [.priceTest]
        case .all:
            return SampleAppState.fullTest
        }
    }
}

class CustomTableViewCell: UITableViewCell {
    static var cellName = "CustomTableViewCell"
    @IBOutlet weak var titleLabel: UILabel!
}
