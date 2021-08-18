import Foundation
import YogaUI

class HListCellViewModel: CellViewModel {
    override init() {
        super.init()
        
        childs {
            ScrollViewModel { config in
                config.backgroundColor = .lightGray
            }
            .layout {
                $0.flexDirection = .row
            }
            .childs {
                for i in 0...10 {
                    SimpleViewModel()
                        .configure {
                            $0.backgroundColor = .blue
                        }
                        .layout {
                            $0.width = 100
                            $0.height = 100
                            $0.margin = 12
                            $0.alignItems = .center
                            $0.justifyContent = .center
                        }
                        .childs {
                            TextViewModel("\(i)")
                        }
                }
            }
        }
    }
}
