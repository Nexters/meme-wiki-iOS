//
//  UIViewController++Extension.swift
//  Meme
//
//  Created by 제나 on 8/15/25.
//

import UIKit

extension UIViewController {
    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func popToRootViewController() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func gotoMemeDetail(id: Int) {
        guard let url = URL(string: "https://meme-wiki.net/meme/\(id)") else { return }
        let webVC = WikiWebViewController(url: url)
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    func gotoMemeQuiz() {
        guard let url = URL(string: "https://meme-wiki.net/") else { return }
        let webVC = WikiWebViewController(url: url)
        navigationController?.pushViewController(webVC, animated: true)
	}
    
    func goToMemeCategoryViewControler(at category: CategoryItem) {
        let repository = CategoryRepository()
        let categoryUseCase = CategoryMemeUseCase(respository: repository)
        let categoriesUseCase = DefaultCategoriesUseCase(repository: repository)
        let viewModel = CategoryViewModel(categoriesUseCase: categoriesUseCase, categoryUseCase: categoryUseCase, selectedCategory: category)
        let viewController = MemeCategoryViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc func gotoMemeSearchViewController() {
        let repository = SearchRepository()
        let useCase = SearchUseCase(repository: repository)
        let viewModel = MemeSearchViewModel(searchUseCase: useCase)
        let viewController = MemeSearchViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentShareSheet(items: [Any]) {
        let activity = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        if let popover = activity.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(
                x: view.bounds.midX,
                y: view.bounds.midY,
                width: 0,
                height: 0)
            popover.permittedArrowDirections = []
        }
        present(activity, animated: true)
    }
    
    func presentAlertWithSingleAction(title: String, message: String?) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
