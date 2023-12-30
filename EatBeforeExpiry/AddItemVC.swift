//
//  AddItemVC.swift
//  EatBeforeExpiry
//
//  Created by Nurşah ARİ on 15.12.2023.
//

import UIKit
import DropDown


class AddItemVC: UIViewController {
    
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var categoryDropButton: UIButton!
    @IBOutlet weak var expiryDate: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    let datePicker = UIDatePicker()
    var newItem = Product()
    
    typealias AddItemListener = () -> Void
    var addItemListener: AddItemListener?

    
    private lazy var fresh = UIAction(title: Categories.fresh.rawValue) { action in
        self.categoryDropButton.setTitle(Categories.fresh.rawValue, for: .normal)
        self.categoryDropButton.setTitleColor(.white, for: .normal)
        self.categoryDropButton.contentHorizontalAlignment = .center
        self.categoryDropButton.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .bold)
        self.categoryDropButton.titleEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        self.newItem.category = Categories.fresh.rawValue
        self.categoryDropButton.backgroundColor = Categories.fresh.color
    }
    private lazy var milk = UIAction(title: Categories.milk.rawValue) { action in
        self.categoryDropButton.setTitle(Categories.milk.rawValue, for: .normal)
        self.categoryDropButton.setTitleColor(.white, for: .normal)
        self.categoryDropButton.contentHorizontalAlignment = .center
        self.categoryDropButton.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .bold)
        self.categoryDropButton.titleEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        self.newItem.category = Categories.milk.rawValue
        self.categoryDropButton.backgroundColor = Categories.milk.color
    }
    private lazy var dryFood = UIAction(title: Categories.dryFood.rawValue) { action in
        self.categoryDropButton.setTitle(Categories.dryFood.rawValue, for: .normal)
        self.categoryDropButton.setTitleColor(.white, for: .normal)
        self.categoryDropButton.contentHorizontalAlignment = .center
        self.categoryDropButton.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .bold)
        self.categoryDropButton.titleEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        self.newItem.category = Categories.dryFood.rawValue
        self.categoryDropButton.backgroundColor = Categories.dryFood.color
    }
    private lazy var fastFood = UIAction(title: Categories.fastFood.rawValue) { action in
        self.categoryDropButton.setTitle(Categories.fastFood.rawValue, for: .normal)
        self.categoryDropButton.setTitleColor(.white, for: .normal)
        self.categoryDropButton.contentHorizontalAlignment = .center
        self.categoryDropButton.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .bold)
        self.categoryDropButton.titleEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        self.newItem.category = Categories.fastFood.rawValue
        self.categoryDropButton.backgroundColor = Categories.fastFood.color
    }
    private lazy var drink = UIAction(title: Categories.drink.rawValue) { action in
        self.categoryDropButton.setTitle(Categories.drink.rawValue, for: .normal)
        self.categoryDropButton.setTitleColor(.white, for: .normal)
        self.categoryDropButton.contentHorizontalAlignment = .center
        self.categoryDropButton.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .bold)
        self.categoryDropButton.titleEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        self.newItem.category = Categories.drink.rawValue
        self.categoryDropButton.backgroundColor = Categories.drink.color
    }
    private lazy var dessert = UIAction(title: Categories.dessert.rawValue) { action in
        self.categoryDropButton.setTitle(Categories.dessert.rawValue, for: .normal)
        self.categoryDropButton.setTitleColor(.white, for: .normal)
        self.categoryDropButton.contentHorizontalAlignment = .center
        self.categoryDropButton.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .bold)
        self.categoryDropButton.titleEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        self.newItem.category = Categories.dessert.rawValue
        self.categoryDropButton.backgroundColor = Categories.dessert.color
    }
    private lazy var sauce = UIAction(title: Categories.sauce.rawValue) { action in
        self.categoryDropButton.setTitle(Categories.sauce.rawValue, for: .normal)
        self.categoryDropButton.setTitleColor(.black, for: .normal)
        self.categoryDropButton.contentHorizontalAlignment = .center
        self.categoryDropButton.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .bold)
        self.categoryDropButton.titleEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        self.newItem.category = Categories.sauce.rawValue
        self.categoryDropButton.backgroundColor = Categories.sauce.color
    }
    private lazy var bread = UIAction(title: Categories.bread.rawValue) { action in
        self.categoryDropButton.setTitle(Categories.bread.rawValue, for: .normal)
        self.categoryDropButton.setTitleColor(.white, for: .normal)
        self.categoryDropButton.contentHorizontalAlignment = .center
        self.categoryDropButton.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .bold)
        self.categoryDropButton.titleEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        self.newItem.category = Categories.bread.rawValue
        self.categoryDropButton.backgroundColor = Categories.bread.color
    }
    private lazy var other = UIAction(title: Categories.other.rawValue) { action in
        self.categoryDropButton.setTitle(Categories.other.rawValue, for: .normal)
        self.categoryDropButton.setTitleColor(.white, for: .normal)
        self.categoryDropButton.contentHorizontalAlignment = .center
        self.categoryDropButton.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .bold)
        self.categoryDropButton.titleEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        self.newItem.category = Categories.other.rawValue
        self.categoryDropButton.backgroundColor = Categories.other.color
    }
    
    private lazy var elements:[UIAction] = [fresh,milk,dryFood,fastFood,drink,dessert,sauce,bread,other].reversed()
    private lazy var menu = UIMenu(children: elements)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryDropButton.showsMenuAsPrimaryAction = true
        categoryDropButton.menu = menu
        prepareUI()
        createDatePicker()
        self.hideKeyboardWhenTappedAround() 
        
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
        
        //Done butonuna bastıktan sonra klavyemizin kapanacağını söylüyruz.
        self.view.endEditing(true)
    }
    
    
    @IBAction func addItem(_ sender: Any) {
        newItem.productName = productName.text ?? ""
        if newItem.category.isEmpty {
            self.newItem.category = Categories.other.rawValue
        }
        if var items = UserDefaultsManager().getDataForObject(type: [Product].self, forKey: .addItem) {
            if let maxId = items.max(by: {$0.id<$1.id})?.id {
                newItem.id = maxId + 1
            }
            items.append(newItem)
            UserDefaultsManager().setDataForObject(value: items, key: .addItem)
        } else {
            UserDefaultsManager().setDataForObject(value: [newItem], key: .addItem)
        }
        self.dismiss(animated: true) {
            self.addItemListener?()
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
}



