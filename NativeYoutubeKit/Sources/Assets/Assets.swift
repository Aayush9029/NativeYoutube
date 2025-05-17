import Foundation
import SwiftUI

public struct Assets {
    private init() {}
    
    public static let shared = Assets()
    
    // Access bundled assets
    public static var bundle: Bundle {
        return Bundle.module
    }
    
    // App Icon assets
    public struct AppIcon {
        public static var image: Image {
            Image("AppIconImage", bundle: Assets.bundle)
        }
    }
    
    // Color assets
    public struct Colors {
        public static var accent: Color {
            Color("AccentColor", bundle: Assets.bundle)
        }
    }
}