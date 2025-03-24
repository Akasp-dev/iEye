import Foundation
import SwiftUI

func gameSelection(_ index : Int) -> AnyView{
    switch index {
    case 0:
        return AnyView(PaintingApp())
    case 1:
        return AnyView(CoinChaseView())
    case 2:
        return AnyView(FallingStarsView())
    case 3:
        return AnyView(WhiteTiles())
    case 4:
        return AnyView(KeyGameView())
    case 5:
        return AnyView(SwipeView())
    case 6:
        return AnyView(SmallerView())
    default:
        return AnyView(EmptyView())
    }
}
