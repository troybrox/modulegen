//
//  FileType.swift
//  modulegen
//

enum FileType: String, Codable {
    
    // TODO: rename view to uikitView
    
    case podspec
    case readme
    case replaceMe = "replace_me"
    
    case coordinatorProtocol = "coordinator_protocol"
    case controllerProtocol = "controller_protocol"
    case factory
    
    case assembly
    case controller
    case uikitView = "uikit_view"
    
    case swiftFile = "swift_file"
    
    case assemblySui = "assembly_sui"
    case assemblyNoVm = "assembly_no_vm"
    case assemblySuiNoVm = "assembly_sui_no_vm"
    
    case controllerSui = "controller_sui"
    case controllerNoVm = "controller_no_vm"
    case controllerSuiNoVm = "controller_sui_no_vm"
    
    case uikitViewSui = "uikit_view_sui"
    
    case suiView = "sui_view"
    case suiViewNoVm = "sui_view_no_vm"
}

extension FileType {
    
    var templateFileName: String {
        return rawValue
    }
    
    var fileNamePrefix: String? {
        switch self {
        case .suiView, .suiViewNoVm:
            "SUI"
        default:
            nil
        }
    }
    
    var fixedFileName: String? {
        switch self {
        case .readme:
            rawValue.uppercased()
        case .replaceMe:
            "ReplaceMe"
        default:
            nil
        }
    }
    
    var fileNamePostfix: String? {
        switch self {
        case .podspec:
            nil
        case .readme:
            nil
        case .replaceMe:
            nil
        case .coordinatorProtocol:
            "CoordinatorProtocol"
        case .controllerProtocol:
            "ViewControllerProtocol"
        case .factory:
            "ModuleFactory."
        case .assembly, .assemblySui, .assemblyNoVm, .assemblySuiNoVm:
            "Assembly"
        case .controller, .controllerSui, .controllerNoVm, .controllerSuiNoVm:
            "ViewController"
        case .uikitView, .uikitViewSui, .suiView, .suiViewNoVm:
            "View"
        case .swiftFile:
            ""
        }
    }
}
