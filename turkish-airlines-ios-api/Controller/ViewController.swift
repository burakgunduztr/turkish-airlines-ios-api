//
//  ViewController.swift
//  turkish-airlines-ios-api
//
//  Created by Burak Gunduz on 7.01.2018.
//  Copyright © 2018 unofficial. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    var portIATAs = [String]()
    var IsDomestics = [Int]()
    var countryNames = [String]()
    
    var portDictionary = [String: AnyObject]()
    var allPorts = [Port]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get all port list from TK Airlines Developer Portal
        getPortList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Get Port List
    
    func getPortList() {
        
        portIATAs.removeAll(keepingCapacity: false)
        IsDomestics.removeAll(keepingCapacity: false)
        self.allPorts.removeAll(keepingCapacity: false)
        
        retrievePortList { (success: Bool) in
            
            if success {
                
                self.portDictionary.removeAll(keepingCapacity: false)
                
                print("Returned: portIATAs")
                print(self.portIATAs.count)
                print(self.portIATAs)
                
                print("Returned: IsDomestics")
                print(self.IsDomestics.count)
                print(self.IsDomestics)
                
                for (i, iata) in self.portIATAs.enumerated() {
                    
                    self.portDictionary["isDomestic"] = self.IsDomestics[i] as AnyObject
                    self.allPorts.append(Port(iata: iata, dictionary: self.portDictionary))
                    
                }
                
            }
        }
    }
    
    func retrievePortList(_ completion: @escaping (Bool) -> ()){
        
        let headers: HTTPHeaders = [
            "apikey": API_KEY,
            "apisecret": API_SECRET,
            "Accept": GET_PORT_LIST_ACCEPT_TYPE
        ]
        
        Alamofire.request(GET_PORT_LIST_URL, headers: headers)
            .responseJSON { response in
                // debugPrint(response)
                
                switch response.result {
                case .success(let data):
                    
                    let jsonDictionary = data as! [String : AnyObject]
                    
                    if let theJSONData = try? JSONSerialization.data(
                        withJSONObject: jsonDictionary,
                        options: []) {
                        
                        if let theJSONText = String(data: theJSONData, encoding: String.Encoding.isoLatin1)
                        {
                            if let dataFromString = theJSONText.data(using: String.Encoding.isoLatin1, allowLossyConversion: false) {
                                
                                do {
                                    let json = try JSON(data: dataFromString)
                                    
                                    let portCodes = json["data"]["Port"].arrayValue.map({$0["Code"].stringValue})
                                    // let IsSPAs = json["data"]["Port"].arrayValue.map({$0["IsSPA"].stringValue})
                                    let IsDomestics = json["data"]["Port"].arrayValue.map({$0["IsDomestic"].intValue})
                                    // let portNames = json["data"]["Port"].arrayValue.map({$0["LanguageInfo"]["Language"]["Name"].stringValue})
                                    // let countryNames = json["data"]["Port"].arrayValue.map({$0["Country"]["LanguageInfo"]["Language"]["Name"].stringValue})
                                    // let countryCodes = json["data"]["Port"].arrayValue.map({$0["Country"]["Code"].stringValue})
                                    // let regionNames = json["data"]["Port"].arrayValue.map({$0["Region"]["LanguageInfo"]["Language"]["Name"].stringValue})
                                    // let latitudePoints = json["data"]["Port"].arrayValue.map({$0["Coordinate"]["latitude"].stringValue})
                                    // let longitudePoints = json["data"]["Port"].arrayValue.map({$0["Coordinate"]["longitude"].stringValue})
                                    
                                    self.portIATAs = portCodes
                                    self.IsDomestics = IsDomestics
                                    
                                    completion(true)
                                    
                                } catch {
                                    print(error)
                                    completion(false)
                                }
                            }
                        }
                    }
                    break
                    
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
}

