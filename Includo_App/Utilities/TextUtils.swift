import Foundation
let descDetailed = [
"W tej aktywności możesz namalować dowolny obrazek, używając wybranych przez siebie kolorów, jednocześnie doskonaląc swoje umiejętności okulomotoryczne. Gra została zaprojektowana w celu wspierania neuropatyczności oraz poprawy koordynacji wzrokowo-ruchowej. Dzięki temu nie tylko rozwijasz kreatywność, ale także angażujesz się w trening funkcji poznawczych i percepcyjnych.",
"W tej dynamicznej aktywności Twoim celem jest podążać wzrokiem za poruszającą się monetą w wyznaczonym limicie czasowym. Z każdym kolejnym poziomem czas na interakcję się skraca, co wymaga od Ciebie coraz szybszej reakcji i precyzyjnego śledzenia ruchu. Gra została zaprojektowana w celu wspierania zdolności adaptacyjnej mózgu oraz poprawy refleksu wzrokowo-motorycznego. Dzięki regularnemu treningowi nie tylko zwiększasz swoją koncentrację i koordynację wzrokowo-ruchową, ale także angażujesz się w rozwój funkcji poznawczych i percepcyjnych.",
"W tej angażującej aktywności Twoim zadaniem jest skupienie spojrzenia na określonym kształcie, a następnie wybranie podobnego spośród losowo pojawiających się na ekranie opcji, które zjeżdżają z góry na dół. Szybkość pojawiania się kształtów oraz ich rozmieszczenie wymagają precyzyjnego rozpoznawania i szybkiej reakcji. Gra została zaprojektowana, aby wspierać zdolność neuroadaptacyjną oraz poprawiać koncentrację i percepcję wzrokową. Regularny trening nie tylko rozwija umiejętności rozpoznawania kształtów, ale także wzmacnia koordynację wzrokowo-ruchową i funkcje poznawcze. Interaktywne wyzwania oraz dynamicznie zmieniające się poziomy zapewniają ciągłą stymulację umysłową, wspierając terapię i rozwój umysłowy.",
"Twoim celem jest kierowanie wzrokiem na wybrane czerwone kwadraty w siatce, aby zmieniły swój kolor na biały. Prosta, ale angażująca mechanika gry sprawia, że każda sesja treningowa staje się unikalnym wyzwaniem dla Twojego umysłu. Gra została stworzona z myślą o wspieraniu zdolności adaptacyjne, poprawie koncentracji oraz rozwijaniu percepcji wzrokowej. Regularne granie nie tylko wzmacnia koordynację wzrokowo-ruchową oraz funkcje poznawcze, ale także wspiera elastyczność mózgu. Dynamicznie zmieniające się poziomy i różnorodność układów siatki zapewniają ciągłą stymulację umysłową, co czyni grę idealnym narzędziem zarówno do rozrywki, jak i terapii.",
    "",
    "",
    "",
    ""
]
let desc = [
    "Spójrz na świat pełnią barw. Rysuj, maluj i daj się ponieść fantazji!",
    "W skrzynce leży złota moneta. Ciekawe czemu nikt jej jeszcze nie wziął...",
    "Czy jesteś wystarczająco szybki aby złapać wszystkie gwiazdki?",
    "Czy przewidzisz kolejny ruch?",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    ""
]
let titles = [
    "Eye Paint",
    "Chasing Fortune",
    "Falling Stars",
    "White Grid",
    "Key Game",
    "Swipe",
    "Smaller",
    "Look",
    "Box",
    "War",
    "Run"
]

class TextProvider{
    func returnLongDesc(_ index : Int) -> String{
        return descDetailed[index]
    }
    func returnShortDesc(_ index : Int) -> String{
        return desc[index]
    }
    func returnTitles(_ index : Int) -> String{
        return titles[index]
    }
    func returnAllTitles() -> [String]{
        return titles
    }
}
class TextFormatter{
    func shortDescSize(_ index : Int) -> CGFloat{
        switch index {
        case 0:
            return 20
        case 1:
            return 20
        case 2:
            return 20
        case 3:
            return 20
        default:
            return 20
        }
    }
    
    func longDescSize(_ index : Int) -> CGFloat{
        switch index {
        case 0:
            return 18
        case 1:
            return 20
        case 2:
            return 20
        case 3:
            return 20
        default:
            return 20
        }
    }
    
}
