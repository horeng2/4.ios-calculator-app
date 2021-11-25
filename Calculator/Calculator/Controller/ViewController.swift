import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var formulaScrollView: UIScrollView!
    @IBOutlet var formulaStackView: UIStackView!
    @IBOutlet var currentOperatorLabel: UILabel!
    @IBOutlet var currentValueLabel: UILabel!
    
    private let initialValue = "0"
    private var calculaterTarget: [String] = []
    private var temporaryOperandValues: [String] = []
    private var isOperatorEntered: Bool = false
    private var signIsPositive: Bool = true
    var isCalculated: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentValueLabel.text = initialValue
    }
    
    @IBAction private func hitOperandButton(_ sender: UIButton) {
        guard let inputButtonTitle = sender.titleLabel?.text,
                  temporaryOperandValues.count < 20 else {
            return
        }
        let addcommaOperand: String
        
        if temporaryOperandValues.hasDecimalPoint() {
            guard inputButtonTitle != "." else {
                return
            }
        } else {
            if (inputButtonTitle == "0" && temporaryOperandValues.first == "0") ||
               (inputButtonTitle == "00" && temporaryOperandValues.first == "0") { return }
        }
        temporaryOperandValues.append(inputButtonTitle)
        addcommaOperand = temporaryOperandValues.joined().insertComma()

        if signIsPositive {
            currentValueLabel.text = addcommaOperand
        } else {
            currentValueLabel.text = "-" + addcommaOperand
        }
        isOperatorEntered = false
    }
    
    @IBAction private func hitOperatorButton(_ sender: UIButton) {
        guard let inputButtonTitle = sender.titleLabel?.text else {
            return
        }
        addOperandToCalculateTarget()
        resetTemporaryOperandValues()
        if isOperatorEntered {
            calculaterTarget.removeLast()
            calculaterTarget.append(inputButtonTitle)
        } else {
            calculaterTarget.append(inputButtonTitle)
            isOperatorEntered = true
        }
        currentOperatorLabel.text = inputButtonTitle
    }
    
    @IBAction private func hitACButton(_ sender: UIButton) {
        resetToInitialState()
        removeStackViewContents()
    }
    
    @IBAction private func hitCEButton(_ sender: UIButton) {
        resetTemporaryOperandValues()
        currentValueLabel.text = initialValue
    }
    
    @IBAction private func hitCodeConversionButton(_ sender: UIButton) {
        guard currentValueLabel.text != initialValue else {
            return
        }
        guard let currentOperand = currentValueLabel.text,
              let doubleTypeOperand = Double(currentOperand) else {
                  return
              }
        signIsPositive = !signIsPositive
        currentValueLabel.text = String(doubleTypeOperand * -1)
    }

    @IBAction private func hitEqualButton(_ sender: UIButton) {
        guard !calculaterTarget.isEmpty else {
               resetTemporaryOperandValues()
            return
        }
        addOperandToCalculateTarget()
        let calculator = ExpressionParser.self
        let doubleTypeResult = calculator.parse(from: calculaterTarget.joined()).result()
        
        if doubleTypeResult.isNaN {
            resetToInitialState()
            currentValueLabel.text = "NaN"
        } else {
            resetToInitialState()
            let insertedCommaResult = String(doubleTypeResult).insertComma()
            let intergerAndDecimal = insertedCommaResult.split(with: ".")
            
            currentValueLabel.text = (intergerAndDecimal.last == "0" ? intergerAndDecimal.first : insertedCommaResult)
        }
        isCalculated = true
    }
    
    private func addToFomulaHistory() {
        let stackView = UIStackView()
        stackView.spacing = 8.0
        stackView.axis = .horizontal
        
        let operatorView = UILabel()
        operatorView.text = currentOperatorLabel.text
        operatorView.textColor = .white
        
        let operandView = UILabel()
        operandView.text = currentValueLabel.text
        operandView.textColor = .white
        
        stackView.addArrangedSubview(operatorView)
        stackView.addArrangedSubview(operandView)
        
        formulaStackView.addArrangedSubview(stackView)
    }
    
    private func removeStackViewContents() {
        formulaStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    private func addOperandToCalculateTarget() {
        if signIsPositive {
            calculaterTarget.append(temporaryOperandValues.joined())
        } else {
            calculaterTarget.append("-" + temporaryOperandValues.joined())
        }
        
        if currentOperatorLabel.text != "" || currentValueLabel.text != initialValue {
            addToFomulaHistory()
            formulaScrollView.scrollViewToBottom()
        }
        resetTemporaryOperandValues()
        isCalculated = false
        signIsPositive = true
    }
    
    func resetToInitialState() {
        resetTemporaryOperandValues()
        calculaterTarget.removeAll()
        currentOperatorLabel.text = ""
    }
    
    private func resetTemporaryOperandValues() {
        temporaryOperandValues.removeAll()
        currentValueLabel.text = initialValue
    }
}


extension UIScrollView {
    func scrollViewToBottom() {
        let setOfBottom = CGPoint(x: 0, y: contentSize.height)
        setContentOffset(setOfBottom, animated: false)
    }
}


