//import SwiftUI
//
//enum Route: Hashable {
//    case sduiScreen(id: String)
//}
//
//class NavigationRouter: ObservableObject {
//    @Published var path = NavigationPath()
//    
//    func navigate(to route: Route) {
//        path.append(route)
//    }
//    
//    func goBack() {
//        if !path.isEmpty {
//            path.removeLast()
//        }
//    }
//    
//    func reset() {
//        path = NavigationPath()
//    }
//}
