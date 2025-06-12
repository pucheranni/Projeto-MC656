//
//  LoginServiceTest.swift
//  Projeto-MC656Tests
//
//  Created by Gab on 12/06/25.
//

import Testing
@testable import Projeto_MC656

struct LoginServiceTest {
    var sut: LoginService!

    init() {
        sut = LoginService()
    }

    @Test func validEmails() {
        let validEmails = [
            "a@b.co",
            "user+tag@domain.com",
            "user_name@domain.com",
            "user-name@domain.com",
            "user.name@domain.com",
            "a@b.c.d.e.f.g.h.co",
            "email@sub-domain.com",
            "1a@1.1a"
        ]

        for email in validEmails {
            do {
                try sut.checkEmail(email)
            } catch {
                Issue.record("E-mail válido lançou erro: \(email)")
            }
        }

    }

    @Test func invalidEmails() {
        let invalidEmails = [
            "a..b@domain.com",
            "user++name@domain.com",
            "user--name@domain.com",
            "user__name@domain.com",
            "user@@domain.com",
            "a.+b@domain.com",
            "a.-b@domain.com",
            "a._b@domain.com",
            "a.@domain.com",
            "user+-name@domain.com",
            "user+_name@domain.com",
            "user+@domain.com",
            "user-_name@domain.com",
            "user-@domain.com",
            "user_@domain.com",

            "user*name@domain.com",
            "user#name@domain.com",
            "user!name@domain.com",

            "user@name@domain.com",
            "user@domain..com",
            "user@domain-.com",
            "user@-domain.com",
            "user@domain.c",
            "user@domain.com.",
            "@domain.com",
            "user@",
            "user@domain",
            "user@domain.123",
            "1@1.11",
            "1a@1.11",
            "1@1.11a",

            "user name@domain.com",
            "user@domain .com",
            "user@domain. com"
        ]

        for email in invalidEmails {
            #expect(throws: ServiceError.invalidEmail, "E-mail inválido aceito: \(email)") {
                try sut.checkEmail(email)
            }
        }
    }

    @Test func validPasswordsDoNotThrow() {
        let validPasswords = [
            "Aa@123",
            "1Abc12#"
        ]

        for password in validPasswords {
            do {
                try sut.checkPassword(password)
            } catch {
                Issue.record("Senha válida lançou erro: \(password)")
            }
        }
    }

    @Test func invalidPasswordsThrowError() {
        let invalidPasswords = [
            "senha123",
            "SENHA@123",
            "SenhaSemNum*",
            "A1b@a",
            "123456",
            "!@#$%^&*",
            ""
        ]

        for password in invalidPasswords {
            #expect(throws: ServiceError.invalidPassword, "E-mail inválido aceito: \(password)") {
                try sut.checkPassword(password)
            }
        }
    }
}
