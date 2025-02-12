//
//  Folder.swift
//  modulegen
//

import Foundation

struct Folder: Codable {
    
    let name: String?
    let folders: [Folder]
    let files: [FileModel]
    
    private enum CodingKeys: String, CodingKey {
        case name, folders, files
    }
    
    init() {
        name = nil
        folders = []
        files = []
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String?.self, forKey: .name)
        folders = try container.decode([Folder].self, forKey: .folders)
        files = try container.decode([FileModel].self, forKey: .files)
    }

    private func getData(meta: Any) -> Data? {
        return try? JSONSerialization.data(withJSONObject: meta, options: .prettyPrinted)
    }
}
