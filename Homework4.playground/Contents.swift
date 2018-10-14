class Company {
    weak var ceo: CEO?
    
    deinit {
        print("Company deallocated")
    }
}

class Person {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("\(name) deallocated")
    }
}

class CEO: Person {
    weak var productManager: ProductManager?
    
    lazy var printProductManager = { [weak self] in
        guard let productManager = self?.productManager else {
            print("No pm in our company")
            return
        }
        print("Our Product Manager: \(productManager.name)")
    }
    
    lazy var printDevelopers = { [weak self] in
        guard let developers = self?.productManager?.developers else {
            print("No developers in our company")
            return
        }
        let developerNames = developers.map({ $0.name }).joined(separator: ", ")
        print("Our Developers: \(developerNames)")
    }
    
    lazy var printCompany = { (pm: ProductManager) in
        let ceoName = pm.ceo?.name ?? "none"
        print ("Our CEO: \(ceoName)")
        print("Our Product Manager: \(pm.name)")
        let developerNames = pm.developers.map({ $0.name }).joined(separator: ", ")
        print("Our Developers: \(developerNames)")
    }
}

class ProductManager: Person {
    var developers: [Developer] = []
    
    weak var ceo: CEO?
}

class Developer: Person {
    weak var pm: ProductManager?
    
    func sayToDeveloper(by name: String, message: String) {
        guard let developer = pm?.developers.first(where: { $0.name == name }) else {
            print("No \(name) in our company")
            return
        }
        
        print("[\(self.name) to \(developer.name)]: \(message)")
    }
    
    func sayToProductManager(message: String) {
        guard let pm = pm else {
            print("No product manager in our company")
            return
        }
        
        print("[\(self.name) to \(pm.name)]: \(message)")
    }
    
    func sayToCEO(message: String) {
        guard let ceo = pm?.ceo else {
            print("No CEO in our company")
            return
        }
        
        print("[\(self.name) to \(ceo.name)]: \(message)")
    }
}

func createCompany(ceo: CEO, productManager: ProductManager, developers: [Developer]) -> Company {
    ceo.productManager = productManager
    
    productManager.ceo = ceo
    productManager.developers = developers
    developers.forEach { $0.pm = productManager }
    
    let company = Company()
    company.ceo = ceo
    return company
}


func main() {
    let ceo = CEO(name: "CEO")
    let pm = ProductManager(name: "pm")
    let dev1 = Developer(name: "dev1")
    let dev2 = Developer(name: "dev2")
    
    let company = createCompany(ceo: ceo, productManager: pm, developers: [dev1, dev2])
    
    dev1.sayToDeveloper(by: "dev2", message: "Take my PR, please")
    dev2.sayToDeveloper(by: "dev1", message: "Later")
    
    dev1.sayToProductManager(message: "I want more tasks")
    dev2.sayToProductManager(message: "I have some extras")
    
    dev1.sayToCEO(message: "I want more money")
    dev2.sayToCEO(message: "Me too")
    
    ceo.printCompany(pm)
    ceo.printDevelopers()
    ceo.printProductManager()
}

main()
