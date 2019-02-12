import Flutter
import UIKit
import FacebookShare
import FBSDKShareKit

public class SwiftFlutterShareSocialMediaPlugin: NSObject, FlutterPlugin {
    var result: FlutterResult?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_share_social_media", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterShareSocialMediaPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.result = result
        if call.method == "getPlatformVersion" {
            result("iOS " + UIDevice.current.systemVersion)
        } else if call.method == "shareFacebook" {
            shareFacebook(withParameter: call.arguments)
        }  else if call.method == "shareInstagram" {
            shareInstagram(withParameter: call.arguments)
        }
    }
    
    private func shareFacebook(withParameter parameter: Any?) {
        DispatchQueue.main.async {
            if let arguments = (parameter as? FlutterStandardTypedData)?.data, let image = UIImage(data: arguments) {
                func isFBInstalled() -> Bool {
                    var components = URLComponents()
                    components.scheme = "fbauth2"
                    components.path = "/"
                    return UIApplication.shared.canOpenURL(components.url!)
                }
                if isFBInstalled() {
                    let shareDialog = FBSDKShareDialog()
                    let fbPhoto = FBSDKSharePhoto(image: image, userGenerated: true)
                    let content = FBSDKSharePhotoContent()
                    content.photos = [fbPhoto as Any]
                    shareDialog.shareContent = content
                    
                    if let flutterAppDelegate = UIApplication.shared.delegate as? FlutterAppDelegate {
                        shareDialog.fromViewController = flutterAppDelegate.window.rootViewController
                        shareDialog.mode = .automatic
                        shareDialog.show()
                        self.result?("Success")
                    }
                } else {
                    self.result?("Cannot find facebook app")
                }
            } else {
                self.result?("Faild")
            }
        }
    }
    
    private func shareInstagram(withParameter parameter: Any?) {
        DispatchQueue.main.async {
            if let arguments = (parameter as? FlutterStandardTypedData)?.data, let image = UIImage(data: arguments) {
                var shareURL = ""
                var assetID: String = ""
                PHPhotoLibrary.shared().performChanges({
                    let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                    assetID = request.placeholderForCreatedAsset?.localIdentifier ?? ""
                    shareURL = "instagram://library?LocalIdentifier=\(assetID)"
                }) { (state, error) in
                    if error != nil {
                        self.result?(FlutterMethodNotImplemented)
                    } else {
                        if let urlForRedirect = URL(string: shareURL), UIApplication.shared.canOpenURL(urlForRedirect) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(urlForRedirect, options: [:], completionHandler: nil)
                                self.result?("Success")
                            } else {
                                // Fallback on earlier versions
                                self.result?("need to update")
                            }
                        } else {
                            self.result?("Cannot find instagram app")
                        }
                    }
                }
            } else {
                self.result?("Faild")
            }
        }
    }
}
