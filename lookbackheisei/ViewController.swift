import UIKit
import WebKit
class ViewController: UIViewController, WKUIDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController1 = storyboard.instantiateViewController(withIdentifier: "Sensor")
        //viewController1.view.backgroundColor = .green
        viewController1.title = "Sensor"
        
        let viewController2 = HeiseiViewController()
        viewController2.title = "Twioku"
        
        let viewController3 = AboutViewController()
        viewController3.title = "About"
        
        
        // 配列に初期化したViewControllerを格納
        let viewControllers = [viewController1, viewController2, viewController3]
        var option = PageMenuOption(frame: CGRect(
            x: 0, y: 20, width: view.frame.size.width, height: view.frame.size.height - 20))
        option.menuItemHeight = 80
        option.menuItemWidth = view.frame.size.width / 3
        option.menuTitleMargin = 0
        option.menuIndicatorColor = UIColor(red: 0, green: 0.7, blue: 0.9, alpha: 1.0)
        
        let pageMenu = PageMenuView(viewControllers: viewControllers, option: option)
        view.addSubview(pageMenu)
    }
    
    
}
