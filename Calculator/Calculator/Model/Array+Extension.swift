import Foundation

extension Array {
    func hasDecimalPoint() -> Bool {
        (self.filter { ($0 as? String) == "."
        }).count == 0 ? false : true
    }
}
