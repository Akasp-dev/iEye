import SwiftUI
import Foundation

struct WarView : View {
    @State var playerCards = [(1,1),(10,1),(12,2)]
    @State var playerSymbols = [1,2,1]
    @State var enemyCard = 3
    @State private var opponentMoves = false
    @State var playerPoints : Int = 0
    @State var enemyPoints : Int = 0
    var body : some View {
        ZStack{
            Rectangle()
                .fill(.black)
                .ignoresSafeArea()
            Text("Gracz: \(playerPoints)  \nPrzeciwnik: \(enemyPoints)")
                .foregroundStyle(.white)
                .font(.custom("Montserrat", size: 30))
                .position(x: Sizes.width/9, y: Sizes.height/15)
            VStack(spacing: Sizes.height/4){
                EnemyCardView(typeOfCard: $enemyCard, opponentMoves: opponentMoves)
                HStack(spacing: 50){
                    ForEach($playerCards.indices, id: \.self){ index in
                        let card = $playerCards[index]
                        PlayerCardView(typeOfCard: card.0, symbol: card.1)
                            .onTapGesture {
                                if card.wrappedValue.0 > enemyCard {
                                    for x in 0...playerCards.count-1 {
                                        playerCards[x].0 = Int.random(in: 1...13)
                                    }
                                    enemyCard = Int.random(in: 1...13)
                                    playerPoints += 1
                                }
                                checkOpponentMove()
                            }
                    }
                }
            }
        }
    }
    func checkOpponentMove() {
        if !playerCards.contains(where: { $0.0 > enemyCard }) {
            withAnimation(.easeInOut(duration: 1)) {
                opponentMoves = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                opponentMoves = false
                enemyCard = Int.random(in: 1...13)
                for x in 0..<playerCards.count {
                    playerCards[x].0 = Int.random(in: 1...13)
                }
                enemyPoints += 1
            }
        }
    }
}

struct PlayerCardView : View {
    @Binding var typeOfCard : Int
    @Binding var symbol : Int
    var body : some View {
        Image("card_\(typeOfCard)_\(symbol)")
            .resizable()
            .frame(width: 180, height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
struct EnemyCardView : View {
    @Binding var typeOfCard : Int
    var opponentMoves: Bool
    var body : some View {
        Image("card_\(typeOfCard)_2")
            .resizable()
            .frame(width: 180, height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .offset(y: opponentMoves ? 120 : 0)
            .opacity(opponentMoves ? 0 : 1)
    }
}

#Preview {
    WarView()
}
