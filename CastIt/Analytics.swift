//
//  Analytics.swift
//  CastIt
//
//  Created by Paulo Tadashi Tokikawa on 08/02/22.
//

import Foundation
import FirebaseAnalytics

// A classe que usamos para disparar eventos pro Firebase Analytics, intermediando o contato direto com a SDK do Firebase
class AnalyticsManager {
    static let shared = AnalyticsManager() // É um singleton
    private init() { }
    
    // Cataloga um evento
    func log(event: AnalyticsEvent) {
        Analytics.logEvent(event.name, parameters: event.asDict)
    }
}

// Enum que declaramos quais eventos queremos. Fazemos uso da featude do Swift de Enums com parâmetros, permitindo que nosso código sempre use os nomes corretos
enum AnalyticsEvent {
    case levelStart
    
    case levelEnd
    
    case levelScore(Double)
    
    case levelCastMisses(Int)
    
    case levelTime(TimeInterval)
    
    case levelScorePerSecond(Double)
    
    case castTimePerEnemy(TimeInterval)
    
    // O nome que queremos que o evento tenha no Firebase Analytics
    var name: String {
        switch self {
        case .levelStart:
            return "level_start"
        case .levelEnd:
            return "level_end"
        case .levelScore:
            return "level_score"
        case .levelCastMisses:
            return "level_cast_misses"
        case .levelTime:
            return "level_time"
        case .levelScorePerSecond:
            return "level_score_per_second"
        case .castTimePerEnemy:
            return "cast_time_per_enemy"
        }
    }
    
    // Dicionário com os parâmetros que vamos enviar no evento
    var asDict: [String: NSObject] {
        switch self {
        case .levelStart:
            return [:]
        case .levelEnd:
            return [:]
        case .levelScore(let score):
            return ["score": score as NSObject]
        case .levelCastMisses(let misses):
            return ["misses": misses as NSObject]
        case .levelTime(let time):
            return ["duration": time as NSObject]
        case .levelScorePerSecond(let scorePerSecond):
            return ["scorePerSecond": scorePerSecond as NSObject]
        case .castTimePerEnemy(let time):
            return ["cast_time": time as NSObject]
        }
    }
}
