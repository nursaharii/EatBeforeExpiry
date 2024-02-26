//
//  RecipeViewController.swift
//  EatBeforeExpiry
//
//  Created by Nurşah ARİ on 31.12.2023.
//

import UIKit
import OpenAI
import ProgressHUD

class RecipeViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recipeLabel: UITextView!
    
    var items = [Product]()
    var recipeTitle = ""
    let openAI = OpenAI(apiToken: "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")
    var category = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressHUD.animationType = .horizontalDotScaling
        ProgressHUD.colorHUD = .grayCategory
        ProgressHUD.colorAnimation = .purpleCategory
        ProgressHUD.colorStatus = .purpleCategory
        scrollView.showsVerticalScrollIndicator = false
        scrollView.setContentOffset(.zero, animated: true)
        titleLabel.text = recipeTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 1.5) {
            self.visualEffectView.alpha = 0.7
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if category == "all" {
            titleLabel.textAlignment = .center
            if let recipeData = UserDefaultsManager().getData(type: [String:Date].self, forKey: .recipe) {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let strDate = formatter.string(from: Date())
                let date = formatter.date(from: strDate)
                if date! > recipeData.first!.value {
                    askAI()
                } else {
                    self.recipeLabel.text = recipeData.first?.key
                    titleLabel.isHidden = false
                }
            } else {
                askAI()
            }
        } else {
            titleLabel.textAlignment = .left
            if let recipeData = UserDefaultsManager().getData(type: [String:Date].self, forKey: .expireSuggestion) {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let strDate = formatter.string(from: Date())
                let date = formatter.date(from: strDate)
                if date! > recipeData.first!.value {
                    askAI()
                } else {
                    self.recipeLabel.text = recipeData.first?.key
                    titleLabel.isHidden = false
                }
            } else {
                askAI()
            }

        }
    }
    
    func askAI() {
        var strItems = ""
        for i in items {
            strItems = strItems + ", \(i.productName)"
        }
        titleLabel.isHidden = true
        ProgressHUD.animate("Loading")
        let query = ChatQuery(model: .gpt3_5Turbo, messages: [.init(role: .user, content: "\(strItems) içeren yemek tarifi")])
        
        self.openAI.chats(query: query) { result in
            switch result {
            case .success(let success):
                ProgressHUD.remove()
                DispatchQueue.main.async {
                    self.titleLabel.isHidden = false
                    self.recipeLabel.text = success.choices.first?.message.content
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    let strDate = formatter.string(from: Date())
                    let date = formatter.date(from: strDate)
                    if self.category == "all" {
                        UserDefaultsManager().setData(value: [success.choices.first?.message.content:date], key: .recipe)
                    } else {
                        UserDefaultsManager().setData(value: [success.choices.first?.message.content:date], key: .expireSuggestion)
                    }
                    
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    @IBAction func close(_ sender: Any) {
        ProgressHUD.remove()
        self.dismiss(animated: true)
    }
}
// MARK: UIScrollViewDelegate
extension RecipeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= -100{
            self.visualEffectView.isHidden = true
            UIView.animate(withDuration: 0.4) {
                ProgressHUD.remove()
                self.dismiss(animated: true)
            }
        }
    }
}
