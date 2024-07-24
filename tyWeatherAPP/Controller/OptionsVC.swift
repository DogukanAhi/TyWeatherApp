import UIKit
import Firebase
class OptionsVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
     @IBAction func logoutClicked(_ sender: Any) {
         do {
                  try Auth.auth().signOut()
                  performSegue(withIdentifier: "toLoginVC", sender: nil)
              } catch let signOutError as NSError {
                  print("Error signing out: %@", signOutError)
                  presentAlert(title: "Error", message: "Failed to log out. Please try again.")
              }
    }
    func presentAlert(title: String, message: String) {
          let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
          let okButton = UIAlertAction(title: "Ok", style: .default)
          alert.addAction(okButton)
          self.present(alert, animated: true)
      }
}

