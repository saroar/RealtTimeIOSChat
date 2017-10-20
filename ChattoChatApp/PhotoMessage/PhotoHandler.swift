//
//  PhotoHandler.swift
//  ChattoChatApp
//
//  Created by Alif on 17/10/2017.
//  Copyright © 2017 Alif. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class PhotoHandler: BaseMessageInteractionHandlerProtocol {
    
    func userDidTapOnFailIcon(viewModel: photoViewModel, failIconView: UIView) {
        print("TapOnFail")
    }
    
    func userDidTapOnAvatar(viewModel: photoViewModel) {
        print("TapOnAvatar")
    }
    
    func userDidTapOnBubble(viewModel: photoViewModel) {
        print("TapOnBubble")
    }
    
    func userDidBeginLongPressOnBubble(viewModel: photoViewModel) {
        print("BeginLongPressOnBubble")
    }
    
    func userDidEndLongPressOnBubble(viewModel: photoViewModel) {
        print("EndLongPressOnBubble")
    }
}

