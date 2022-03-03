import UIKit
import SwiftUI
import Combine

extension UIView {
    /**
     Convert UIKit `UIView` to `UIImage`
     
     - Parameter afterScreenUpdates: A `Bool` value that indicates whether the snapshot should be rendered after recent changes have been incorporated. Specify the value `false` if you want to render a snapshot in the view hierarchy’s current state, which might not include recent changes.
     
     - Returns: view's `UIImage` presentation
     */
    public func asImage(afterScreenUpdates: Bool = true) -> UIImage {
        let format = UIGraphicsImageRendererFormat.default()
        format.opaque = true
        format.scale = 1.0

        let renderer = UIGraphicsImageRendererProvider.getRenderer(bounds: bounds, format: format)
        return renderer.image { rendererContext in
            drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
        }
    }
}

public class UIGraphicsImageRendererProvider {
    public static var shared:UIGraphicsImageRenderer?
    
    public static func getRenderer(bounds: CGRect, format: UIGraphicsImageRendererFormat) -> UIGraphicsImageRenderer {
        if shared == nil {
            shared = UIGraphicsImageRenderer(bounds: bounds, format: format)
        }
        return shared!
    }
}

extension SwiftUI.View {
    /**
     Convert SwiftUI `View` to `UIImage`
     
     - Returns: future view's `UIImage` presentation
     */
    public func asImage() -> Future<UIImage, Never> {
        Future<UIImage, Never>() { promise in
            let uiView = self.placeUIView()
            
            DispatchQueue.main.async {
                let image = uiView.asImage()
                uiView.removeFromSuperview()
                
                promise(.success(image))
            }
        }
    }
}
