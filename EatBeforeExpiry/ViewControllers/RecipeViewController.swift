//
//  RecipeViewController.swift
//  EatBeforeExpiry
//
//  Created by Nurşah ARİ on 31.12.2023.
//

import UIKit
import ProgressHUD
import Combine

class RecipeViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recipeLabel: UITextView!
    
 
    
    var viewModel = RecipeViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    var recipeTitle = ""
    var category = String()
    var items = [Product]()
    
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
        ProgressHUD.animate("Loading")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bindViewModel()
        
        if category == "all" {
            titleLabel.textAlignment = .center
            
            if let recipeData = viewModel.getDataFromUserDeafults(.recipe) {
                ProgressHUD.remove()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let strDate = formatter.string(from: Date())
                let date = formatter.date(from: strDate)
                if date! > recipeData.first!.value {
                    viewModel.fetchRecipe(items: items, category: category)
                } else {
                    self.recipeLabel.text = recipeData.first?.key
                    titleLabel.isHidden = false
                }
            } else {
                viewModel.fetchRecipe(items: items, category: category)
            }
        } else {
            titleLabel.textAlignment = .left
            if let recipeData = viewModel.getDataFromUserDeafults(.expireSuggestion) {
                ProgressHUD.remove()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let strDate = formatter.string(from: Date())
                let date = formatter.date(from: strDate)
                if date! > recipeData.first!.value {
                    viewModel.fetchRecipe(items: items, category: category)
                } else {
                    self.recipeLabel.text = recipeData.first?.key
                    titleLabel.isHidden = false
                }
            } else {
                viewModel.fetchRecipe(items: items, category: category)
            }
        }
    }
    
    func bindViewModel() {
        viewModel.$recipeText
            .receive(on: RunLoop.main)
            .sink { text in
                if text != "" {
                    self.titleLabel.isHidden = false
                    self.recipeLabel.text = text
                    ProgressHUD.remove()
                }
            }.store(in: &cancellables)
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
