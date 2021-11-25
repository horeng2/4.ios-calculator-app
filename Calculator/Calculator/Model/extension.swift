import Foundation

extension Double: CalculateItem {
    
}

extension String {
    func split(with target: Character) -> [String] {
        let splitedString = self.split(separator: target).map { String($0) }
        return splitedString
    }
    
    func insertComma() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.roundingMode = .halfUp
        
        let splitByDecimalPoint = self.split(with: ".")
        guard let dobleTypeInteger = Double(splitByDecimalPoint[0]),
              let integerWithComma = numberFormatter.string(from: NSNumber(value: dobleTypeInteger)) else {
            return ""
        }
        
        let valueWithComma: String
        if self.last == "." {
            valueWithComma = integerWithComma + "."
        } else if self.contains(".") && splitByDecimalPoint.count == 2 {
            let decimalValue = splitByDecimalPoint[1]
                valueWithComma = integerWithComma + "." + decimalValue
        } else {
            valueWithComma = integerWithComma
        }
        return valueWithComma
    }
    
    func hasDecimalPoint() -> Bool {
        self.contains(".")
    }
}

extension Array {
    func hasDecimalPoint() -> Bool {
        (self.filter { ($0 as? String) == "."
        }).count == 0 ? false : true
    }
}
