import UIKit
import Firebase

class SignupVC: UIViewController, AlertPresentable{
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        pwdField.isSecureTextEntry = true
    }
    
    @IBAction func signupButtonClicked(_ sender: Any) {
        guard let username = nameField.text, let  password = pwdField.text else { self.presentAlert(message: "Enter uname and pwd");                                                                            return }
        Auth.auth().createUser(withEmail: username, password: password) { authData, error in
            if error != nil {
                self.presentAlert(message: error?.localizedDescription ?? "")
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ViewController")
                let newViewController = vc
                guard let window = UIApplication.shared.windows.first else {
                    return
                }
                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromBottom, animations: {
                    window.rootViewController = newViewController
                }, completion: nil)
            }
        }
    }
}

