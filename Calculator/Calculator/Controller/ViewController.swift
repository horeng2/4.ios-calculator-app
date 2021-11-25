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
        formulaStackView.arrangedSubviews.forEach({ (view: UIView) -> Void in view.removeFromSuperview()
        })
    }
    
    @IBAction private func hitOperandButton(_ sender: UIButton) {
        guard let inputButtonTitle = sender.titleLabel?.text,
                  temporaryOperandValues.count < 20 else {
            return
        }
        let addcommaOperand: String
        
        if temporaryOperandValues.contains(".") {
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
        
        isCalculated = false
        signIsPositive = true
    }
    
    @IBAction private func hitOperatorButton(_ sender: UIButton) {
        guard let inputButtonTitle = sender.titleLabel?.text else {
            return
        }
        addOperandToCalculateTarget()
        resetCurrentInputOperand()
        if isOperatorEntered {
            calculaterTarget.removeLast()
            calculaterTarget.append(inputButtonTitle)
        } else {
            calculaterTarget.append(inputButtonTitle)
            isOperatorEntered = true
        }
        currentOperatorLabel.text = inputButtonTitle
    }
    
    func resetToInitialState() {
        resetCurrentInputOperand()
        calculaterTarget.removeAll()
        currentOperatorLabel.text = ""
    }
    
    private func resetCurrentInputOperand() {
        temporaryOperandValues = []
        currentValueLabel.text = initialValue
    }
    
    @IBAction private func hitACButton(_ sender: UIButton) {
        resetToInitialState()
        removeStackViewContents()
    }
    
    @IBAction private func hitCEButton(_ sender: UIButton) {
        resetCurrentInputOperand()
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
        addOperandToCalculateTarget()
        guard calculaterTarget != [] else {
                  resetCurrentInputOperand()
              return
        }
        let calculator = ExpressionParser.self
        let doubleTypeResult = calculator.parse(from: calculaterTarget.joined()).result()
        resetCurrentInputOperand()
        if doubleTypeResult.isNaN {
            resetToInitialState()
            currentValueLabel.text = "NaN"
        } else {
            resetToInitialState()
            currentValueLabel.text = String(doubleTypeResult).insertComma()
        }
        isCalculated = true
    }
}


extension UIScrollView {
    func scrollViewToBottom() {
        let setOfBottom = CGPoint(x: 0, y: contentSize.height)
        setContentOffset(setOfBottom, animated: false)
    }
}


