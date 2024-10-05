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

import SwiftUI
import AEPSwiftUI
import AEPMessaging

struct HomePage: View, ContentCardUIEventListening {
    
    @State var savedCards : [ContentCardUI] = []
    
    var body: some View {
        Spacer()
        Text("Content Cards").font(.title)
        ScrollView (.vertical, showsIndicators: false){
            LazyVStack(spacing: 20) {
                 ForEach(savedCards) { card in
                     card.view
                         .frame(width: 325, height: 110)
                         .overlay(
                             RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(.systemGray3), lineWidth: 1)
                         )
                }
            }
        }
        .padding()
        .onAppear() {
            let homePageSurface = Surface(path: "homepage")
            AEPSwiftUI.getContentCardsUI(for: homePageSurface,
                                         customizer: HomePageCardCustomizer(),
                                         listener: self) { result in
                switch result {
                case .success(let cards):
                    savedCards = cards
                    
                case .failure(let error):
                    print(error)
                    
                }
            }
        }
    }
    
    func onDisplay(_ card: ContentCardUI) {
        print("TestAppLog : ContentCard Displayed")
    }
    
    func onDismiss(_ card: ContentCardUI) {
        print("TestAppLog : ContentCard Dismissed")
        savedCards.removeAll(where: { $0.id == card.id })
    }
    
    func onInteract(_ card: ContentCardUI, _ interactionId: String, actionURL: URL?) -> Bool {
        print("TestAppLog : ContentCard Interacted : Interaction - \(interactionId)")
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

#Preview {
    HomePage()
}
