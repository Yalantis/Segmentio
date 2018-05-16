import Foundation

private let BadgeCounterMaxValue = 99
private let BadgeCounterOverMaxValueText = "99+"
private let standardSizedNibName = "BadgeWithCounterViewStandardSized"
private let bigSizedNibName = "BadgeWithCounterViewBigSized"
// 只显示badge，不显示数量
private let standardSizeWithoutValueNibName = "BadgeWithCounterViewStandardSizedWithoutValue"

enum BadgeSize {
    
    case standard
    case big
    case standerdWithoutValue
    
}

class BadgeWithCounterView: UIView {
    
    @IBOutlet fileprivate weak var counterValueLabel: UILabel!
    @IBOutlet fileprivate weak var backgroundImageView: UIImageView!
    
    class func instanceFromNib(size: BadgeSize) -> BadgeWithCounterView {
        let nibName = nibNameForSize(size)
        let podBundle = Bundle(for: self.classForCoder())
        
        if let bundleURL = podBundle.url(forResource: "Segmentio", withExtension: "bundle"),
            let bundle = Bundle(url: bundleURL) {
            return UINib(nibName: nibName, bundle: bundle)
                .instantiate(withOwner: nil, options: nil)[0] as! BadgeWithCounterView
        }
        return BadgeWithCounterView(frame: .zero)
    }

    func setBadgeCounterValue(_ counterValue: Int?) {
        if let count = counterValue {
            var counterText: String!
            if count > BadgeCounterMaxValue {
                counterText = BadgeCounterOverMaxValueText
            } else {
                counterText = String(count)
            }
            counterValueLabel.text = counterText
        } 
        
    }
    
    func setBadgeBackgroundColor(_ color: UIColor) {
        backgroundImageView.backgroundColor = color
    }
    
    fileprivate class func nibNameForSize(_ size: BadgeSize) -> String {
        switch size {
        case .standard:
            return standardSizedNibName
        case .big:
            return bigSizedNibName
        case .standerdWithoutValue:
            return standardSizeWithoutValueNibName
        }
    }
}
