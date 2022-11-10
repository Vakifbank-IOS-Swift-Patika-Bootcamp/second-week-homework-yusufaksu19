import Foundation

/*

       1- Playground üzerinden bir şirket yazılımı oluşturacağız. Aşağıdaki maddeler yazılımda karşılanmalıdır.
       Şirketimizin isim, çalışan, bütçe, kuruluş yılı olacak
       Şirketimize playground arayüzünden gelir ekleyip gider çıkışı sağlayabilmeliyim.
       Şirkete çalışan ekleyebilmeliyim.
       Çalışanlar için en az isim, yaş, medeni hal tutulmalı.
       En az 3 çalışan tipi olmalı. Jr. Mid. Sr. gibi
       Çalışanların maaşları yaş ve tip arasında bir formül belirleyerek hesaplanmalı. yaş * tip_katsayısı * 1000 gibi
       Şirketimin maaş ödemesini yapan bir metodu olmalı.
       Ödenen maaşlar bütçeden düşmeli
       Maaş ödemesi yapıldıktan sonra yazılım bana ekstra yapabileceğim komutlara izin vermeli.
       Protocol, closure, optional kullanımı zorunludur.

*/
print("1. Ödev ----------------------------------------------------------------------------------------------")
enum EmployeeRank: Int{
  case junior = 10
  case mid = 20
  case senior = 30
}

enum EmployeeRelationShip: String{
  case single = "Bekar"
  case engaged = "Nişanlı"
  case married = "Evli"
}


protocol CompanyEmployeeDelegate {
  var employeesTotalMoney: Double? { get set }
  var companyBudget: Double? { get set }
  var companyEmployeesCount: Int? { get set }
  func substractMoneyFromBudget(substract money: Double)
  func addMoneyToBudget(add money: Double)
  func addNewEmployee(count employee: Int)
  func calculateEmployeesTotalMoney(money amount: Double)
}

class Company: CompanyEmployeeDelegate{
  var companyBudget: Double?
  let companyName: String?
  var companyEmployeesCount: Int?
  let companyStartYear: String
  var employeesTotalMoney: Double? = 0.0


  init (companyName: String, companyEmployeesCount: Int, companyStartYear: String, companyBudget: Double) {
    self.companyName = companyName
    self.companyEmployeesCount = companyEmployeesCount
    self.companyStartYear = companyStartYear
    self.companyBudget = companyBudget
    printCompanyInformations()
  }

  func addMoneyToBudget(add money: Double){
    companyBudget? += money
    print("--")
    print("--------------- Bütçeye yeni para ekleniyor: \(money) --------")
    print("--")
    printCompanyInformations()
  }

  func substractMoneyFromBudget(substract money: Double){
    companyBudget? -= money
    print("--")
    print("--------------- Bütçeden para eksiliyor: \(money) --------")
    print("--")
    printCompanyInformations()
  }

  func addNewEmployee(count employee: Int){
    companyEmployeesCount! += employee
    print("--")
    print("--------------- Yeni Çalışan Ekleniyor: \(employee) --------")
    print("--")
    printCompanyInformations()
  }

  func calculateEmployeesTotalMoney(money amount: Double){
    self.employeesTotalMoney! += amount
    print("--")
    print("--------------- Çalışanlara Ödenmesi Gereken Para Güncelleniyor Artış Miktarı:  \(amount) -------- Toplam Ulaşılan Mebla: \(self.employeesTotalMoney!)")
    print("--")
  }

  func payMoneyToAllEmployees(completed: () -> Void){
    print("--")
    print("--------------- Çalışanlara Ödenmesi Gereken Para Toplamı: \(employeesTotalMoney!) ödenesi yapıldı ve bütçeden çıkarıldı. --------")
    print("--")
    self.companyBudget! -= employeesTotalMoney!
    completed()
    printCompanyInformations()
  }

  func printCompanyInformations() {
    print("--------------- Şirket Bilgileri -----------------")
    print("Şirket Adı: \(companyName!)")
    print("Şirketteki Çalışan Sayısı: \(companyEmployeesCount!)")
    print("Şirket Bütçesi: \(companyBudget!)")
    print("Şirket Kuruluş Yılı: \(companyStartYear)")
    print("--------------------------------------------------")
  }

}

class Employee {
  let employeeName: String?
  var employeeAge: Int?
  var employeeRelationship: EmployeeRelationShip?
  var employeeRank: EmployeeRank?
  var employeeReveneu: Double? = 0
  var delegate: CompanyEmployeeDelegate?

  init(employeeName: String, employeeAge: Int, employeeRelationship: EmployeeRelationShip, employeeRank: EmployeeRank, delegate: CompanyEmployeeDelegate) {
    print("--------------- Yeni Personel Oluşturuldu -----------------")
    self.employeeName = employeeName
    self.employeeAge = employeeAge
    self.employeeRelationship = employeeRelationship
    self.employeeRank = employeeRank
    self.delegate = delegate
    newEmployeeAdded()
    printPersonalInformation()
  }

  func calculateEmployeeSalary() -> Double {
    employeeReveneu = Double(employeeAge! * employeeRank!.rawValue * 100)
    print("--")
    print("--------------- Personel Maaşı Hesaplanıyor: \(employeeReveneu!) --------")
    print("--")
    printPersonalInformation()
    return employeeReveneu!
  }

  func newEmployeeAdded() {
    self.delegate?.addNewEmployee(count: 1)
    self.delegate?.calculateEmployeesTotalMoney(money: calculateEmployeeSalary())
  }

  func printPersonalInformation() {
    print("--------------- Personel Bilgileri -----------------")
    print("Personel Adı: \(employeeName!)")
    print("Personel Yaşı: \(employeeAge!)")
    print("Personel İlişki Durumu: \(employeeRelationship!.rawValue)")
    print("Personel Statüsü: \(employeeRank!)")
    print("Personel Maaşı: \(employeeReveneu!)")
    print("--------------------------------------------------")
  }

}



let appleCompany = Company(companyName: "Apple", companyEmployeesCount: 1000, companyStartYear: "1976", companyBudget: 1_000_000)

appleCompany.addNewEmployee(count: 100)
appleCompany.addMoneyToBudget(add: 2_000_000)
appleCompany.substractMoneyFromBudget(substract: 1_000_000)

let yusufEmployee = Employee(employeeName: "Yusuf Aksu", employeeAge: 27, employeeRelationship: .engaged, employeeRank: .junior, delegate: appleCompany)

let kaanEmployee = Employee(employeeName: "Kaan Tangöze", employeeAge: 30, employeeRelationship: .married, employeeRank: .mid, delegate: appleCompany)

let senaEmployee = Employee(employeeName: "Sena Şener", employeeAge: 40, employeeRelationship: .single, employeeRank: .senior, delegate: appleCompany)

appleCompany.payMoneyToAllEmployees {
  print("-- Ödemeler Tamamlandı.")
  print("-- ")
}


