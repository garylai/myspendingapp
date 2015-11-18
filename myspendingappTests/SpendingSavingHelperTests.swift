//
//  SpendingSavingHelperTests.swift
//  SpendingSavingHelperTests
//
//  Created by GaryLai on 18/9/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Alamofire
@testable import myspendingapp

class ManagerStub : EasyRequest {
    private let _requestResults : [Bool];
    private var _current : Int = 0;
    init(requestResults: [Bool]) {
        _requestResults = requestResults;
    }
    
    func requestWithCallbacks (
        method: Alamofire.Method,
        _ relativePath: String,
        parameters: [String: AnyObject]? = nil,
        encoding: Alamofire.ParameterEncoding = .URL,
        headers: [String: String]? = nil,
        successCallback: ((AnyObject?) -> Void)? = nil,
        failedCallback: ((APIError?, String?) -> Void)? = nil,
        completedCallback: (() -> Void)? = nil)
        -> Alamofire.Request {
//            let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)));
//            dispatch_after(delay, dispatch_get_main_queue()) { () -> Void in
//            dispatch_async(dispatch_get_main_queue()){
                if self._requestResults[self._current++] {
                    print("call success");
                    successCallback?(nil);
                } else {
                    print("call failed");
                    failedCallback?(nil, nil);
                }
            print("call complete");
                completedCallback?();
//            }
            return Alamofire.request(method, relativePath);
    }
}

class SpendingSavingHelperTests: QuickSpec {
    override func spec() {
        describe("spending saving helper"){
            context("when saving"){
                it("should record and retuen the result"){
                    let dfParser = NSDateFormatter();
                    dfParser.dateFormat = "yyyy-MM-dd";
                    let d1 = dfParser.dateFromString("2015-11-25")!;
                    let d2 = dfParser.dateFromString("2015-11-26")!;
                    let d3 = dfParser.dateFromString("2015-11-27")!;
                    
                    let s1 = Spending();
                    let s2 = Spending();
                    let s3 = Spending();
                    let s4 = Spending();
                    let s5 = Spending();
                    let s6 = Spending();
                    
                    let spendingDict = [d1: [s1, s2], d2: [s3, s4, s5], d3: [s6]];
                    let dateOrder = [d3, d2, d1];
                    
                    let managerStub = ManagerStub(requestResults: [true, false, true, true, true, false]);
                    let helper = SpendingSavingHelper(spendingDict: spendingDict, dateOrder: dateOrder, requestManager: managerStub);
                    
                    waitUntil(timeout: 30) { done in
                        helper?.startSaving({ (results : [[Bool]]) -> Void in
                            expect(results).toNot(beNil());
                            expect(results).to(haveCount(3));
                            expect(results[0]).to(equal([true]));
                            expect(results[1]).to(equal([false, true, true]));
                            expect(results[2]).to(equal([true, false]));
                            done();
                        })
                    }
                }
            }
            context("when initializing"){
                context("when either spendingDict or dateOrder is empty"){
                    it("should return nil"){
                        let helper1 = SpendingSavingHelper(spendingDict: [NSDate: [Spending]](), dateOrder: [NSDate]());
                        let helper2 = SpendingSavingHelper(spendingDict: [NSDate: [Spending]](), dateOrder: [NSDate()]);
                        let helper3 = SpendingSavingHelper(spendingDict: [NSDate(): [Spending]()], dateOrder: [NSDate()]);
                        
                        expect(helper1).to(beNil());
                        expect(helper2).to(beNil());
                        expect(helper3).to(beNil());
                    }
                }
                context("when keys in spendingDict do not match the content in dateOrder"){
                    it("should return nil"){
                        let dfParser = NSDateFormatter();
                        dfParser.dateFormat = "yyyy-MM-dd";
                        let d1 = dfParser.dateFromString("2015-11-25")!;
                        let d2 = dfParser.dateFromString("2015-11-26")!;
                        let d3 = dfParser.dateFromString("2015-11-27")!;
                        let d4 = dfParser.dateFromString("2015-11-28")!;
                        
                        let helper1 = SpendingSavingHelper(spendingDict: [d1: [Spending](), d2: [Spending]()], dateOrder: [d1, d2, d3]);
                        let helper2 = SpendingSavingHelper(spendingDict: [d1: [Spending](), d2: [Spending](), d3: [Spending]()], dateOrder: [d1, d2]);
                        let helper3 = SpendingSavingHelper(spendingDict: [d1: [Spending](), d2: [Spending]()], dateOrder: [d3, d4]);
                        
                        expect(helper1).to(beNil());
                        expect(helper2).to(beNil());
                        expect(helper3).to(beNil());
                    }
                }
                context("when keys in spendingDict do match the content in dateOrder"){
                    it("should return an instance"){
                        let dfParser = NSDateFormatter();
                        dfParser.dateFormat = "yyyy-MM-dd";
                        let d1 = dfParser.dateFromString("2015-11-25")!;
                        let d2 = dfParser.dateFromString("2015-11-26")!;
                        
                        let helper1 = SpendingSavingHelper(spendingDict: [d1: [Spending](), d2: [Spending]()], dateOrder: [d1, d2]);
                        
                        expect(helper1).toNot(beNil());
                    }
                }
                
            }
        }
    }
}
