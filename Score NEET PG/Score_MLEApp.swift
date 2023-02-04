//
//  Score_MLEApp.swift
//  Score MLE
//
//  Created by ios on 28/07/22.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import AWSCognitoIdentityProvider


class AppDelegate: NSObject, UIApplicationDelegate {
    
    static var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        getUserDetails()
        FirebaseApp.configure()
        initializeS3()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass device token to auth
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
        
        // Further handling of the device token if needed by the app
        // ...
    }
    
    //Needed for firebase Phone Authentication
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
    
    
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    
    
    
    func initializeS3() {
        /*
         AWS S3 Bucket details
         POOL_ID = "ap-south-1:77385015-990a-4e12-bdb3-ea247eaa750d"
         MY_REGION = Regions.AP_SOUTH_1
         BUCKET_NAME = "incusquiz"
         */
        
        let poolId = "ap-south-1:77385015-990a-4e12-bdb3-ea247eaa750d"
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType: .APSouth1, //other regionType according to your location.
            identityPoolId: poolId
        )
        let configuration = AWSServiceConfiguration(region: .APSouth1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    
    
    
    func getUserDetails() {
        
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        
        NetworkManager.shared.getUser(mobileNumber: phoneNumber) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    UserSession.userSessionInstance.setSubscriptionExpiry(expiryDate: data.paymentExpiryDate ?? "")
                    if let staff = data.is_staff {
                        withAnimation {
                            isStaff = staff
                        }
                    }
                    
                    if data.paid == true {
                        paymentStatus = true
                    } else {
                        
                        if UserSession.userSessionInstance.getSubscriptionStatus() {
                            paymentStatus = true
                        } else {
                            paymentStatus = false
                        }
                    }
                }
            case .failure(let error):
                print("failure \(error.localizedDescription)")
            }
        }
        
    }
    
    
    
}





@main
struct Score_MLEApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authentication = Authentication()
   // @Environment(\.scenePhase) var scenePhase
    
    @ObservedObject var gtQuestionVM: GtQuizViewModel = GtQuizViewModel()
    
    var body: some Scene {
        WindowGroup {
            if authentication.isValidated || UserSession.userSessionInstance.isLoggedIn() {
//                MainView()
//                    .environmentObject(authentication)
                TabBarScreen(currentTab: .mocktest)
                    .environmentObject(authentication)
            } else {
                OnboardScreen()
                    .environmentObject(authentication)
            }
            
        }
//        .onChange(of: scenePhase) { newPhase in
//            if newPhase == .inactive {
//                print("inactive")
//            } else if newPhase == .active {
//                print("active")
//            } else if newPhase == .background {
//                print("background")
//            }
//        }
    }
}
