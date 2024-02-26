//
//  ViewController.swift
//  EatBeforeExpiry
//
//  Created by Nurşah ARİ on 14.12.2023.
//

import UIKit
import ProgressHUD
import Combine

enum Categories: String, CaseIterable {
    case all = "Tümü"
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
        case .all:
            return .black
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
        case .all:
            return "all"
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

class HomePageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var showRecipeButton: UIButton!
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var orderByButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshImage: UIImageView!
    @IBOutlet weak var notifButton: UIButton!
    
    var viewModel = HomePageViewModel()
    var coordinator: HomePageCoordinator?
    
    private var cancellables: Set<AnyCancellable> = []
    var lowerData = String()
    var aboutToExpireItems = [Product]()
    var expiryItems = [Product]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "CategoryCell", bundle: Bundle.main),forCellWithReuseIdentifier: "CategoryCell")
        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        showRecipeButton.makeRounded()
        showRecipeButton.addShadow()
        searchTextfield.setLeftPadding(25)
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bindViewModel()
    }
    
    func bindViewModel() {
        ProgressHUD.animate()
        viewModel.getItems()
        viewModel.$filteredItems
            .receive(on: RunLoop.main)
            .sink { [weak self] items in
            guard let self = self else { return }
                ProgressHUD.remove()
                if viewModel.descSorted {
                    self.orderByButton.setImage(UIImage(named: "arrow-up"), for: .normal)
                } else {
                    self.orderByButton.setImage(UIImage(named: "arrow-down"), for: .normal)
                }
            
            self.notifButton.setTitle("(\(viewModel.aboutToExpireItems.count))", for: .normal)
            if items.count > 0 {
                tableView.isHidden = false
                emptyLabel.isHidden = true
            } else {
                tableView.isHidden = true
                emptyLabel.isHidden = false
                emptyLabel.textColor = .grayCategory
                emptyLabel.text = "Listenizde ürün bulunmamakta..."
            }
                self.tableView.reloadData()
            }.store(in: &cancellables)
    }
    
  
    
    @IBAction func goToAddItemVC(_ sender: Any) {
        coordinator?.goToAddItemVC(nil, {
            self.viewModel.getItems()
            self.resetAll()
        })
    }
    
    @IBAction func showRecipe(_ sender: Any) {
        if viewModel.items.isEmpty {
            ProgressHUD.banner("Listeniz Boş", "Yemek önerisi alabilmek için lütfen listenize ürün ekleyiniz.", delay: 3.0)
        } else {
            coordinator?.goToRecipeVC(viewModel.items, "GÜNÜN ÖNERİSİ", "all")
        }
    }
    
    @IBAction func reset(_ sender: Any) {
        var images: [UIImage] = []
        for i in 1...2 {
            images.append(UIImage(named: "refresh\(i)")!)
        }
        refreshImage.animationImages = images
        refreshImage.animationDuration = 1
        refreshImage.startAnimating()
        resetAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.refreshImage.stopAnimating()
        }
    }
    
    
    @IBAction func orderBy(_ sender: Any) {
        let _ = viewModel.orderByDescending()
        tableView.reloadData()
    }
    
    @IBAction func goToNotificationVC(_ sender: Any) {
        coordinator?.goToNotificationVC(aboutToExpireItems, expiryItems)
    }
    
    func resetAll() {
        viewModel.resetAll()
        searchTextfield.text = ""
        tableView.reloadData()
        collectionView.reloadData()
    }
}

extension HomePageViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !viewModel.searchedItems.isEmpty {
            return viewModel.searchedItems.count
        } else {
            return viewModel.filteredItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.identifier, for: indexPath) as? ItemCell {
            var item = [Product]()
            if !viewModel.searchedItems.isEmpty {
                item = viewModel.searchedItems
            } else {
                item = viewModel.filteredItems
            }
            cell.expiryDate.edgeInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            cell.category.edgeInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            cell.category.backgroundColor = .yellow
            cell.expiryDate.backgroundColor = .red
            cell.productName.text = item[indexPath.row].productName
            cell.category.text = item[indexPath.row].category
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            cell.expiryDate.text = formatter.string(from: item[indexPath.row].expiryDate)
            
            let today = Date()
            if let nextDate = Calendar.current.date(byAdding: .day, value: 5, to: today) {
                if item[indexPath.row].expiryDate <= today {
                    cell.expiryDate.backgroundColor = .errorRed
                    cell.expiryDate.textColor = .white
                } else if item[indexPath.row].expiryDate <= nextDate, item[indexPath.row].expiryDate > Date() {
                    cell.expiryDate.backgroundColor = .yellow
                    cell.expiryDate.textColor = .black
                } else {
                    cell.expiryDate.backgroundColor = .green
                    cell.expiryDate.textColor = .black
                }
            }
            
            switch item[indexPath.row].category {
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
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.tableViewDelete(indexPath)
        }
        viewModel.getItems()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var items = [Product]()
        if !viewModel.searchedItems.isEmpty {
            items = viewModel.searchedItems
        } else {
            items = viewModel.filteredItems
        }
        coordinator?.goToAddItemVC(items[indexPath.row], {
            self.viewModel.getItems()
            self.resetAll()

        })
    }
}

extension HomePageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell {
            
            switch indexPath.row {
            case 0:
                cell.categoryImg.image = UIImage(named: Categories.all.image)
                cell.categoryName.text = Categories.all.rawValue
                cell.isSelected = true
            case 1:
                cell.categoryImg.image = UIImage(named: Categories.fresh.image)
                cell.categoryName.text = Categories.fresh.rawValue
            case 2:
                cell.categoryImg.image = UIImage(named: Categories.milk.image)
                cell.categoryName.text = Categories.milk.rawValue
            case 3:
                cell.categoryImg.image = UIImage(named: Categories.dryFood.image)
                cell.categoryName.text = Categories.dryFood.rawValue
            case 4:
                cell.categoryImg.image = UIImage(named: Categories.fastFood.image)
                cell.categoryName.text = Categories.fastFood.rawValue
            case 5:
                cell.categoryImg.image = UIImage(named: Categories.drink.image)
                cell.categoryName.text = Categories.drink.rawValue
            case 6:
                cell.categoryImg.image = UIImage(named: Categories.dessert.image)
                cell.categoryName.text = Categories.dessert.rawValue
            case 7:
                cell.categoryImg.image = UIImage(named: Categories.sauce.image)
                cell.categoryName.text = Categories.sauce.rawValue
            case 8:
                cell.categoryImg.image = UIImage(named: Categories.bread.image)
                cell.categoryName.text = Categories.bread.rawValue
            case 9:
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
            viewModel.filteredItems.removeAll()
            emptyLabel.textColor = .grayCategory
            switch indexPath.row {
            case 0:
                if viewModel.orderByDescending() {
                    orderByButton.setImage(UIImage(named: "arrow-up"), for: .normal)
                } else {
                    orderByButton.setImage(UIImage(named: "arrow-dowm"), for: .normal)
                }
                viewModel.searchedItems.removeAll()
                searchTextfield.text = ""
                if viewModel.filteredItems.count > 0 {
                    tableView.isHidden = false
                    emptyLabel.isHidden = true
                } else {
                    tableView.isHidden = true
                    emptyLabel.isHidden = false
                    emptyLabel.textColor = .grayCategory
                    emptyLabel.text = "Listenizde ürün bulunmamakta..."
                    
                }
            case 1:
                if let _ = viewModel.filter(Categories.fresh.rawValue) {
                    emptyLabel.isHidden = true
                    tableView.isHidden = false
                } else {
                    emptyLabel.text = "Listenizde " + Categories.fresh.rawValue + " kategorisinde ürün bulunmamaktadır."
                    emptyLabel.isHidden = false
                    tableView.isHidden = true
                }
            case 2:
                if let _ = viewModel.filter(Categories.milk.rawValue) {
                        emptyLabel.isHidden = true
                        tableView.isHidden = false
                } else {
                    emptyLabel.text = "Listenizde " + Categories.milk.rawValue + " kategorisinde ürün bulunmamaktadır."
                    emptyLabel.isHidden = false
                    tableView.isHidden = true
                }
            case 3:
                if let _ = viewModel.filter(Categories.dryFood.rawValue) {
                    emptyLabel.isHidden = true
                    tableView.isHidden = false
                } else {
                    emptyLabel.text = "Listenizde " + Categories.dryFood.rawValue + " kategorisinde ürün bulunmamaktadır."
                    emptyLabel.isHidden = false
                    tableView.isHidden = true
                }
            case 4:
                if let _ = viewModel.filter(Categories.fastFood.rawValue) {
                    emptyLabel.isHidden = true
                    tableView.isHidden = false
                } else {
                    emptyLabel.text = "Listenizde " + Categories.fastFood.rawValue + " kategorisinde ürün bulunmamaktadır."
                    emptyLabel.isHidden = false
                    tableView.isHidden = true
                }
            case 5:
                if let _ = viewModel.filter(Categories.drink.rawValue) {
                    emptyLabel.isHidden = true
                    tableView.isHidden = false
                } else {
                    emptyLabel.text = "Listenizde " + Categories.drink.rawValue + " kategorisinde ürün bulunmamaktadır."
                    emptyLabel.isHidden = false
                    tableView.isHidden = true
                }
            case 6:
                if let _ = viewModel.filter(Categories.dessert.rawValue) {
                    emptyLabel.isHidden = true
                    tableView.isHidden = false
                } else {
                    emptyLabel.text = "Listenizde " + Categories.dessert.rawValue + " kategorisinde ürün bulunmamaktadır."
                    emptyLabel.isHidden = false
                    tableView.isHidden = true
                }
            case 7:
                if let _ = viewModel.filter(Categories.sauce.rawValue) {
                    emptyLabel.isHidden = true
                    tableView.isHidden = false
                } else {
                    emptyLabel.text = "Listenizde " + Categories.sauce.rawValue + " kategorisinde ürün bulunmamaktadır."
                    emptyLabel.isHidden = false
                    tableView.isHidden = true
                }
            case 8:
                if let _ = viewModel.filter(Categories.bread.rawValue){
                    emptyLabel.isHidden = true
                    tableView.isHidden = false
                } else {
                    emptyLabel.text = "Listenizde " + Categories.bread.rawValue + " kategorisinde ürün bulunmamaktadır."
                    emptyLabel.isHidden = false
                    tableView.isHidden = true
                }
            case 9:
                if let _ = viewModel.filter(Categories.other.rawValue){
                    emptyLabel.isHidden = true
                    tableView.isHidden = false
                } else {
                    emptyLabel.text = "Listenizde " + Categories.other.rawValue + " kategorisinde ürün bulunmamaktadır."
                    emptyLabel.isHidden = false
                    tableView.isHidden = true
                }
            default:
                if let _ = viewModel.filter(Categories.other.rawValue){
                    emptyLabel.isHidden = true
                    tableView.isHidden = false
                } else {
                    emptyLabel.text = "Listenizde " + Categories.other.rawValue + " kategorisinde ürün bulunmamaktadır."
                    emptyLabel.isHidden = false
                    tableView.isHidden = true
                }
            }
            tableView.reloadData()
        }
    }
}

extension HomePageViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        lowerData = (textField.text! + string).lowercased()
        
        if string == "" && range.length > 0 {
            let deletedData = lowerData.dropLast(range.length)
            lowerData = String(deletedData)
        }
        if lowerData.count >= 1 {
            viewModel.searchTerm = lowerData
            emptyLabel.textColor = .grayCategory
            if viewModel.searchedItems.isEmpty {
                emptyLabel.isHidden = false
                tableView.isHidden = true
                emptyLabel.text = "\(lowerData) listenizde bulunamadı."
            } else {
                emptyLabel.isHidden = true
                tableView.isHidden = false
                tableView.reloadData()
            }
        } else {
            viewModel.searchedItems.removeAll()
            emptyLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.searchedItems.removeAll()
        emptyLabel.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
        return true
    }
}
