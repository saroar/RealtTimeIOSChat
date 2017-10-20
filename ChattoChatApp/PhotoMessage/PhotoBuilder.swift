//
//  PhotoBuilder.swift
//  ChattoChatApp
//
//  Created by Alif on 17/10/2017.
//  Copyright © 2017 Alif. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class photoViewModel: PhotoMessageViewModel<PhotoModel> {
    
    override init(photoMessage: PhotoModel, messageViewModel: MessageViewModelProtocol) {
    
        super.init(photoMessage: photoMessage, messageViewModel: messageViewModel)
    
    }

}

class PhotoBuilder: ViewModelBuilderProtocol {
    
    let defualtBuilder = MessageViewModelDefaultBuilder()
    
    func canCreateViewModel(fromModel decoratedPhotoMessage: Any) -> Bool {
        return decoratedPhotoMessage is PhotoModel
    }
    
    func createViewModel(_ decoratedPhotoMessage: PhotoModel) -> photoViewModel {
    
        let photoMessageModel = photoViewModel(photoMessage: decoratedPhotoMessage, messageViewModel: defualtBuilder.createMessageViewModel(decoratedPhotoMessage))
        
        return photoMessageModel
    
    }
}
