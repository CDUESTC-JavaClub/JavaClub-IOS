//
//  JCEulaViewController.swift
//  JavaClub
//
//  Created by Roy Rao on 2021/11/6.
//

import UIKit
import PDFKit

class JCEulaViewController: UIViewController {
    private let pdfView = PDFView(frame: .zero)
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(dismissSelf)
        )
        
        view.addSubview(pdfView)
        
        if
            let url = Bundle.main.url(forResource: "EULA", withExtension: "pdf"),
            let document = PDFDocument(url: url)
        {
            pdfView.document = document
            pdfView.delegate = self
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pdfView.frame = view.bounds
    }
    
    @objc func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}


extension JCEulaViewController: PDFViewDelegate {
    
    func pdfViewWillClick(onLink sender: PDFView, with url: URL) {
        UIApplication.shared.open(url)
    }
}
