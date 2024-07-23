import UIKit
import Firebase

class ViewController: UIViewController, AlertPresentable {
    @IBOutlet weak var unameField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    @IBOutlet weak var showSwitch: UISwitch!
    @IBOutlet weak var signupButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        pwdField.isSecureTextEntry = true
        signupButton.addTarget(self, action: #selector(presentLoginVC), for: .touchUpInside)
    }
    @IBAction func switchChanged(_ sender: Any) {
        if showSwitch.isOn{
            pwdField!.isSecureTextEntry = false
        }
        else{
            pwdField.isSecureTextEntry = true
        }
    }
    @IBAction func loginButtonClicked(_ sender: Any) {
        if unameField.text == "" || pwdField.text == "" {
            presentAlert(message: "Please enter username and Password")
        }
        Auth.auth().signIn(withEmail: unameField.text!, password: pwdField.text!) { authData, error in
            if error != nil {
                self.presentAlert(message: error?.localizedDescription ?? "")
            }else {
                self.changeView(viewName: "Tab")
            }
        }
    }
    
    @objc func presentLoginVC() {
        changeView(viewName: "SignupVC")
    }
    
    private func changeView(viewName:String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: viewName)
        let newViewController = vc
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromBottom, animations: {
            window.rootViewController = newViewController
        }, completion: nil)
    }
}

protocol AlertPresentable {
    func presentAlert(title: String, message: String)
}

extension AlertPresentable where Self: UIViewController {
    func presentAlert(title: String = "Error", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        self.present(alert,animated: true)
        alert.addAction(okButton)
    }
}
