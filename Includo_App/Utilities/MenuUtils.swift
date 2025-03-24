import Foundation
class Utils{
    func calculateSize(_ index : Int, _ selectedIndex : Int, _ array : Array<Any>, _ maxWidth : Int, _ maxHeight : Int) -> (CGFloat, CGFloat){
        if !(index == selectedIndex){
            let onRight = recurringIncrease(selectedIndex, array)
            let onLeft = recurringDecrease(selectedIndex, array)
            if index == onRight || index == onLeft{
                return (CGFloat(maxWidth - maxWidth/3), CGFloat(maxHeight - maxHeight/3))
            }
            return (CGFloat(maxWidth - maxWidth/2), CGFloat(maxHeight - maxHeight/2))
        }
        return (CGFloat(maxWidth), CGFloat(maxHeight))
    }
    func calculateOpacity(_ index : Int, _ selectedIndex : Int, _ array : Array<Any>, _ maxOpacity : Double) -> Double{
        if !(index == selectedIndex){
            let onRight = recurringIncrease(selectedIndex, array)
            let onLeft = recurringDecrease(selectedIndex, array)
            if index == onRight || index == onLeft{
                return maxOpacity / 5
            }
            return maxOpacity / 20
        }
        return maxOpacity
    }
    func calculateZIndex(_ index : Int, _ selectedIndex : Int, _ array : Array<Any>) -> Double{
        if !(index == selectedIndex){
            let onRight = recurringIncrease(selectedIndex, array)
            let onLeft = recurringDecrease(selectedIndex, array)
            if index == onRight || index == onLeft{
                return 2
            }
            return 1
        }
        return 3
    }
    func degreeToRad(_ degree : Double) -> Double{
        return degree * .pi / 180
    }
    func recurringDecrease(_ index : Int, _ array : Array<Any>) -> Int{
        guard !array.isEmpty else { return index }
        if index == 0{
            return array.count-1
        }else{
            return index - 1
        }
    }
    func recurringIncrease(_ index : Int, _ array : Array<Any>) -> Int{
        guard !array.isEmpty else { return index }
        if index == array.count - 1{
            return 0
        }else{
            return index + 1
        }
    }
}
