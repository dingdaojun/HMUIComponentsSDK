//
//  Data+Pay.swift
//  huamipay
//
//  Created by 余彪 on 2018/3/21.
//

import Foundation

struct ValidateRegex {
    let regex: NSRegularExpression?
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern,
                                         options: .caseInsensitive)
    }
    
    func match(input: String) -> Bool {
        if let matches = regex?.matches(in: input,
                                        options: [],
                                        range: NSMakeRange(0, (input as NSString).length)) {
            return matches.count > 0
        } else {
            return false
        }
    }
}

extension Data {
    public func toUInt32() -> UInt32 {
        return UInt32(bigEndian: self.withUnsafeBytes { $0.pointee })
    }
    
    public func validateRegex(_ regex: String) -> Bool {
        let matcher = ValidateRegex(regex)
        let respString = self.toHexString()
        guard matcher.match(input: respString) else { return false }
        return true
    }
}

extension Data {
    func countHexCombin() -> String {
        return "\(self.count.toRadix16())\(self.toHexString())"
    }
}

extension Data {
    // 删除9000
    mutating func remove9000() {
        guard self.count >= 2 else { return }
        return self.removeLast(2)
    }
    
    // 删除6310
    mutating func remove6310() {
        guard self.count >= 2 else { return }
        return self.removeLast(2)
    }
}
