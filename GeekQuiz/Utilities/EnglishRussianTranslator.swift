//
//  EnglishRussianTranslator.swift
//  GeekQuiz
//
//  Created by Egor on 18.08.2021.
//

import Foundation
import MLKit

class EnglishRussianTranslator {
    
    private let translator: Translator
    
    init() {
        let options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .russian)
        translator = Translator.translator(options: options)
    }
    
    func translate(text: String, completion: @escaping (String) -> Void) {
        
        let conditions = ModelDownloadConditions(
            allowsCellularAccess: false,
            allowsBackgroundDownloading: true
        )
        translator.downloadModelIfNeeded(with: conditions) { [weak self] error in
            
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self.translator.translate(text) { translatedText, error in
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let translatedText = translatedText else { return }
                completion(translatedText)
            }
        }
    }
}
