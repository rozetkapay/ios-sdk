//
//  RequestSigner.swift
//  
//
//  Created by Ruslan Kasian Dev on 10.09.2024.
//

import Foundation
import CommonCrypto

enum RequestSignerError: Error {
    case encodingFailed
    case hmacFailed
}

protocol RequestSignerProtocol {
    func sign(key: String, data: Encodable) throws -> String
}

final class RequestSigner: RequestSignerProtocol {
    func sign(key: String, data: Encodable) throws -> String {
        guard let encodedData = try stringEncode(data) else {
            throw RequestSignerError.encodingFailed
        }

        guard let hmacResult = hmac(encodedData: encodedData, key: key) else {
            throw RequestSignerError.hmacFailed
        }

        return hmacResult
    }

    // MARK: - Encoding
    private func stringEncode<T: Encodable>(_ object: T) throws -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .withoutEscapingSlashes]

        let encodedData = try encoder.encode(object)
        let json = try JSONSerialization.jsonObject(with: encodedData)

        guard let dict = json as? [String: Any] else {
            throw RequestSignerError.encodingFailed
        }

        return dict.sorted { $0.key < $1.key }
            .map { _, value in
                return asStringValue(value)
            }
            .joined()
    }

    private func asStringValue(_ value: Any) -> String {
        switch value {
        case let array as [Any]:
            return array.map { asStringValue($0) }
                .sorted()
                .joined(separator: ",")
        case let dict as [String: Any]:
            return dict.sorted { $0.key < $1.key }
                .map { asStringValue($0.value) }
                .joined()
        case is NSNull:
            return ""
        case let number as NSNumber:
            return number.stringValue
        case let string as String:
            return string
        default:
            return "\(value)"
        }
    }

    // MARK: - HMAC
    private func hmac(encodedData: String, key: String) -> String? {
        guard let keyData = key.data(using: .utf8),
              let messageData = encodedData.data(using: .utf8) else {
            return nil
        }

        var hmacData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))

        hmacData.withUnsafeMutableBytes { hmacBytes in
            keyData.withUnsafeBytes { keyBytes in
                messageData.withUnsafeBytes { messageBytes in
                    CCHmac(
                        CCHmacAlgorithm(kCCHmacAlgSHA256),
                        keyBytes.baseAddress,
                        keyData.count,
                        messageBytes.baseAddress,
                        messageData.count,
                        hmacBytes.baseAddress
                    )
                }
            }
        }

        return hmacData.map { String(format: "%02x", $0) }.joined()
    }
}
