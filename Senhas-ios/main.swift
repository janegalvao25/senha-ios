//
//  main.swift
//  senhas-ios
//
//  Created by user on 24/05/23.
//

//funcionalidades básicas e classes
import Foundation

struct User: Codable {
    var name: String
    var senha: String
    var url: String
    var email: String
}

struct JSONPasswords: Codable {
    var passwords: [User]
}


class ViewModel {
    // protocolo é conjunto de regras que indica que quem assina o protocolo tem que implementar as regras
    static let fileManager = FileManager.default
    // static é pra acessar sem instanciar ("acesso global") n muda com instancia
    static  var documentsDirectory: URL {
        return ViewModel.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    static var jsonURL: URL {
        return ViewModel.documentsDirectory.appendingPathComponent("passwords.json")
    }
    
    var passwords: [User] = []
    
    func create() {}
    
    func loadAll() {
        let decoder = JSONDecoder()
        do {
            let dado = try Data(contentsOf: ViewModel.jsonURL)
            let objectDecoded = try decoder.decode(JSONPasswords.self, from: dado)
            //frases.phrases = objectDecode.frases
            self.passwords = objectDecoded.passwords
        } catch{
            print("Erro")
        }
    }
    
    func update() {}

    func delete() {
        
    }

    var users: [User] = []
    func cadastroUser (name: String, senha: String, email: String ) -> User  {
        let newUser = User(name: name, senha: senha, url: <#String#>, email: email)
        users.append(newUser)
    }
    class Senha {
        private var itens: [String]
        
        init() {
            self.itens = []
        }
        
        func criarSenha() {
            self.itens = []
        }
        
        func inserir(_ item: String) {
            self.itens.append(item)
        }
        
        func retirar() -> String? {
            if !vazio() {
                return self.itens.remove(at: 0)
            }
            return nil
        }
        
        func listar() -> [String] {
            return self.itens
        }
        
        func vazio() -> Bool {
            return self.itens.isEmpty
        }
    }
    
    var senha = Senha()
}
while true {
    print("Selecione a operação:")
    print("1 - Inserir Senha")
    print("2 - Retirar Senha")
    print("3 - Listar Senhas")
    print("9 - Sair")
    
    if let opcao = readLine() {
        switch opcao {
        case "1":
            print("Digite a senha:")
            if let senhaDigitada = readLine() {
                senha.inserir(senhaDigitada)
                print("Senha inserida com sucesso!")
            } else {
                print("Senha inválida!")
            }
        case "2":
            if let senhaRetirada = senha.retirar() {
                print("Senha retirada: \(senhaRetirada)")
            } else {
                print("Não há senhas disponíveis!")
            }
        case "3":
            let senhas = senha.listar()
            if !senhas.isEmpty {
                print("Senhas:")
                for senha in senhas {
                    print(senha)
                }
            } else {
                print("Não há senhas cadastradas!")
            }
        case "9":
            break
        default:
            print("Opção inválida!")
        }
        
        if opcao == "9" {
            break
        }
    }
}



