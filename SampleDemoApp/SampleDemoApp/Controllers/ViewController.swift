//
//  ViewController.swift
//  SampleDemoApp
//
//  Created by Subhankar on 26/06/19.
//  Copyright © 2019 Subhankar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indianRupeeButton: UIButton!
    @IBOutlet weak var arabDirhamButton: UIButton!
    @IBOutlet weak var saudiRiyalButton: UIButton!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!    
    var homeViewModel: HomeViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
        prepareUI()
        homeViewModel = HomeViewModel()
        homeViewModel?.fetchData()
        observeEvents()
    }
    func prepareCollectionView() {
        collectionView.dataSource = self
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionViewFlowLayout.minimumLineSpacing = self.view.frame.size.width * 0.1
        collectionViewFlowLayout.minimumInteritemSpacing = self.view.frame.size.width * 0.1
        ProductCollectionViewCell.registerWithCollectionView(collectionView)
    }
    func prepareUI() {
        indianRupeeButton.layer.cornerRadius = 3
        indianRupeeButton.layer.borderWidth = 1
        indianRupeeButton.layer.borderColor = UIColor.black.cgColor
        arabDirhamButton.layer.cornerRadius = 3
        arabDirhamButton.layer.borderWidth = 1
        arabDirhamButton.layer.borderColor = UIColor.black.cgColor
        saudiRiyalButton.layer.cornerRadius = 3
        saudiRiyalButton.layer.borderWidth = 1
        saudiRiyalButton.layer.borderColor = UIColor.black.cgColor
    }
    func observeEvents() {
        homeViewModel?.reloadCollection = { [weak self] in
            DispatchQueue.main.async {
                self?.titleLabel.text = self?.homeViewModel?.completeData?.title
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self?.updateTimerLabel), userInfo: nil, repeats: true)
                self?.collectionView.reloadData()
            }
        }
    }
    @objc func updateTimerLabel() {
        self.timeLeftLabel.text = self.homeViewModel?.updateTimeLabel()
    }

    @IBAction func indianRupeeTapped(_ sender: UIButton) {
        self.homeViewModel?.setPriceCurrency = "INR"
        self.updateSelectedButtonUI(inr: true, aed: false, sar: false)
        self.collectionView.reloadData()
    }
    @IBAction func arabDirhamButtonTapped(_ sender: UIButton) {
        self.homeViewModel?.setPriceCurrency = "AED"
        self.updateSelectedButtonUI(inr: false, aed: true, sar: false)
        self.collectionView.reloadData()
    }
    @IBAction func saudiRiyalButtonTapped(_ sender: UIButton) {
        self.homeViewModel?.setPriceCurrency = "SAR"
        self.updateSelectedButtonUI(inr: false, aed: false, sar: true)
        self.collectionView.reloadData()

    }
    
    func updateSelectedButtonUI(inr: Bool, aed: Bool, sar: Bool) {
        self.indianRupeeButton.backgroundColor = UIColor.white
        self.arabDirhamButton.backgroundColor = UIColor.white
        self.saudiRiyalButton.backgroundColor = UIColor.white
        
        if inr {
            self.indianRupeeButton.backgroundColor = UIColor(red: 163/255, green: 208/255, blue: 255/255, alpha: 1.0)
        }
        if aed {
            self.arabDirhamButton.backgroundColor = UIColor(red: 163/255, green: 208/255, blue: 255/255, alpha: 1.0)
        }
        if sar {
            self.saudiRiyalButton.backgroundColor = UIColor(red: 163/255, green: 208/255, blue: 255/255, alpha: 1.0)
        }
    }
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = self.homeViewModel?.completeData?.product.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier, for: indexPath) as? ProductCollectionViewCell {
            if let productData = self.homeViewModel?.completeData?.product[indexPath.row] {
                cell.configureCell(data: productData)
                cell.productPriceLabel.text = self.homeViewModel?.updatePrice(from: productData.currency, price: productData.price)
            }
            return cell
        }
        return UICollectionViewCell()
    }
}
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width - 20, height: self.collectionView.frame.height)
    }
}
