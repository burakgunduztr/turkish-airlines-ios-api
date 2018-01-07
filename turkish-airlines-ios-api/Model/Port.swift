//
//  Model.swift
//  turkish-airlines-ios-api
//
//  Created by Burak Gunduz on 7.01.2018.
//  Copyright © 2018 unofficial. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Port: NSObject, NSCoding {
    
    fileprivate var _iata: String?
    fileprivate var _isDomestic: Bool?
    fileprivate var _portName: String?
    fileprivate var _stateName: String?
    fileprivate var _countryName: String?
    
    var iata: String? {
        return _iata
    }
    
    var isDomestic: Bool? {
        return _isDomestic
    }
    
    var portName: String? {
        return _portName
    }
    
    var stateName: String? {
        return _stateName
    }
    
    var countryName: String? {
        return _countryName
    }
    
    required init(coder aDecoder: NSCoder) {
        // super.init()
        
        if let iata = aDecoder.decodeObject(forKey: "_iata") as? String {
            self._iata = iata
        }
        
        if let isDomestic = aDecoder.decodeObject(forKey: "_isDomestic") as? Bool {
            self._isDomestic = isDomestic
        }
        
        if let portName = aDecoder.decodeObject(forKey: "_portName") as? String {
            self._portName = portName
        }
        
        if let stateName = aDecoder.decodeObject(forKey: "_stateName") as? String {
            self._stateName = stateName
        }
        
        if let countryName = aDecoder.decodeObject(forKey: "_countryName") as? String {
            self._countryName = countryName
        }
    }
    
    func encode(with aCoder: NSCoder) {
        
        if let portName = self._portName {
            aCoder.encode(portName, forKey: "_portName")
        }
        
        if let isDomestic = self._isDomestic {
            aCoder.encode(isDomestic, forKey: "_isDomestic")
        }
        
        if let portName = self._portName {
            aCoder.encode(portName, forKey: "_portName")
        }
        
        if let stateName = self._stateName {
            aCoder.encode(stateName, forKey: "_stateName")
        }
        
        if let countryName = self._countryName {
            aCoder.encode(countryName, forKey: "_countryName")
        }
    }
    
    init(iata: String, dictionary: [String: AnyObject]) {
        super.init()
        
        self._iata = iata
        
        if let isDomesticStatus = dictionary["isDomestic"] as? Int {
            
            if isDomesticStatus == 1 {
                
                self._isDomestic = true
                
            } else {
                
                self._isDomestic = false
                self._portName = nil
            }
        }
    }
}

