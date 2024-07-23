import UIKit
class OptionsVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
     @IBAction func logoutClicked(_ sender: Any) {
        performSegue(withIdentifier: "toLoginVC", sender: nil)
    }  
}
