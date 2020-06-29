
import UIKit
import SDWebImage
import  SwiftyJSON

class UserModal {
    var userImage: UIImage?
    var name: String?
    var age: String?
    
    init(userImage: UIImage, name: String, age: String) {
        self.userImage = userImage
        self.name = name
        self.age = age
    }
}

class ViewController: UIViewController {
    
    var tableView = UITableView()
     var userArr = [UserModal]()
    
    fileprivate lazy var infoLabel: UILabel = {
        let l = UILabel()
        
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "No Storyboard"
        l.font = UIFont.systemFont(ofSize: 17, weight: .black)
        l.textAlignment = .center
        
        return l
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeView()
        setTableView()

      getProfileInfo()
    }
  
    func getProfileInfo(){
     
       TransportManager.sharedInstance.getProfileInfo() { (data, err) in
     
         if let er = err {
            print(er)
          
         } else {
           if let json = data as? JSON {
             print("jsin value ",json)
           }
         }
       }
        
        userArr.append(UserModal(userImage:  #imageLiteral(resourceName: "Charlize Theron"), name: "Amber Heard", age: "32"))
        userArr.append(UserModal(userImage:  #imageLiteral(resourceName: "Emma Stone"), name: "Emma Stone", age: "30"))
        userArr.append(UserModal(userImage:  #imageLiteral(resourceName: "Natalie Portman"), name: "Natalie Portman", age: "37"))
        userArr.append(UserModal(userImage:  #imageLiteral(resourceName: "Emma Watson"), name: "Emma Watson", age: "28"))
        userArr.append(UserModal(userImage:  #imageLiteral(resourceName: "Amber Heard"), name: "Angelina Jolie", age: "43"))
        userArr.append(UserModal(userImage:  #imageLiteral(resourceName: "Jennifer Lawrence"), name: "Scarlett Johansson", age: "34"))
        userArr.append(UserModal(userImage:  #imageLiteral(resourceName: "Angelina Jolie"), name: "Jennifer Lawrence", age: "28"))
        userArr.append(UserModal(userImage:  #imageLiteral(resourceName: "Scarlett Johansson"), name: "Charlize Theron", age: "43"))
     }
    private func customizeView(){
        view.backgroundColor = .white
        
        view.addSubview(infoLabel)
        
        
        infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
       
        
    }
    
    
    func setTableView() {
//        tableView.frame = self.view.frame
        tableView.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height)
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        tableView.backgroundColor = UIColor.groupTableViewBackground
        self.view.addSubview(tableView)
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return userArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomTableViewCell else {fatalError("Unabel to create cell")}
        
        cell.backView.frame = CGRect(x: 10, y: 6, width: self.view.frame.width - 20, height: 110)
        cell.namelbl.frame = CGRect(x: 116, y: 8, width: self.view.frame.width - 116, height: 30)
        cell.agelbl.frame = CGRect(x: 116, y: 42, width: self.view.frame.width - 116, height: 30)
        
//        let url = URL(string:(response?.rows[indexPath.row].imageHref)!)
//        cell.userImage.sd_setImage(with:url, placeholderImage: UIImage(named: "welcomescreen_illustration"))
//        cell.namelbl.text = response?.rows[indexPath.row].title
//        cell.agelbl.text = response?.rows[indexPath.row].rowDescription
        
        cell.userImage.image = userArr[indexPath.row].userImage
        cell.namelbl.text = userArr[indexPath.row].name
        cell.agelbl.text = userArr[indexPath.row].age
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}

