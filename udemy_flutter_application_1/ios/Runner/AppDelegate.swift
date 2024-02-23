import UIKit
import Foundation
import Flutter

struct City: Codable {
    let id: String
    let name: String
    let state: String
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    let jsonString = """
    [
      {
        "id": "1",
        "name": "Mumbai",
        "state": "Maharashtra"
      },
      {
        "id": "2",
        "name": "Delhi",
        "state": "Delhi"
      },
      {
        "id": "3",
        "name": "Bengaluru",
        "state": "Karnataka"
      },
      {
        "id": "4",
        "name": "Ahmedabad",
        "state": "Gujarat"
      },
      {
        "id": "5",
        "name": "Hyderabad",
        "state": "Telangana"
      },
      {
        "id": "6",
        "name": "Chennai",
        "state": "Tamil Nadu"
      },
      {
        "id": "7",
        "name": "Kolkata",
        "state": "West Bengal"
      },
      {
        "id": "8",
        "name": "Pune",
        "state": "Maharashtra"
      },
      {
        "id": "9",
        "name": "Jaipur",
        "state": "Rajasthan"
      },
      {
        "id": "10",
        "name": "Surat",
        "state": "Gujarat"
      },
      {
        "id": "11",
        "name": "Lucknow",
        "state": "Uttar Pradesh"
      },
      {
        "id": "12",
        "name": "Kanpur",
        "state": "Uttar Pradesh"
      },
      {
        "id": "13",
        "name": "Nagpur",
        "state": "Maharashtra"
      },
      {
        "id": "14",
        "name": "Patna",
        "state": "Bihar"
      },
      {
        "id": "15",
        "name": "Indore",
        "state": "Madhya Pradesh"
      },
      {
        "id": "16",
        "name": "Thane",
        "state": "Maharashtra"
      },
      {
        "id": "17",
        "name": "Bhopal",
        "state": "Madhya Pradesh"
      },
      {
        "id": "18",
        "name": "Visakhapatnam",
        "state": "Andhra Pradesh"
      }
    ]
"""
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // 1
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        // 2
        let deviceChannel = FlutterMethodChannel(name: "com.example.platform_channel_in_flutter/Udemy Flutter Application 1",
                                                 binaryMessenger: controller.binaryMessenger)
        
        // 3
        prepareMethodHandler(deviceChannel: deviceChannel)
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func prepareMethodHandler(deviceChannel: FlutterMethodChannel) {
        
        // 4
        deviceChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            
            // 5
            if call.method == "getDeviceModel" {
                
                // 6
                self.receiveDeviceModel(result: result)
            }
            else if call.method ==  "getCityData"  {
                self.getCityData(result: result)
                
            } else if call.method == "getStateFromCity"  {
                self.getStateFromCity(result: result, cityName: String(describing: call.arguments.unsafelyUnwrapped))
            } else {
                // 9
                result(FlutterMethodNotImplemented)
                return
            }
            
        })
    }
    
    private func receiveDeviceModel(result: FlutterResult) {
        // 7
        let deviceModel = UIDevice.current.name
        
        // 8
        result(deviceModel)
    }
    
    private func getCityData(result: FlutterResult) {
        var tempList: [String] = []
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                let cities = try JSONDecoder().decode([City].self, from: jsonData)
                for city in cities {
                    print("City: \(city.name), State: \(city.state)")
                    tempList.append(city.name)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        } else {
            print("Failed to convert JSON string to data.")
        }
        result(tempList)
    }
    
    private func getStateFromCity(result: FlutterResult, cityName: String?){
        let unwrappedString = cityName ?? ""
        print(unwrappedString)
        var tempString: String = ""
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                let cities = try JSONDecoder().decode([City].self, from: jsonData)
                for city in cities {
                    if unwrappedString == city.name {
                        
                        tempString = city.state
                        break
                    }
                    
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        } else {
            print("Failed to convert JSON string to data.")
        }
        result(tempString)
    }
}
