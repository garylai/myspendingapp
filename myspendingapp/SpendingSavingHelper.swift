//
//  SpendingSavingHelper.swift
//  myspendingapp
//
//  Created by GaryLai on 18/11/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

internal class SpendingSavingHelper {
    private let _spendingDict : [NSDate: [Spending]];
    private let _dateOrder : [NSDate];
    private var _currentSpendings : [Spending]!;
    private var _currentDateIndex : Int = 0;
    private var _currentSpendingIndex : Int = -1;
    private var _completeCallback : ([[Bool]] -> Void)?;
    private var _results : [[Bool]];
    private let _requestmanager : EasyRequest;
    
    private var _saving : Bool = false;
    private let _lock : NSLock = NSLock();
    private var _token : String!;
    
    init?(spendingDict: [NSDate : [Spending]],
            dateOrder: [NSDate],
        requestManager: EasyRequest = Util.instance){
                _requestmanager = requestManager;
                _spendingDict = spendingDict;
                _dateOrder = dateOrder;
                _results = [[Bool]]();
                guard _dateOrder.count > 0 && _dateOrder.count == _spendingDict.count else {
                    return nil;
                }
                for d in _dateOrder {
                    guard _spendingDict[d] != nil else {
                        return nil;
                    }
                }
                for _ in 0..<_dateOrder.count {
                    _results.append([Bool]());
                }
                _currentSpendings = spendingDict[_dateOrder.first!];
    }
    
    private func saveNext() {
        _currentSpendingIndex++;
        print("saveNext: ", _dateOrder[_currentDateIndex], _currentSpendingIndex);
        if _currentSpendingIndex > _currentSpendings.count - 1 {
            _currentSpendingIndex = -1;
            _currentDateIndex++;
            print("trying to go to the next day");
            if _currentDateIndex > _dateOrder.count - 1 {
                self._lock.lock();
                self._saving = false;
                self._lock.unlock();
                dispatch_async(dispatch_get_main_queue(), {
                    self._completeCallback!(self._results);
                })
                return;
            }
            _currentSpendings = _spendingDict[_dateOrder[_currentDateIndex]]!;
            saveNext();
            return;
        }
        let spending = _currentSpendings[_currentSpendingIndex];
        let dict = Mapper().toJSON(spending);
        print(dict);
        //        _requestmanager.requestWithCallbacks(
        Util.instance.makeRequest(
            "POST",
            "spending",
            parameters: Mapper().toJSON(spending),
            customHeaders: ["Authorization": "Token token=\(_token!)"],
            successCallback: { (_) -> Void in
                self._results[self._currentDateIndex].append(true);
            }, failedCallback: { (_, _) -> Void in
                self._results[self._currentDateIndex].append(false);
            }, completedCallback: {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    self.saveNext();
                };
        });
    }
    
    func startSaving(completeCallback : ([[Bool]] -> Void)) -> Bool {
        _lock.lock();
        guard !_saving else {
            _lock.unlock();
            return false;
        }
        _token = Util.instance.getLoginInfo()?.token;
        guard _token != nil else {
            _lock.unlock();
            return false;
        }
        _saving = true;
        _lock.unlock();
        
        _completeCallback = completeCallback;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.saveNext();
        };
        
        return true;
    }
}