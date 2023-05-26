//
//  main.swift
//  senhas-ios
//
//  Created by user on 24/05/23.
//

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
    static let fileManager = FileManager.default
    static var documentsDirectory: URL {
        return ViewModel.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    static var jsonURL: URL {
        return ViewModel.documentsDirectory.appendingPathComponent("passwords.json")
    }
    
    var passwords: [User] = []
    
    func login(username: String, password: String) -> Bool {
        print("Digite o nome de usuário:")
        if let _ = readLine() {
            print("Usuário logado com sucesso")
            return true
        } else {
            print("Usuário não encontrado")
            return false
        }
    }
    
    func loadAll() {
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: ViewModel.jsonURL)
            let objectDecoded = try decoder.decode(JSONPasswords.self, from: data)
            self.passwords = objectDecoded.passwords
        } catch {
            print("carregar as senhas")
        }
    }
    
    func saveAll() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(JSONPasswords(passwords: self.passwords))
            try data.write(to: ViewModel.jsonURL)
        } catch {
            print(" salvar as senhas")
        }
    }
    
    func alterarSenha(username: String, novaSenha: String) {
        if let userIndex = passwords.firstIndex(where: { $0.name == username }) {
            passwords[userIndex].senha = novaSenha
            print("Senha alterada com sucesso!")
        } else {
            print("Usuário não encontrado")
        }
        saveAll()
    }
    
    func delete(username: String) {
        if let userIndex = passwords.firstIndex(where: { $0.name == username }) {
            passwords.remove(at: userIndex)
            print("Usuário removido com sucesso!")
        } else {
            print("Usuário não encontrado")
        }
        saveAll()
    }
    
    func cadastroUser(name: String, senha: String, url: String, email: String) {
        let newUser = User(name: name, senha: senha, url: url, email: email)
        passwords.append(newUser)
        saveAll()
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
    
    func run() {
        while true {
            print("Selecione a operação:")
            print("1 - Inserir Senha")
            print("2 - Retirar Senha")
            print("3 - Listar Senhas")
            print("4 - Alterar Senha")
            print("5 - Deletar Usuário")
            print("9 - Sair")
            
            if let opcao = readLine() {
                switch opcao {
                case "1":
                    print("Digite o nome de usuário:")
                    if let username = readLine() {
                        print("Digite a senha:")
                        if let senhaDigitada = readLine() {
                            print("Digite a URL:")
                            if let url = readLine() {
                                print("Digite o email:")
                                if let email = readLine() {
                                    cadastroUser(name: username, senha: senhaDigitada, url: url, email: email)
                                    print("Senha inserida com sucesso!")
                                } else {
                                    print("Email inválido!")
                                }
                            } else {
                                print("URL inválida!")
                            }
                        } else {
                            print("Senha inválida!")
                        }
                    } else {
                        print("Nome de usuário inválido!")
                    }
                case "2":
                    if let senhaRetirada = senha.retirar() {
                        print("Senha retirada: \(senhaRetirada)")
                    } else {
                        print("Não há senhas disponíveis!")
                    }
                case "3":
                  let senhas = viewModel.passwords
                    if !senhas.isEmpty {
                     print("Senhas:")
                     for senha in senhas {
                      print("Usuário: \(senha.name)")
                      print("Senha: \(senha.senha)")
                      print("URL: \(senha.url)")
                      print("Email: \(senha.email)")
                      print("---")
                      }
                    } else {
                        print("Não há senhas cadastradas!")
                    }

                case "4":
                    print("Digite o nome de usuário:")
                    if let username = readLine() {
                        print("Digite a nova senha:")
                        if let novaSenha = readLine() {
                            alterarSenha(username: username, novaSenha: novaSenha)
                        } else {
                            print("Senha inválida!")
                        }
                    } else {
                        print("Nome de usuário inválido!")
                    }
                case "5":
                    print("Digite o nome de usuário:")
                    if let username = readLine() {
                        delete(username: username)
                    } else {
                        print("Nome de usuário inválido!")
                    }
                case "9":
                    return
                default:
                    print("Opção inválida!")
                }
            }
        }
    }
}

let viewModel = ViewModel()
viewModel.loadAll()
viewModel.run()
