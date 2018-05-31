/**
 * Copyright IBM Corporation 2018
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import XCTest
import Foundation
import SpeechToTextV1

class WatsonTest: XCTestCase {
    
    /** Generate today's date. */
    func generateDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    /** Fail false negatives. */
    func failWithError(error: Error) {
        XCTFail("Positive test failed with error: \(error)")
    }
    
    /** Fail false positives. */
    func failWithResult<T>(result: T) {
        XCTFail("Negative test returned a result.")
    }
    
    /** Fail false positives. */
    func failWithResult() {
        XCTFail("Negative test returned a result.")
    }
    
    /** Wait for expectations. */
    func waitForExpectations(timeout: TimeInterval = 10.0) {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }
    
    // MARK: - Wait Functions
    
    func waitUntil(condition: () -> Bool) {
        let sleepTime: UInt32 = 5
        let maxRetries = 5
        for retry in 1 ... maxRetries {
            if !condition() && retry < maxRetries {
                sleep(sleepTime)
            } else {
                break
            }
        }
    }
    
    func waitUntil(_ languageModel: LanguageModel, is status: String) {
        waitUntil {
            var hasDesiredStatus = false
            let expectation = self.expectation(description: "getLanguageModel")
            let failure = { (error: Error) in if !error.localizedDescription.contains("locked") { XCTFail(error.localizedDescription) }}
            speechToText.getLanguageModel(customizationID: languageModel.customizationID, failure: failure) { model in
                hasDesiredStatus = (model.status == status)
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: timeout)
            return hasDesiredStatus
        }
    }
    
    func waitUntil(_ acousticModel: AcousticModel, is status: String) {
        waitUntil {
            var hasDesiredStatus = false
            let expectation = self.expectation(description: "getAcousticModel")
            let failure = { (error: Error) in if !error.localizedDescription.contains("locked") { XCTFail(error.localizedDescription) }}
            speechToText.getAcousticModel(customizationID: acousticModel.customizationID, failure: failure) { model in
                hasDesiredStatus = (model.status == status)
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: timeout)
            return hasDesiredStatus
        }
    }
    
    func waitUntil(_ corpus: String, is status: String, languageModel: LanguageModel) {
        waitUntil {
            var hasDesiredStatus = false
            let expectation = self.expectation(description: "getCorpus")
            let failure = { (error: Error) in if !error.localizedDescription.contains("locked") { XCTFail(error.localizedDescription) }}
            speechToText.getCorpus(customizationID: languageModel.customizationID, corpusName: corpus, failure: failure) { corpus in
                hasDesiredStatus = (corpus.status == status)
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: timeout)
            return hasDesiredStatus
        }
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
}
