import Foundation

class AppSettingsDelegate : NSObject {
    func openAppSettings(result: @escaping FlutterResult) async {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            await UIApplication.shared.open(url)
        }
        
        result(nil)
    }
}
