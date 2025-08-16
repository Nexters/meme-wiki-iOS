//
//  MemeCustomViewController.swift
//  Meme
//
//  Created by 제나 on 8/15/25.
//

import Combine
import UIKit
import PencilKit

class MemeCustomViewController: BaseViewController {
    
    // MARK: - UI Components
    private var undoButton: UIBarButtonItem?
    private var redoButton: UIBarButtonItem?
    private var imageView = UIImageView()
    private var canvasView = PKCanvasView()
    private var toolPicker = PKToolPicker()
    private var saveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .iconDownload), for: .normal)
        button.imageView?.tintColor = .white
        button.setAttributedTitle(
            .customFont(
                .pretendard(.body(.body1)),
                text: "저장하기",
                color: .gray(.gray2)),
            for: .normal)
        button.backgroundColor = .gray9.withAlphaComponent(0.9)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 30
        button.layer.borderColor = UIColor.gray8.cgColor
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 6)
        return button
    }()
    
    // MARK: - Data
    private var imageURL: String
    private var isCustomizing = true
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    init(imageURL: String) {
        self.imageURL = imageURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupViews()
        setupToolPicker()
        setupNavigationBarWhenEditing()
        loadImage()
        handleNotification()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCanvasFrameToImage()
    }
    
    // MARK: - Setup
    private func setupViews() {
        imageView.contentMode = .scaleAspectFit
        imageView.frame = view.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(imageView)
        
        canvasView.backgroundColor = .clear
        canvasView.alwaysBounceVertical = false
        canvasView.alwaysBounceHorizontal = false
        canvasView.drawingPolicy = .anyInput
        view.addSubview(canvasView)
        
        saveButton.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            saveButton.widthAnchor.constraint(equalToConstant: 130),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupToolPicker() {
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        if #available(iOS 13.0, *) {
            toolPicker.overrideUserInterfaceStyle = .dark
        }
        canvasView.becomeFirstResponder()
    }
    
    private func handleNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(undoRedoChanged),
            name: .NSUndoManagerDidUndoChange,
            object: canvasView.undoManager
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(undoRedoChanged),
            name: .NSUndoManagerDidRedoChange,
            object: canvasView.undoManager
        )
    }
    
    @objc func undoRedoChanged() {
        let canUndo = canvasView.undoManager?.canUndo ?? false
        let canRedo = canvasView.undoManager?.canRedo ?? false
        undoButton?.isEnabled = canUndo
        redoButton?.isEnabled = canRedo
    }
    
    // MARK: - Image Loading
    private func loadImage() {
        guard let url = URL(string: imageURL) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data),
                  error == nil else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
                self.updateCanvasFrameToImage()
                self.canvasView.drawing = PKDrawing()
            }
        }.resume()
    }
    
    // MARK: - Canvas Frame Fit
    private func imageFrameInImageView() -> CGRect {
        guard let image = imageView.image else { return .zero }
        let imageRatio = image.size.width / image.size.height
        let viewRatio = imageView.bounds.width / imageView.bounds.height
        
        var scale: CGFloat
        var size = CGSize.zero
        
        if imageRatio > viewRatio {
            scale = imageView.bounds.width / image.size.width
        } else {
            scale = imageView.bounds.height / image.size.height
        }
        size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        
        let x = (imageView.bounds.width - size.width) / 2
        let y = (imageView.bounds.height - size.height) / 2
        return CGRect(origin: CGPoint(x: x, y: y), size: size)
    }
    
    private func updateCanvasFrameToImage() {
        canvasView.frame = imageFrameInImageView()
    }
    
    // MARK: - NavigationBar
    private func setupNavigationBarWhenEditing() {
        undoButton = UIBarButtonItem(image: UIImage(resource: .iconUndo), style: .plain, target: self, action: #selector(undoDrawing))
        redoButton = UIBarButtonItem(image: UIImage(resource: .iconRedo), style: .plain, target: self, action: #selector(redoDrawing))
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelCustom)),
            undoButton!,
            redoButton!
        ]
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "완료", style: .plain, target: self, action: #selector(finishCustom))
        navigationItem.leftBarButtonItems?.forEach {
            $0.tintColor = .white
        }
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    private func setupNavigationBarWhenFinishEditing() {
        navigationItem.leftBarButtonItems = nil
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(resource: .iconCheveronLeft), style: .plain, target: self, action: #selector(cancelCustom))
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(resource: .iconHome), style: .plain, target: self, action: #selector(popToMain))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    private func toggleNavigationBar() {
        isCustomizing.toggle()
        isCustomizing ? setupNavigationBarWhenEditing() : setupNavigationBarWhenFinishEditing()
    }
    
    @objc private func cancelCustom() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func undoDrawing() {
        if canvasView.undoManager?.canUndo == true {
            canvasView.undoManager?.undo()
        }
    }
    
    @objc private func redoDrawing() {
        if canvasView.undoManager?.canRedo == true {
            canvasView.undoManager?.redo()
        }
    }
    
    @objc private func finishCustom() {
        toolPicker.setVisible(false, forFirstResponder: canvasView)
        saveButton.isHidden = false
        toggleNavigationBar()
    }
    
    @objc private func popToMain() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Export
    func exportCombinedImage() -> UIImage? {
        guard let baseImage = imageView.image else { return nil }
        UIGraphicsBeginImageContextWithOptions(baseImage.size, false, baseImage.scale)
        
        baseImage.draw(in: CGRect(origin: .zero, size: baseImage.size))
        let scaleX = baseImage.size.width / canvasView.bounds.width
        let scaleY = baseImage.size.height / canvasView.bounds.height
        
        let drawingImage = canvasView.drawing.image(from: canvasView.bounds, scale: baseImage.scale)
        drawingImage.draw(in: CGRect(
            origin: .zero,
            size: CGSize(
                width: canvasView.bounds.width * scaleX,
                height: canvasView.bounds.height * scaleY)
        ))
        
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return combinedImage
    }
    
    // MARK: - Save / Share
    @objc private func saveImage() {
        guard let combinedImage = exportCombinedImage() else { return }
        UIImageWriteToSavedPhotosAlbum(
            combinedImage,
            self,
            #selector(saveCompleted(_:didFinishSavingWithError:contextInfo:)),
            nil)
    }
    
    @objc private func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let alert = UIAlertController(
            title: error == nil ? "저장이 완료되었습니다." : "저장 중 오류가 발생했습니다.",
            message: error == nil ? nil : "다시 시도해주세요.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
