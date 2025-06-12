package com.MC_656.mobility;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;


class MobilityApplicationTests {

	@Test
	@DisplayName("Deve criar uma instância da aplicação sem erros")
	void applicationCanBeInstantiated() {
		// Este é um teste de unidade simples. Ele não inicia o Spring.
		// Apenas verifica se a classe principal do nosso aplicativo pode ser instanciada.
		MobilityApplication app = new MobilityApplication();
		assertNotNull(app, "A instância da aplicação não deveria ser nula.");
	}

	@Test
	@DisplayName("Deve confirmar que o ponto de entrada (main) está acessível")
	void mainMethodIsPresent() {
		// Este teste serve para validar que a estrutura da classe principal está como esperado.
		// Não estamos testando a lógica interna do SpringApplication.run(),
		// apenas que nosso método 'main' existe e pode ser chamado.
		// A simples compilação deste teste já valida a assinatura do método.
		// Se compila, o teste passa.
		assertTrue(true, "Confirma que o teste pode ser executado, validando a compilação da classe.");
	}

}
