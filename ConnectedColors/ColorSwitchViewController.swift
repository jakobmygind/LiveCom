import UIKit

class ColorSwitchViewController: UIViewController {

    @IBOutlet weak var connectionsLabel: UILabel!
    @IBOutlet weak var innerStackView: UIStackView!
    @IBOutlet weak var outerStackView: UIStackView!
    
    var colorService: ColorServiceManager!
    
    var moreOrLess: String? {
        didSet {
            if moreOrLess != nil {
                setTitle()
            }
        }
    }
    var instrument: String? {
        didSet {
            if instrument != nil {
                setTitle()
            }
        }
    }
    
    var myName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        
        navigationController?.navigationBar.barTintColor = UIColor.lcRed
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        } else {
            // Fallback on earlier versions
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
       
        
        outerStackView.arrangedSubviews.filter({ $0 is UIButton}).forEach { (btn) in
            if let button = btn as? UIButton {
                button.backgroundColor = UIColor.lcRed
                button.titleLabel?.font = UIFont.lcBold(withSize: 30)
                button.setTitleColor(UIColor.white, for: UIControlState.normal)
                button.setBackgroundColor(color: UIColor.yellow, forState: UIControlState.highlighted)
            }
        }
        innerStackView.arrangedSubviews.filter({ $0 is UIButton}).forEach { (btn) in
            if let button = btn as? UIButton {
                button.backgroundColor = UIColor.lcRed
                button.titleLabel?.font = UIFont.lcBold(withSize: 30)
                button.setTitleColor(UIColor.white, for: UIControlState.normal)
                button.setBackgroundColor(color: UIColor.yellow, forState: UIControlState.highlighted)
            }
        }
        
        
    }
    
    @objc func didBecomeActive() {
        if self.myName != nil {
            start()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let alert = UIAlertController(title: "Enter name", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textField) in
           
            textField.placeholder = "name"
        }
        
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (_) in
            guard let username = alert.textFields?.first?.text else { self.myName = "Someone"; self.start(); return }
            self.myName = username
            self.start()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func setTitle() {
        if instrument == nil && moreOrLess == nil { return }
        let temp = makeString()
        title = temp
    }
    
    func makeString() -> String {
        var temp = ""
        if let mol = moreOrLess {
            temp = mol
        }
        if let instrument = instrument {
            let additionalSpace = moreOrLess != nil ? " " : ""
            temp += additionalSpace + instrument
        }
        return temp
    }
    
    @IBAction func didClickMoreOrLessButton(_ sender: UIButton) {
        moreOrLess = sender.titleLabel?.text
        checkAndSend()
        
    }
    
    @IBAction func didTouchDownOnButton(_ sender: UIButton) {
//        sender.backgroundColor = UIColor.yellow
    }
    
    
    
    @IBAction func didClickinstrumentButton(_ sender: UIButton) {
        instrument = sender.titleLabel?.text
        checkAndSend()
        
    }
    
    func checkAndSend() {
        if let instrument = instrument, let mol = moreOrLess, let myName = myName {
            let temp = myName + ": " + makeString()
            colorService.send(colorName: temp)
//            self.change(color: .yellow)
            self.instrument = nil
            moreOrLess = nil
        }
    }
    
    @IBAction func redTapped() {
        self.change(color: .red)
        colorService.send(colorName: "red")
    }

    @IBAction func yellowTapped() {
        self.change(color: .yellow)
        colorService.send(colorName: "yellow")
    }

    func change(color : UIColor) {
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = color
        }
    }
    
    func start() {
        colorService = ColorServiceManager()
        colorService.delegate = self
        if let myName = myName {
            colorService.start(withName:myName)
        }
    }
    
}

extension ColorSwitchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        start()
        return false
    }
}

extension ColorSwitchViewController : ColorServiceManagerDelegate {

    func connectedDevicesChanged(manager: ColorServiceManager, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            self.connectionsLabel.text = "Connections: \(connectedDevices)"
        }
    }

    func colorChanged(manager: ColorServiceManager, colorString: String) {
        OperationQueue.main.addOperation {
            switch colorString {
            case "red":
                self.change(color: .red)
            case "yellow":
                self.change(color: .yellow)
            default:
                NSLog("%@", "Unknown color value received: \(colorString)")
            }
        }
    }

}
