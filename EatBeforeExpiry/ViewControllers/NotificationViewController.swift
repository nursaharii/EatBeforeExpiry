//
//  NotificationViewController.swift
//  EatBeforeExpiry
//
//  Created by Nurşah ARİ on 4.01.2024.
//

import UIKit
import ProgressHUD
import Combine

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: CustomSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var goToRecipeButton: UIButton!
    
    var coordinator: NotificationCoordinator?
    var viewModel = NotificationViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    var expiryItems = [Product]() {
        didSet {
            viewModel.expiryItems = expiryItems
        }
    }
    var aboutToExpireItems = [Product]() {
        didSet {
            viewModel.aboutToExpireItems = aboutToExpireItems
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.selectSegment(index: 0)
        setupBindings()
        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        goToRecipeButton.makeRounded()
        goToRecipeButton.addShadow()
        emptyLabel.textColor = .grayCategory
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setupBindings() {
        viewModel.$selectedTabItems.receive(on: RunLoop.main)
            .sink { [weak self] selectedTabItems in
                guard let self = self else { return }
                self.tableView.reloadData()
                self.emptyLabel.isHidden = !self.viewModel.selectedTabItems.isEmpty
                self.tableView.isHidden = self.viewModel.selectedTabItems.isEmpty
                self.goToRecipeButton.isHidden = self.viewModel.selectedSegmentIndex != 0
            }.store(in: &cancellables)
    }
    
    
    @IBAction func selectSegment(_ sender: CustomSegmentedControl) {
        viewModel.selectSegment(index: sender.selectedSegmentIndex)
        if viewModel.selectedTabItems.isEmpty {
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
            coordinator?.goToRecipeVC(aboutToExpireItems, "Son kullanma tarihi yaklaşmakta olan ürünleriniz için tarifiniz:", "aboutToExpire")
        }
    }
    
    @IBAction func close(_ sender: Any) {
        coordinator?.goBack()
    }
    
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.selectedTabItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.identifier, for: indexPath) as? ItemCell {
            let items = viewModel.selectedTabItems
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
            let today = Date()
            if let nextDate = Calendar.current.date(byAdding: .day, value: 5, to: today) {
                if items[indexPath.row].expiryDate <= today {
                    cell.expiryDate.backgroundColor = .errorRed
                    cell.expiryDate.textColor = .white
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
            return cell
        }
        
        return UITableViewCell()
    }
}
