//
//  ViewController.swift
//  EatBeforeExpiry
//
//  Created by Nurşah ARİ on 14.12.2023.
//

import UIKit
import OpenAI

enum Categories: String {
    case fresh = "Taze Ürünler"
    case milk = "Süt Ürünleri"
    case dryFood = "Kuru Gıda ve Bakliyatlar"
    case fastFood = "Konserve ve Hazır Gıdalar"
    case drink = "İçecekler"
    case dessert = "Atıştırmalıklar ve Tatlılar"
    case sauce = "Baharatlar ve Soslar"
    case bread = "Ekmek ve Fırın Ürünleri"
    case other = "Diğer"
    
    var color: UIColor {
        switch self {
        case .fresh:
            return .greenCategory
        case .milk:
            return .blueCategory
        case .dryFood:
            return .brownCategory
        case .fastFood:
            return .orangeCategory
        case .drink:
            return .redCategory
        case .dessert:
            return .purpleCategory
        case .sauce:
            return .yellowCategory
        case .bread:
            return .grayCategory
        case .other:
            return .pinkCategory
        }
    }
    var image: String {
        switch self {
        case .fresh:
            return "fresh-category"
        case .milk:
            return "milk-category"
        case .dryFood:
            return "dryFood-category"
        case .fastFood:
            return "fastFood-category"
        case .drink:
            return "drink-category"
        case .dessert:
            return "dessert-category"
        case .sauce:
            return  "sauce-category"
        case .bread:
            return  "bread-category"
        case .other:
            return  "others-category"
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var showRecipeButton: UIButton!
    @IBOutlet weak var searchTextfield: UITextField!
    
    var selectedItems = [String]()
    var items = [Product]()
    var filteredItems = [Product]()
    var lowerData = String()
    var searchedItems = [Product]()
    
    let openAI = OpenAI(apiToken: "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")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "CategoryCell", bundle: Bundle.main),forCellWithReuseIdentifier: "CategoryCell")
        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        showRecipeButton.addShadow()
        searchTextfield.setLeftPadding(25)
        self.hideKeyboardWhenTappedAround()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        selectedItems.removeAll()
        items.removeAll()
        if let items = UserDefaultsManager().getDataForObject(type: [Product].self, forKey: .addItem) {
            self.items = items.sorted(by: { $0.expiryDate < $1.expiryDate})
        }
        filteredItems = items
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func askAI() {
        let query = ChatQuery(model: .gpt3_5Turbo, messages: [.init(role: .user, content: "Domates, biber, yufka bisküvi ile yemek tarifi")])
        
        openAI.chats(query: query) { result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.textView.text = success.choices.first?.message.content
                    self.textView.isHidden = false
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    @IBAction func goToAddItemVC(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AddItemVC") as! AddItemVC
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true) {
            viewController.addItemListener = {
                self.selectedItems.removeAll()
                self.items.removeAll()
                self.filteredItems.removeAll()
                if let items = UserDefaultsManager().getDataForObject(type: [Product].self, forKey: .addItem) {
                    self.items = items.sorted(by: { $0.expiryDate < $1.expiryDate})
                    self.filteredItems = self.items
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func showRecipe(_ sender: Any) {
        showRecipeButton.isHidden = true
        //askAI()
    }

    @IBAction func reset(_ sender: Any) {
        filteredItems = items
        searchedItems.removeAll()
        searchTextfield.text = ""
        tableView.reloadData()
    }
    
    func search() {
        searchedItems = filteredItems.filter({ item in
            if let _ = item.productName.lowercased().range(of: lowerData,options: .caseInsensitive) {
                return true
            }
            return false
        })
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchedItems.count > 0 {
            searchedItems.count
        } else {
            filteredItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.identifier, for: indexPath) as? ItemCell {
            var items = [Product]()
            if searchedItems.count > 0 {
                items = searchedItems
            } else {
                items = filteredItems
            }
            cell.expiryDate.edgeInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            cell.category.edgeInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            cell.category.backgroundColor = .yellow
            cell.expiryDate.backgroundColor = .red
            cell.productName.text = items[indexPath.row].productName
            cell.category.text = items[indexPath.row].category
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            cell.expiryDate.text = formatter.string(from: items[indexPath.row].expiryDate)
            
            //            if selectedItems.contains(items[indexPath.row].productName) {
            //                cell.selectImage.image = UIImage(named: "select-filled")
            //            } else {
            //                cell.selectImage.image = UIImage(named: "select-empty")
            //            }
            
            let today = Date()
            if let nextDate = Calendar.current.date(byAdding: .day, value: 5, to: today) {
                if items[indexPath.row].expiryDate <= today {
                    cell.expiryDate.backgroundColor = .errorRed
                    cell.expiryDate.textColor = .white
                    //                    cell.selectItemButton.isEnabled = false
                    //                    cell.selectImage.image = UIImage(named:"select-disabled")
                } else if items[indexPath.row].expiryDate <= nextDate {
                    cell.expiryDate.backgroundColor = .yellow
                    cell.expiryDate.textColor = .black
                } else {
                    cell.expiryDate.backgroundColor = .green
                    cell.expiryDate.textColor = .black
                }
            }
            
            switch items[indexPath.row].category {
            case Categories.fresh.rawValue:
                cell.category.backgroundColor = Categories.fresh.color
            case Categories.milk.rawValue:
                cell.category.backgroundColor = Categories.milk.color
            case Categories.dryFood.rawValue:
                cell.category.backgroundColor = Categories.dryFood.color
            case Categories.fastFood.rawValue:
                cell.category.backgroundColor = Categories.fastFood.color
            case Categories.drink.rawValue:
                cell.category.backgroundColor = Categories.drink.color
            case Categories.dessert.rawValue:
                cell.category.backgroundColor = Categories.dessert.color
            case Categories.sauce.rawValue:
                cell.category.backgroundColor = Categories.sauce.color
            case Categories.bread.rawValue:
                cell.category.backgroundColor = Categories.bread.color
            case Categories.other.rawValue:
                cell.category.backgroundColor = Categories.other.color
            default:
                cell.category.backgroundColor = Categories.fresh.color
            }
            
            //            cell.selectItemCallback = {
            //                if let removeIndex = self.selectedItems.firstIndex(of: self.items[indexPath.row].productName) {
            //                    self.selectedItems.remove(at: removeIndex)
            //                    cell.selectImage.image = UIImage(named: "select-empty")
            //                } else {
            //                    self.selectedItems.append(self.items[indexPath.row].productName)
            //                    cell.selectImage.image = UIImage(named: "select-filled")
            //                }
            //            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if searchedItems.count > 0 {
                var items = searchedItems
                searchedItems.remove(at: indexPath.row)
                
                if let removeIndex = self.filteredItems.firstIndex(where: {$0.id == items[indexPath.row].id }) {
                    filteredItems.remove(at: removeIndex)
                }
                if let removeIndex = self.items.firstIndex(where: {$0.id == items[indexPath.row].id }) {
                    self.items.remove(at: removeIndex)
                    UserDefaultsManager().setDataForObject(value: items, key: .addItem)
                }
                search()
            } else {
                filteredItems.remove(at: indexPath.row)
                if let removeIndex = self.items.firstIndex(where: {$0.id == items[indexPath.row].id }) {
                    self.items.remove(at: removeIndex)
                    UserDefaultsManager().setDataForObject(value: items, key: .addItem)
                }
                tableView.reloadData()
            }
            
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell {
            
            switch indexPath.row {
            case 0:
                cell.categoryImg.image = UIImage(named: Categories.fresh.image)
                cell.categoryName.text = Categories.fresh.rawValue
            case 1:
                cell.categoryImg.image = UIImage(named: Categories.milk.image)
                cell.categoryName.text = Categories.milk.rawValue
            case 2:
                cell.categoryImg.image = UIImage(named: Categories.dryFood.image)
                cell.categoryName.text = Categories.dryFood.rawValue
            case 3:
                cell.categoryImg.image = UIImage(named: Categories.fastFood.image)
                cell.categoryName.text = Categories.fastFood.rawValue
            case 4:
                cell.categoryImg.image = UIImage(named: Categories.drink.image)
                cell.categoryName.text = Categories.drink.rawValue
            case 5:
                cell.categoryImg.image = UIImage(named: Categories.dessert.image)
                cell.categoryName.text = Categories.dessert.rawValue
            case 6:
                cell.categoryImg.image = UIImage(named: Categories.sauce.image)
                cell.categoryName.text = Categories.sauce.rawValue
            case 7:
                cell.categoryImg.image = UIImage(named: Categories.bread.image)
                cell.categoryName.text = Categories.bread.rawValue
            case 8:
                cell.categoryImg.image = UIImage(named: Categories.other.image)
                cell.categoryName.text = Categories.other.rawValue
            default:
                cell.categoryImg.image = UIImage(named: Categories.other.image)
                cell.categoryName.text = Categories.other.rawValue
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width/2.3 , height: 80)
    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    //        return 1
    //    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) is CategoryCell {
            filteredItems.removeAll()
            switch indexPath.row {
            case 0:
                filteredItems = items.filter({return $0.category == Categories.fresh.rawValue})
            case 1:
                filteredItems = items.filter({return $0.category == Categories.milk.rawValue})
            case 2:
                filteredItems = items.filter({return $0.category == Categories.dryFood.rawValue})
            case 3:
                filteredItems = items.filter({return $0.category == Categories.fastFood.rawValue})
            case 4:
                filteredItems = items.filter({return $0.category == Categories.drink.rawValue})
            case 5:
                filteredItems = items.filter({return $0.category == Categories.dessert.rawValue})
            case 6:
                filteredItems = items.filter({return $0.category == Categories.sauce.rawValue})
            case 7:
                filteredItems = items.filter({return $0.category == Categories.bread.rawValue})
            case 8:
                filteredItems = items.filter({return $0.category == Categories.other.rawValue})
            default:
                filteredItems = items.filter({return $0.category == Categories.other.rawValue})
            }
            tableView.reloadData()
        }
    }
}

extension ViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        lowerData = (textField.text! + string).lowercased()
        
        if string == "" && range.length > 0 {
            let deletedData = lowerData.dropLast(range.length)
            lowerData = String(deletedData)
        }
        tableView.reloadData()
        if lowerData.count >= 3 {
            self.search()
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("text cleared")
        //do few custom activities here
        searchedItems.removeAll()
        tableView.reloadData()
        return true
      }
}

