//
//  RecipeViewModel.swift
//  EatBeforeExpiry
//
//  Created by Nurşah Ari on 27.02.2024.
//

import Foundation
import Combine
import OpenAI

class RecipeViewModel {
    let openAI = OpenAI(apiToken: Singleton.sharedInstance.apiKey)
    @Published var recipeText = String()
    var errorMessage: ((String?) -> Void)?
    
    func fetchRecipe(items: [Product],category: String) {
           var strItems = ""
           for item in items {
               strItems += ", \(item.productName)"
           }
           
        let query = AIConfig.chatQuery(strItems)
           openAI.chats(query: query) { result in
               switch result {
               case .success(let success):
                   self.recipeText = success.choices.first?.message.content ?? ""
                   let formatter = DateFormatter()
                   formatter.dateFormat = "yyyy-MM-dd"
                   let strDate = formatter.string(from: Date())
                   let date = formatter.date(from: strDate)
                   if category == "all" {
                       UserDefaultsManager().setData(value: [success.choices.first?.message.content:date], key: .recipe)
                   } else {
                       UserDefaultsManager().setData(value: [success.choices.first?.message.content:date], key: .expireSuggestion)
                   }
               case .failure(let error):
                   self.errorMessage?("An error occurred: \(error.localizedDescription)")
               }
           }
       }
    
    func getDataFromUserDeafults(_ key: UserDefaultKeys) ->  [String:Date]? {
        if let recipeData = UserDefaultsManager().getData(type: [String:Date].self, forKey: key) {
            return recipeData
        }
        return nil
    }
}
