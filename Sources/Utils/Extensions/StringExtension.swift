//
//  StringExtension.swift
//  modulegen
//

extension String {
    
    func replaceTemplateSubstrings(fileNamePrefix: String, moduleName: String) -> String {
        let camelCaseFileName = fileNamePrefix.prefix(1).lowercased() + fileNamePrefix.dropFirst()
        
        return replacingOccurrences(
            of: TemplateSubstring.fileName.rawValue,
            with: fileNamePrefix
        )
        .replacingOccurrences(
            of: TemplateSubstring.fileNameCamelCase.rawValue,
            with: camelCaseFileName
        )
        .replacingOccurrences(
            of: TemplateSubstring.moduleName.rawValue,
            with: moduleName
        )
    }
    
    var black: String {
        return colored(.black)
    }

    var red: String {
        return colored(.red)
    }

    var green: String {
        return colored(.green)
    }

    var yellow: String {
        return colored(.yellow)
    }

    var blue: String {
        return colored(.blue)
    }

    var magenta: String {
        return colored(.magenta)
    }

    var cyan: String {
        return colored(.cyan)
    }

    var white: String {
        return colored(.white)
    }
    
    func colored(_ color: ANSIColor) -> String {
        return color + self + ANSIColor.default
    }
}
