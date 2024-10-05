/*
 Copyright 2024 Adobe. All rights reserved.
 This file is licensed to you under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License. You may obtain a copy
 of the License at http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software distributed under
 the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
 OF ANY KIND, either express or implied. See the License for the specific language
 governing permissions and limitations under the License.
 */

import UIKit
import AEPMessaging
import AEPSwiftUI
import SwiftUI

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView : UITableView!
    
    var savedCards : [ContentCardUI] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let homePageSurface = Surface(path: "homepage")
        AEPSwiftUI.getContentCardsUI(for: homePageSurface,
                                     customizer: HomePageCardCustomizer(),
                                     listener: self) { result in
            switch result {
            case .success(let cards):
                self.savedCards = cards
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                

            case .failure(let error):
                print(error)
                
            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

         // Remove any existing SwiftUI hosting view to avoid stacking
         cell.contentView.subviews.forEach { $0.removeFromSuperview() }

         // Get the SwiftUI view for the current card
         let contentCard = savedCards[indexPath.row]
         let swiftUIView = contentCard.view

         // Wrap the SwiftUI view in a UIHostingController
         let hostingController = UIHostingController(rootView: swiftUIView)
         hostingController.view.translatesAutoresizingMaskIntoConstraints = false

         // Add the hosting controller's view to the cell's content view
         cell.contentView.addSubview(hostingController.view)

         // Set up constraints to make the SwiftUI view fill the cell
         NSLayoutConstraint.activate([
             hostingController.view.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
             hostingController.view.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant:  -10),
             hostingController.view.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
             hostingController.view.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -10)
         ])

         return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedCards.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

extension ViewController : ContentCardUIEventListening {
    func onDisplay(_ card: ContentCardUI) {
        print("TestAppLog:  Content Card Displayed")
    }
    
    func onDismiss(_ card: ContentCardUI) {
        print("TestAppLog:  Content Card Dismissed")
    }
    
    func onInteract(_ card: ContentCardUI, _ interactionId: String, actionURL: URL?) -> Bool {
        print("TestAppLog:  Content Card Interacted. Interaction ID \(interactionId)")
        return false
    }
}

class HomePageCardCustomizer : ContentCardCustomizing {
    
    func customize(template: SmallImageTemplate) {
        // customize UI elements
        template.title.textColor = .primary
        template.title.font = .subheadline
        template.body?.textColor = .secondary
        template.body?.font = .caption
        template.buttons?.first?.text.font = .system(size: 13)
        
        // customize stack structure
        template.rootHStack.spacing = 10
        template.textVStack.alignment = .leading
        template.textVStack.spacing = 10
        
        // add custom modifiers
        template.buttonHStack.modifier = AEPViewModifier(ButtonHStackModifier())
        template.rootHStack.modifier = AEPViewModifier(RootHStackModifier())
        
        // customize the dismiss buttons
        template.dismissButton?.image.iconColor = .primary
        template.dismissButton?.image.iconFont = .system(size: 10)
    }
    
    struct RootHStackModifier : ViewModifier {
        func body(content: Content) -> some View {
             content
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing)
         }
    }
    
    struct ButtonHStackModifier : ViewModifier {
        func body(content: Content) -> some View {
             content
                .frame(maxWidth: .infinity, alignment: .trailing)
         }
    }
}
