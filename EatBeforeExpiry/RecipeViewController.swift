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
    
    @IBOutlet weak var recipeLabel: UILabel!
    
    let openAI = OpenAI(apiToken: "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")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressHUD.animationType = .horizontalDotScaling
        ProgressHUD.colorHUD = .grayCategory
        ProgressHUD.colorAnimation = .purpleCategory
        ProgressHUD.colorStatus = .purpleCategory
        scrollView.showsVerticalScrollIndicator = false
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 1.5) {
            self.visualEffectView.alpha = 0.7
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let recipeData = UserDefaultsManager().getData(type: [String:Date].self, forKey: .recipe) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let strDate = formatter.string(from: Date())
            let date = formatter.date(from: strDate)
            
            if date! > recipeData.first!.value {
                askAI()
            } else {
                self.recipeLabel.text = recipeData.first?.key
            }
        } else {
            askAI()
        }
    }
    
    func askAI() {
        ProgressHUD.animate("Loading")
        let query = ChatQuery(model: .gpt3_5Turbo, messages: [.init(role: .user, content: "Domates, biber, yufka bisküvi ile yemek tarifi")])
        
        self.openAI.chats(query: query) { result in
            switch result {
            case .success(let success):
                ProgressHUD.remove()
                DispatchQueue.main.async {
                    self.recipeLabel.text = success.choices.first?.message.content
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    let strDate = formatter.string(from: Date())
                    let date = formatter.date(from: strDate)
                    UserDefaultsManager().setData(value: [success.choices.first?.message.content:date], key: .recipe)
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
