import Foundation

class HListCellViewModel: CellViewModel {
    override init() {
        super.init()
        let scrollViewModel = ScrollViewModel { config in
            config.backgroundColor = .lightGray
        }
        
        for i in 0...10 {
            scrollViewModel.add {
                let squaredViewModel = SimpleViewModel()
                squaredViewModel.configuration.backgroundColor = .blue
                squaredViewModel.configureLayout { layout in
                    layout.width = 100
                    layout.height = 100
                    layout.margin = 12
                    layout.alignItems = .center
                    layout.justifyContent = .center
                }
                
                squaredViewModel.add {
                    let textViewModel = TextViewModel()
                    textViewModel.attributedText = NSAttributedString(string: "\(i)")
                    return textViewModel
                }
                
                return squaredViewModel
            }
        }
        
        scrollViewModel.configureLayout { layout in
            layout.flexDirection = .row
        }
        add(scrollViewModel)
    }
}
