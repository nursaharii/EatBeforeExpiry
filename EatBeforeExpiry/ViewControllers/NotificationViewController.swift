//
//  NotificationViewController.swift
//  EatBeforeExpiry
//
//  Created by Nurşah ARİ on 4.01.2024.
//

import UIKit
import ProgressHUD

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: CustomSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var goToRecipeButton: UIButton!
    
    var expiryItems = [Product]()
    var aboutToExpireItems = [Product]()
    var selectedTabItems = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        selectedTabItems = aboutToExpireItems
        goToRecipeButton.makeRounded()
        goToRecipeButton.addShadow()
        if selectedTabItems.isEmpty {
            emptyLabel.isHidden = false
            tableView.isHidden = true
            emptyLabel.textColor = .grayCategory
        } else {
            emptyLabel.isHidden = true
            tableView.isHidden = false
        }
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    @IBAction func selectSegment(_ sender: CustomSegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedTabItems.removeAll()
            selectedTabItems = aboutToExpireItems
            goToRecipeButton.isHidden = false
            tableView.reloadData()
        case 1:
            selectedTabItems.removeAll()
            selectedTabItems = expiryItems
            goToRecipeButton.isHidden = true
            tableView.reloadData()
        default:
            break
        }
        
        if selectedTabItems.isEmpty {
            emptyLabel.isHidden = false
            tableView.isHidden = true
            emptyLabel.textColor = .grayCategory
        } else {
            emptyLabel.isHidden = true
            tableView.isHidden = false
        }
    }
    
    @IBAction func goToRecipeVC(_ sender: Any) {
        if aboutToExpireItems.isEmpty {
            ProgressHUD.banner("Listeniz Boş", "Yemek önerisi sunulabilecek herhangi bir malzeme bulunamadı.", delay: 3.0)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "RecipeVC") as! RecipeViewController
            viewController.modalPresentationStyle = .overFullScreen
            viewController.modalTransitionStyle = .coverVertical
            viewController.recipeTitle = "Son kullanma tarihi yaklaşmakta olan ürünleriniz için tarifiniz:"
            viewController.items = aboutToExpireItems
            viewController.category = "aboutToExpire"
            self.present(viewController, animated: true)
        }
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectedTabItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.identifier, for: indexPath) as? ItemCell {
            let items = selectedTabItems
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
}
