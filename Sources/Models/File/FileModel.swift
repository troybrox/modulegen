//
//  FileModel.swift
//  modulegen
//

import Foundation

struct FileModel: Codable {
    
    let name: String?
    let fileExtension: FileExtension
    let type: FileType
    
    private enum CodingKeys: String, CodingKey {
        case name, type
        case fileExtension = "extension"
    }
    
    init() {
        name = nil
        fileExtension = .swift
        type = .swiftFile
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String?.self, forKey: .name)
        fileExtension = try container.decode(FileExtension.self, forKey: .fileExtension)
        type = try container.decode(FileType.self, forKey: .type)
    }

    private func getData(meta: Any) -> Data? {
        return try? JSONSerialization.data(withJSONObject: meta, options: .prettyPrinted)
    }
}
