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
        } else if call.method == "share" {
            if let arguments = call.arguments as? [String: Any] {
                let type = arguments["type"] as? String ?? "ShareType.more"
                var shareImage: UIImage?
                if let imgData = (arguments["image"] as? FlutterStandardTypedData)?.data {
                    shareImage = UIImage(data: imgData)
                }
                let shareText = arguments["caption"] as? String ?? ""
                switch type {
                case "ShareType.facebook":
                    shareFacebook(withImage: shareImage, caption: shareText)
                    break
                case "ShareType.instagram":
                    shareInstagram(withImage: shareImage, caption: shareText)
                    break
                case "ShareType.more":
                    openShareSheet(withImage: shareImage, caption: shareText)
                    break
                default:
                    break
                }
            }
        }
    }
    
    private func shareFacebook(withImage image: UIImage?, caption: String) {
        DispatchQueue.main.async {
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
        }
    }
    
    private func shareInstagram(withImage image: UIImage?, caption: String) {
        DispatchQueue.main.async {
            var shareURL = ""
            var assetID: String = ""
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetChangeRequest.creationRequestForAsset(from: image!)
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
        }
    }
    
    private func openShareSheet(withImage image: UIImage?, caption: String) {
        if let flutterAppDelegate = UIApplication.shared.delegate as? FlutterAppDelegate {
            let activityVC = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo, UIActivityType.assignToContact, UIActivityType.airDrop]
            flutterAppDelegate.window.rootViewController?.present(activityVC, animated: true, completion: {
                self.result?("Success")
            })
        }
    }
}
