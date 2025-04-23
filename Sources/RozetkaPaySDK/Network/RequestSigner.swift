//
//  RequestSigner.swift
//  
//
//  Created by Ruslan Kasian Dev on 10.09.2024.
//

import Foundation
import CommonCrypto

protocol RequestSignerProtocol {
    func sign(key: String, data: Encodable) throws -> String
}

final class RequestSigner: RequestSignerProtocol {
    func sign(key: String, data: Encodable) throws -> String {
        guard let encodedData = stringEncode(data) else {
            throw NSError(
                domain: "RequestSignerError",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Failed to encode data."]
            )
        }
        
        guard let hmacResult = hmac(encodedData: encodedData, key: key) else {
            throw NSError(
                domain: "RequestSignerError",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Failed to generate HMAC."]
            )
        }
        
        return hmacResult
    }

    private func stringEncode<T: Encodable>(_ object: T) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys 
        
        guard let encodedData = try? encoder.encode(object),
              let dictionary = try? JSONSerialization.jsonObject(with: encodedData, options: .allowFragments) as? [String: Any] else {
            return nil
        }

        return dictionary
            .sorted { $0.key < $1.key }
            .map { key, value in
                if let boolValue = value as? Bool {
                    return "\(boolValue)"
                }
                return "\(value)"
            }
            .joined(separator: "")
    }

    private func hmac(encodedData: String, key: String) -> String? {
        guard let keyData = key.data(using: .utf8), let messageData = encodedData.data(using: .utf8) else {
            return nil
        }
        
        var hmacData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        
        hmacData.withUnsafeMutableBytes { hmacBytes in
            keyData.withUnsafeBytes { keyBytes in
                messageData.withUnsafeBytes { messageBytes in
                    CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), keyBytes.baseAddress, keyData.count, messageBytes.baseAddress, messageData.count, hmacBytes.baseAddress)
                }
            }
        }
        
        return hmacData.map { String(format: "%02x", $0) }.joined()
    }
}

