//
//  AddItemVC.swift
//  EatBeforeExpiry
//
//  Created by Nurşah ARİ on 15.12.2023.
//

import UIKit
import DropDown
import ProgressHUD


class AddItemVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var categoryDropButton: UIButton!
    @IBOutlet weak var expiryDate: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    let datePicker = UIDatePicker()
    var newItem = Product()
    var selectedItem: Product?
    
    typealias AddItemListener = () -> Void
    var addItemListener: AddItemListener?
    var isExpiryDate: Bool = false
    
    private lazy var fresh = UIAction(title: Categories.fresh.rawValue) { action in
        self.setCategoryButton(category: Categories.fresh)
    }
    private lazy var milk = UIAction(title: Categories.milk.rawValue) { action in
        self.setCategoryButton(category: Categories.milk)
    }
    private lazy var dryFood = UIAction(title: Categories.dryFood.rawValue) { action in
        self.setCategoryButton(category: Categories.dryFood)
    }
    private lazy var fastFood = UIAction(title: Categories.fastFood.rawValue) { action in
        self.setCategoryButton(category: Categories.fastFood)
    }
    private lazy var drink = UIAction(title: Categories.drink.rawValue) { action in
        self.setCategoryButton(category: Categories.drink)
    }
    private lazy var dessert = UIAction(title: Categories.dessert.rawValue) { action in
        self.setCategoryButton(category: Categories.dessert)
    }
    private lazy var sauce = UIAction(title: Categories.sauce.rawValue) { action in
        self.setCategoryButton(category: Categories.sauce)
    }
    private lazy var bread = UIAction(title: Categories.bread.rawValue) { action in
        self.setCategoryButton(category: Categories.bread)
    }
    private lazy var other = UIAction(title: Categories.other.rawValue) { action in
        self.setCategoryButton(category: Categories.other)
    }
    
    private lazy var elements:[UIAction] = [fresh,milk,dryFood,fastFood,drink,dessert,sauce,bread,other].reversed()
    private lazy var menu = UIMenu(children: elements)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressHUD.colorHUD = .grayCategory
        ProgressHUD.colorStatus = .purpleCategory
        categoryDropButton.showsMenuAsPrimaryAction = true
        categoryDropButton.menu = menu
        prepareUI()
        createDatePicker()
        self.hideKeyboardWhenTappedAround()
        
        if let selectedItem = selectedItem {
            titleLabel.text = "Ürün Düzenle"
            newItem = selectedItem
            isExpiryDate = true
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            
            productName.text = selectedItem.productName
            expiryDate.text = formatter.string(from: selectedItem.expiryDate)
            for category in Categories.allCases {
                if category.rawValue == selectedItem.category {
                    setCategoryButton(category: category)
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func prepareUI() {
        self.navigationController?.navigationBar.tintColor = .black
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.75, height: 44))
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.text = "Ürün Ekleme"
        self.navigationItem.titleView = label
        
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.titleTextAttributes = textAttributes
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            UINavigationBar.appearance().tintColor = .black
        }
        saveButton.backgroundColor = .purpleCategory
        saveButton.setTitleColor(.white, for: .normal)
        productName.setLeftPadding(25)
        expiryDate.setLeftPadding(25)
        categoryDropButton.titleEdgeInsets = UIEdgeInsets(top: 0,left: 25,bottom: 0,right: 0)
    }
    
    func setCategoryButton(category: Categories) {
        self.categoryDropButton.setTitle(category.rawValue, for: .normal)
        self.categoryDropButton.setTitleColor(.white, for: .normal)
        self.categoryDropButton.contentHorizontalAlignment = .center
        self.categoryDropButton.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .bold)
        self.categoryDropButton.titleEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        self.newItem.category = category.rawValue
        self.categoryDropButton.backgroundColor = category.color
        
        if var selectedItem = selectedItem {
            selectedItem.category = category.rawValue
            self.selectedItem = selectedItem
        }
    }
    
    func createDatePicker() {
        
        //DatePicker'da oluşan tarihi textfield'a kaydetmek için kullancağımız butonu koyacağımız barı oluşturuyoruz.
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: #selector(doneButtonClicked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton, doneButton], animated: true)
        toolbar.backgroundColor = .white
        expiryDate.inputAccessoryView = toolbar
        expiryDate.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    @objc func doneButtonClicked() {
        
        //Yazdıracağımız tarihin formatını belirliyoruz.
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        //Text field'a date picker'dan gelen değeri yazdırıyoruz.
        expiryDate.text = formatter.string(from: datePicker.date)
        newItem.expiryDate = datePicker.date
        if var selectedItem = selectedItem {
            selectedItem.expiryDate = datePicker.date
            self.selectedItem = selectedItem
        }
        isExpiryDate = true
        self.view.endEditing(true)
    }
    
    
    @IBAction func addItem(_ sender: Any) {
        
        newItem.productName = productName.text ?? ""
        if newItem.category.isEmpty || newItem.productName == "" || !isExpiryDate {
            ProgressHUD.failed("Lütfen ürün bilgilerini eksiksiz girdiğinizden emin olunuz.", interaction: true, delay: 2)
        } else {
            if var items = UserDefaultsManager().getDataForObject(type: [Product].self, forKey: .addItem) {
                
                if var selectedItem = selectedItem {
                    if let removeIndex = items.firstIndex(where: {$0.id == selectedItem.id }) {
                        items.remove(at: removeIndex)
                        selectedItem.productName = productName.text ?? ""
                        items.append(selectedItem)
                        UserDefaultsManager().setDataForObject(value: items, key: .addItem)
                    }
                } else {
                    if let maxId = items.max(by: {$0.id<$1.id})?.id {
                        newItem.id = maxId + 1
                    }
                    items.append(newItem)
                    UserDefaultsManager().setDataForObject(value: items, key: .addItem)
                }
            } else {
                UserDefaultsManager().setDataForObject(value: [newItem], key: .addItem)
            }
            self.dismiss(animated: true) {
                self.addItemListener?()
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension Notification.Name {
    static let myCustomValueUpdated = Notification.Name("myCustomValueUpdated")
}

