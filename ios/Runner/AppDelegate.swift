import UIKit
import Flutter
import MindsSDK
import SwiftUI
import AVFAudio


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var sdk: MindsSDK?
    var navigationController: UINavigationController?
    var flutterResult: FlutterResult?
    
    override func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? ) -> Bool {
        
        let controller = window.rootViewController as! FlutterViewController
        let mindsChannel = FlutterMethodChannel(name: "digital.minds", binaryMessenger: controller.binaryMessenger)
        
        mindsChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            self?.flutterResult = result
            let args = call.arguments as? Dictionary<String, Any>
            
            switch(call.method){
            case "authentication", "enrollment":
                guard let args = call.arguments as? [String: Any],
                      let cpf = args["cpf"] as? String,
                      let token = args["token"] as? String,
                      let telephone = args["telephone"] as? String else {
                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required arguments", details: nil))
                    return
                }
                self?.startSDK(processType: call.method == "authentication" ? .authentication : .enrollment, cpf: cpf, token: token, telephone: telephone, externalId: nil, externalCustomerId: nil)
                
            default:
                result(FlutterMethodNotImplemented)
                return
            }
        })
        
        
        GeneratedPluginRegistrant.register(with: self)
        navigationController = UINavigationController(rootViewController: controller)
        navigationController?.navigationBar.isHidden = true
        window?.rootViewController = navigationController
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    private func startSDK(processType: MindsSDK.ProcessType, cpf: String, token: String, telephone: String, externalId: String?, externalCustomerId: String?) {
        guard let navigationController: UINavigationController = navigationController else { return }
        
        sdk = MindsSDK(delegate: self)
        sdk?.setToken(token)
        sdk?.setExternalId(externalId)
        sdk?.setExternalCustomerId(externalCustomerId)
        sdk?.setPhoneNumber(telephone)
        sdk?.setShowDetails(true)
        sdk?.setCpf(cpf)
        sdk?.setProcessType(processType)
        sdk?.setEnvironment(.sandbox)
        
        sdk?.initialize(on: navigationController) { error in
            if let error = error {
                do {
                    throw error
                } catch DomainError.invalidCPF(let message) {
                    print("\(message ?? "")")
                } catch {
                    print("\(error): \(error.localizedDescription)")
                }
                self.flutterResult?(FlutterError(code: "ERROR:", message: error.localizedDescription, details: nil))
            }
        }
    }
    
    private func biometricsReceive(_ response: BiometricResponse) {
        let json: [String: Any?] = [
            "success": response.success,
            "error": [
                "code": response.error?.code,
                "description": response.error?.description
            ],
            "id": response.id,
            "cpf": response.cpf,
            "external_id": response.externalID,
            "created_at": response.createdAt,
            "result": [
                "recommended_action": response.result?.recommendedAction as Any,
                "reasons": response.result?.reasons as Any
            ],
            "details": [
                "flag": [
                    "id": response.details?.flag?.id as Any ,
                    "type": response.details?.flag?.type as Any,
                    "description": response.details?.flag?.description as Any,
                    "status": response.details?.flag?.status as Any
                ],
                "voice_match": [
                    "result": response.details?.voiceMatch?.result as Any,
                    "confidence": response.details?.voiceMatch?.confidence as Any,
                    "status": response.details?.voiceMatch?.status as Any
                ]
            ]
        ]
        if let jsonData = try? JSONSerialization.data(withJSONObject: json),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
            flutterResult?(jsonString)
        }
    }
    
}

extension AppDelegate: MindsSDKDelegate {
    func showMicrophonePermissionPrompt() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            print("granted: \(granted)")
        }
    }
    
    func microphonePermissionNotGranted() {
        print("microphonePermissionNotGranted")
    }
    
    func onSuccess(_ response: BiometricResponse) {
        self.biometricsReceive(response)
    }
    
    func onError(_ response: BiometricResponse) {
        self.biometricsReceive(response)
    }
}
