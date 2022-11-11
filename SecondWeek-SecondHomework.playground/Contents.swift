import Foundation

/*

 +Bahçemizde hayvanlarımız, bakıcılarımız olacak.
 +Hayvanat bahçemizin hem bir günlük su limiti hem de bit bütçesi olacak.
 +Hayvanat bahçesine gelir, gider eklemesi ve su limiti artırma yapılabilmelidir.
 +Hayvanların su tüketimleri, sesleri olmalı
 +Her hayvanın tek bakıcısı olmalıdır ancak bakıcılar birden fazla hayvana bakabilmelidir.
 +Bulunan hayvanların su tüketimleri günlük limitten düşmelidir.
 +Bakıcıların maaş ödemelerini yapılabilmeli. Hesap formulü kararı size bırakılmıştır.
 +Sonradan bakıcı ve hayvan eklemesi yapılabilmelidir.
 +Aynı hayvandan 1 den fazla olabilmelidir.
 +Protocol, closure, optional, computed property kullanımı zorunludur.

 */
print("2. Ödev ----------------------------------------------------------------------------------------------")
protocol AnimalKeeperWithAnimalDelegate {

}

protocol ZooWithAnimalDelegate {
  var willDailySpendWater: Double { get set }
  var waterLimit: Double? { get set }
  var willPayMoney: Double { get set }
  func willDailySpendWater(water amount: Double)
  func spendFromWaterLimit(water amount: Double)
  func addWillPayMoney(money amount: Double)
}


class Zoo: ZooWithAnimalDelegate {
  var willDailySpendWater: Double = 0.0
  var willPayMoney: Double = 0.0
  var louseBudget: Double?
  var waterLimit: Double?

  init(louseBudget: Double, waterLimit: Double) {
    self.louseBudget = louseBudget
    self.waterLimit = waterLimit
    printSituationOfZoo()
  }

  // gelir ekle
  func newMoneyAddedToBudget(add money:Double){
    louseBudget! += money
    print("--")
    print("--------------- Bütçeye yeni para ekleniyor: \(money) --------")
    print("--")
    printSituationOfZoo()
  }

  // gider çıkar
  func substractMoneyFromBudget(substract money:Double){
    if (louseBudget! < money) {
      print("--")
      print("Bütçede yeterli miktarda para bulunmamakta.")
      print("--")
    } else {
      louseBudget? -= money
      print("--")
      print("--------------- Bütçeden para eksiliyor: \(money) --------")
      print("--")
    }
    printSituationOfZoo()
  }

  // su limiti artır
  func extendWaterLimit(water amount: Double){
    waterLimit! += amount
    print("--")
    print("--------------- Su limiti artırılıyor.: \(amount) --------")
    print("--")
    printSituationOfZoo()
  }

  func spendFromWaterLimit(water amount: Double){
    if (waterLimit! < amount) {
      print("--")
      print("--------------- Yeterli Su Bulunmamaktadır.:--------")
      print("--")
    } else {
      waterLimit! -= amount
      print("--")
      print("--------------- Su limitinden düşülüyor.: \(amount) --------")
      print("--")
    }
    printSituationOfZoo()
  }

  func willDailySpendWater(water amount: Double){
    willDailySpendWater += amount
    print("--")
    print("--------------- Günlük harcanacak su miktarına ekleme yapıldı.: \(amount) --------")
    print("--")
    printSituationOfZoo()
  }

  func dailyWaterSpentFromWaterLimit(){
    spendFromWaterLimit(water: willDailySpendWater)
    print("--")
    print("Su limitinden harcanması gereken su miktarı çıkarıldı.")
    print("--")
    printSituationOfZoo()
  }

  func payAllAnimalKeepersMoney(){
    if (louseBudget! < willPayMoney){
      print("--")
      print("Bütçede yeterli miktarda para bulunmamakta.")
      print("--")
    } else {
      louseBudget! -= willPayMoney
      print("--------------- Bakıcı maaşları ödeniyor --------")
      print("--")
      print("--------------- Ödenen bakıcı maaşı toplamı \(willPayMoney) --------")
      print("--")
    }
    printSituationOfZoo()
  }

  func addWillPayMoney(money amount: Double){
    willPayMoney += amount
  }

  func printSituationOfZoo(){
    print("--------------- Hayvanat Bahçesi Bilgileri -----------------")
    print("Hayvanat Bahçesi Bütçesi: \(louseBudget!)")
    print("Hayvanat Bahçesi Su Limiti: \(waterLimit!)")
    print("--------------------------------------------------")
  }

}

class Animal {
  let animalName: String?
  let animalSound: String?
  var waterSpend: Double?
  var delegate1: AnimalKeeperWithAnimalDelegate?
  var delegate2: ZooWithAnimalDelegate?

  init(animalName: String, animalSound:String, waterSpend: Double, delegate1: AnimalKeeperWithAnimalDelegate, delegate2: ZooWithAnimalDelegate){
    self.animalName = animalName
    self.animalSound = animalSound
    self.waterSpend = waterSpend
    self.delegate1 = delegate1
    self.delegate2 = delegate2
    addWillDailySpendWater()
  }

  // ses
  func animalSpeak(speaks: () -> Void){
    print("Hayvan Konuşuyor: \(animalSound!)")
    speaks()
  }

  // su limitinde harcandı
  func addWillDailySpendWater(){
    self.delegate2?.willDailySpendWater(water: waterSpend!)
  }

}

class AnimalKeeper: AnimalKeeperWithAnimalDelegate {
  let name: String?
  var income: Double? {
    return Double(name!.count) * 1000.0
  }
  var delegate: ZooWithAnimalDelegate?

  init(name: String, delegate: ZooWithAnimalDelegate){
    self.name = name
    self.delegate = delegate
    addedToWillPayMoney()
  }

  func addedToWillPayMoney(){
    self.delegate?.addWillPayMoney(money: income!)
  }

}

let gaziantepZoo = Zoo(louseBudget: 500_000, waterLimit: 1999.0)

let bakiciAhmet = AnimalKeeper(name: "Ahmet", delegate: gaziantepZoo)

let bakiciHuseyin = AnimalKeeper(name: "Huseyin", delegate: gaziantepZoo)

let esek1 = Animal(animalName: "Eşek", animalSound: "Aii Aii", waterSpend: 100, delegate1: bakiciAhmet, delegate2: gaziantepZoo)
let esek2 = Animal(animalName: "Eşek2", animalSound: "Aii Aii", waterSpend: 100, delegate1: bakiciHuseyin, delegate2: gaziantepZoo)

let maymun1 = Animal(animalName: "Maymun1", animalSound: "OOo OOo", waterSpend: 200, delegate1: bakiciHuseyin, delegate2: gaziantepZoo)

gaziantepZoo.newMoneyAddedToBudget(add: 200_000)

gaziantepZoo.substractMoneyFromBudget(substract: 100_000)

gaziantepZoo.extendWaterLimit(water: 1000.0)

esek1.animalSpeak {
  print("Eşek bu şekilde konuşur.")
}

maymun1.animalSpeak {
  print("Maymun ise daha farklı gördüğünüz gibi")
}

gaziantepZoo.dailyWaterSpentFromWaterLimit()

gaziantepZoo.payAllAnimalKeepersMoney()
