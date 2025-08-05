//
//  UIDeviceExtensions.swift
//
//
//  Created by Ruslan Kasian Dev on 18.08.2024.
//

import UIKit

extension UIDevice {
    
    private struct InterfaceNames {
        static let wifi = ["en0"]
        static let wired = ["en2", "en3", "en4"]
        static let cellular = ["pdp_ip0", "pdp_ip1", "pdp_ip2", "pdp_ip3"]
        static let supported = wifi + wired + cellular
    }
    
    func ipAddress() -> String? {
        var ipAddress: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        
        if getifaddrs(&ifaddr) == 0 {
            var pointer = ifaddr
            
            while pointer != nil {
                defer { pointer = pointer?.pointee.ifa_next }
                
                guard
                    let interface = pointer?.pointee,
                    interface.ifa_addr.pointee.sa_family == UInt8(AF_INET) || interface.ifa_addr.pointee.sa_family == UInt8(AF_INET6),
                    let interfaceName = interface.ifa_name,
                    let interfaceNameFormatted = String(cString: interfaceName, encoding: .utf8),
                    InterfaceNames.supported.contains(interfaceNameFormatted)
                    else { continue }
                
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                
                getnameinfo(interface.ifa_addr,
                            socklen_t(interface.ifa_addr.pointee.sa_len),
                            &hostname,
                            socklen_t(hostname.count),
                            nil,
                            socklen_t(0),
                            NI_NUMERICHOST)
                
                guard
                    let formattedIpAddress = String(cString: hostname, encoding: .utf8),
                    !formattedIpAddress.isEmpty
                    else { continue }
                
                ipAddress = formattedIpAddress
                break
            }
            
            freeifaddrs(ifaddr)
        }
        
        return ipAddress
    }
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String {
            #if os(iOS)
            switch identifier {
            // iPod
            case "iPod5,1": return "iPod Touch 5"
            case "iPod7,1": return "iPod Touch 6"
            case "iPod9,1": return "iPod Touch 7"
            
            // iPhone 4 Series
            case "iPhone3,1", "iPhone3,2", "iPhone3,3": return "iPhone 4"
            case "iPhone4,1": return "iPhone 4s"
            
            // iPhone 5 Series
            case "iPhone5,1", "iPhone5,2": return "iPhone 5"
            case "iPhone5,3", "iPhone5,4": return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2": return "iPhone 5s"
            
            // iPhone 6 Series
            case "iPhone7,2": return "iPhone 6"
            case "iPhone7,1": return "iPhone 6 Plus"
            case "iPhone8,1": return "iPhone 6s"
            case "iPhone8,2": return "iPhone 6s Plus"
            
            // iPhone 7 Series
            case "iPhone9,1", "iPhone9,3": return "iPhone 7"
            case "iPhone9,2", "iPhone9,4": return "iPhone 7 Plus"
            
            // iPhone SE Series
            case "iPhone8,4": return "iPhone SE"
            case "iPhone12,8": return "iPhone SE (2nd generation)"
            case "iPhone14,6": return "iPhone SE (3rd generation)"
            
            // iPhone 8 and X Series
            case "iPhone10,1", "iPhone10,4": return "iPhone 8"
            case "iPhone10,2", "iPhone10,5": return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6": return "iPhone X"
            
            // iPhone XS, XR, and 11 Series
            case "iPhone11,2": return "iPhone XS"
            case "iPhone11,4", "iPhone11,6": return "iPhone XS Max"
            case "iPhone11,8": return "iPhone XR"
            case "iPhone12,1": return "iPhone 11"
            case "iPhone12,3": return "iPhone 11 Pro"
            case "iPhone12,5": return "iPhone 11 Pro Max"
            
            // iPhone 12 Series
            case "iPhone13,1": return "iPhone 12 Mini"
            case "iPhone13,2": return "iPhone 12"
            case "iPhone13,3": return "iPhone 12 Pro"
            case "iPhone13,4": return "iPhone 12 Pro Max"
            
            // iPhone 13 Series
            case "iPhone14,4": return "iPhone 13 Mini"
            case "iPhone14,5": return "iPhone 13"
            case "iPhone14,2": return "iPhone 13 Pro"
            case "iPhone14,3": return "iPhone 13 Pro Max"
            
            // iPhone 14 Series
            case "iPhone14,7": return "iPhone 14"
            case "iPhone14,8": return "iPhone 14 Plus"
            case "iPhone15,2": return "iPhone 14 Pro"
            case "iPhone15,3": return "iPhone 14 Pro Max"
            
            // iPhone 15 Series
            case "iPhone15,4": return "iPhone 15"
            case "iPhone15,5": return "iPhone 15 Plus"
            case "iPhone16,1": return "iPhone 15 Pro"
            case "iPhone16,2": return "iPhone 15 Pro Max"
                
            // iPhone 16 Series
            case "iPhone17,1": return "iPhone 16 Pro"
            case "iPhone17,2": return "iPhone 16 Pro Max"
            case "iPhone17,3": return "iPhone 16"
            case "iPhone17,4": return "iPhone 16 Plus"
            case "iPhone17,5": return "iPhone 16e"
                
            // iPad
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3": return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6": return "iPad 4"
            case "iPad6,11", "iPad6,12": return "iPad 5"
            case "iPad7,5", "iPad7,6": return "iPad 6"
            case "iPad7,11", "iPad7,12": return "iPad 7"
            case "iPad11,6", "iPad11,7": return "iPad 8"
            case "iPad12,1", "iPad12,2": return "iPad 9"
            case "iPad13,18", "iPad13,19": return "iPad 10"

            // iPad Air
            case "iPad4,1", "iPad4,2", "iPad4,3": return "iPad Air"
            case "iPad5,3", "iPad5,4": return "iPad Air 2"
            case "iPad11,3", "iPad11,4": return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2": return "iPad Air (4th generation)"
            case "iPad13,16", "iPad13,17": return "iPad Air (5th generation)"
            
            // iPad Mini
            case "iPad2,5", "iPad2,6", "iPad2,7": return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6": return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9": return "iPad Mini 3"
            case "iPad5,1", "iPad5,2": return "iPad Mini 4"
            case "iPad11,1", "iPad11,2": return "iPad Mini (5th generation)"
            case "iPad14,1", "iPad14,2": return "iPad Mini (6th generation)"
            
            // iPad Pro
            case "iPad6,3", "iPad6,4": return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8": return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2": return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4": return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4": return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8": return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,9", "iPad8,10": return "iPad Pro (11-inch) (2nd generation)"
            case "iPad8,11", "iPad8,12": return "iPad Pro (12.9-inch) (4th generation)"
            case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7": return "iPad Pro (11-inch) (3rd generation)"
            case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11": return "iPad Pro (12.9-inch) (5th generation)"
            case "iPad14,3", "iPad14,4": return "iPad Pro (11-inch) (4th generation)"
            case "iPad14,5", "iPad14,6": return "iPad Pro (12.9-inch) (6th generation)"
            
            // Apple TV
            case "AppleTV5,3": return "Apple TV"
            case "AppleTV6,2": return "Apple TV 4K"
            case "AppleTV11,1": return "Apple TV 4K (2nd generation)"
            case "AppleTV12,1": return "Apple TV 4K (3rd generation)"
            
            // HomePod
            case "AudioAccessory1,1": return "HomePod"
            case "AudioAccessory1,2": return "HomePod"
            case "AudioAccessory5,1": return "HomePod Mini"
            
            // Simulator
            case "i386", "x86_64", "arm64":
                return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            
            // Default case
            default: return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()
    
    func screenSize() -> String {
        let screenBounds = UIScreen.main.bounds
        let screenScale = UIScreen.main.scale
        let screenSize = CGSize(
            width: screenBounds.size.width * screenScale,
            height: screenBounds.size.height * screenScale
        )
        
        return "\(screenSize)"
    }
    
    static let version: String = {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }()
    
    static let appName: String = {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "RozetkaPaySDK"
    }()
}
