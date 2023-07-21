//
//  AppDelegate.swift
//  ProdSuit
//
//  Created by MacBook on 13/02/23.
//

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces
import BackgroundTasks
import CoreLocation
import Combine



@main
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {


    let vc = UIViewController()
    var locationServiceVm : LocationFetchViewModel?
    lazy var bgCancellable = Set<AnyCancellable>()
    lazy var fgCancellable = Set<AnyCancellable>()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
       
        
        GMSServices.provideAPIKey(googleMapKey)
        
        GMSPlacesClient.provideAPIKey(googleMapKey)
        
        self.locationServiceVm  = LocationFetchViewModel(service: DeviceLocationService.Shared)
        backGroundPublisher.sink { status in
            print("app in \(status)")
            if status == "inactive"{
                self.locationUpdateion()
                
            }
            
        }.store(in: &bgCancellable)
        
        foreGroundPublisher.sink { status in
            print("app in \(status)")
            if status == "active"{
                self.locationUpdateion()
            }
          
        }.store(in: &fgCancellable)
          
        
        
        return true
    }
    
    
    func locationUpdateion(){
       
        let delay  = preference.User_module_LOCATION_INTERVAL
        
        DispatchQueue.global(qos: .background).async{
            self.locationServiceVm?.locationCoordinateUpdates(vc: self.vc, { location in
                self.locationServiceVm?.getAddress(location: (location.latitude,location.longitude), handler: { location_details in
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        let locationAddress = location_details
                        
                        punch_loc_coordinate = (location.latitude,location.longitude)
                        punch_address = locationAddress
                        
                        //print("location_details:\(location_details) === \(punch_loc_coordinate)")
                    }
                    
                })
            })
        }
    }
   

    // MARK: UISceneSession Lifecycle
    
    func applicationDidEnterBackground(_ application: UIApplication) {
//        bgTask = application.beginBackgroundTask(withName:"com.backgroundtask", expirationHandler: {() -> Void in
//                // Do something to stop our background task or the app will be killed
//                application.endBackgroundTask(self.bgTask)
//                self.bgTask = UIBackgroundTaskIdentifier.invalid
//            })
//
//        DispatchQueue.global(qos: .background).async {
//               //make your API call here
//               print("hello")
//           }
//           // Perform your background task here
//           print("The task has started")
    }
    
    

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ProdSuit")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

