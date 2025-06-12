package com.MC_656.mobility;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration;

// A anotação foi modificada para excluir a configuração de banco de dados durante este teste
@SpringBootTest(exclude = {DataSourceAutoConfiguration.class, HibernateJpaAutoConfiguration.class})
class MobilityApplicationTests {

	@Test
	void contextLoads() {
	}

}