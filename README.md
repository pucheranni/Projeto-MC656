# MC656 - Engenharia de Software

O software a ser desenvolvido é uma plataforma de mobilidade urbana que conecta pessoas 
com veículos não motorizados ociosos a pessoas que gostariam de utilizá-los. Essa plataforma tem 
como objetivo principal facilitar a locomoção de membros da comunidade acadêmica, pensando no 
escopo de adoção da prefeitura universitária e população em geral no caso de adoção da prefeitura 
de Campinas além do direito à cidade conforme previsto no artigo 2º, incisos I e II, do Estatuto da 
Cidade (Lei nº 10.257/2001), que reconhece o direito de todos os cidadãos a cidades democráticas, 
justas e ambientalmente sustentáveis. Os principais recursos incluem a retirada e devolução desses 
equipamentos, o cadastro de dados pessoais, verificação de documentos e pagamento. Além disso, 
haverá no app mapa da estação de devolução mais próxima do usuário, pesquisa com filtro por 
localização, avaliação de veículo e pessoal. Também são esperados recursos que incentivam e 
auxiliam o usuário a participar da plataforma, como por exemplo um sistema de avaliações (por parte 
de quem está emprestando um veículo e por parte de quem está usufruindo) e engajamento, através 
de conquistas (modelo de gamificação).

## Arquitetura da Aplicação

### Estilo Arquitetural Adotado:

Adotamos uma **Arquitetura em Camadas (Layered Architecture)** para o backend, combinada com uma abordagem orientada a **Serviços/Componentes**.

**Justificativa:** Este é um padrão bem estabelecido e comum para aplicações desenvolvidas com Spring Boot. Ele facilita uma clara **separação de responsabilidades** entre as diferentes partes do sistema:

*   **Camada de Apresentação (Presentation Layer):** Lida com a interface com o usuário (neste caso, a API REST).
*   **Camada de Serviço (Service Layer):** Contém a lógica de negócio da aplicação.
*   **Camada de Acesso a Dados (Data Access Layer):** Gerencia a comunicação com o banco de dados.

Essa separação promove alta **manutenibilidade**, pois as alterações em uma camada têm impacto mínimo nas outras, e **testabilidade**, permitindo que cada camada seja testada de forma isolada. A orientação a serviços/componentes nos permitirá isolar e gerenciar funcionalidades chave do sistema de forma mais granular.

### Componentes Principais:

A arquitetura da nossa plataforma de mobilidade urbana é composta pelos seguintes elementos principais:

1.  **Aplicativo Cliente (Frontend):**
    *   **Descrição:** Responsável pela interface com o usuário (UI) e pela experiência do usuário (UX). Ele consome a API Backend para exibir informações e enviar solicitações.
    *   **Tecnologias (Exemplo):** Poderia ser desenvolvido utilizando frameworks como React, Angular, Vue.js, ou para plataformas móveis (Android/iOS).
    *   **(Nota:** Por enquanto, o frontend é considerado um componente externo à implementação direta deste backend, mas é uma parte crucial da arquitetura geral do sistema).

2.  **API Backend (Spring Boot):**
    *   **Descrição:** É o coração da aplicação, onde toda a lógica de negócio, gerenciamento de dados e regras da plataforma são implementados. Construído utilizando o framework Spring Boot.
    *   **Sub-componentes/Camadas:**
        *   **Presentation Layer (Controladores REST):**
            *   Responsável por expor os endpoints da API REST (ex: `/usuarios`, `/veiculos`, `/corridas`, `/login`).
            *   Recebe as requisições HTTP do cliente, realiza validações básicas de entrada (ex: formato dos dados), e delega o processamento para a camada de serviço apropriada.
            *   Exemplos: `UsuarioController`, `VeiculoController`.
        *   **Service Layer (Serviços de Negócio):**
            *   Contém a lógica de negócio central da aplicação. Orquestra as operações e regras de negócio.
            *   Coordena o uso dos repositórios para acesso a dados e pode interagir com outros serviços.
            *   Exemplos: `UsuarioService` (para cadastro, autenticação, etc.), `VeiculoService` (para gerenciamento de disponibilidade de veículos), `CorridaService` (para iniciar/finalizar corridas).
        *   **Data Access Layer (Repositórios):**
            *   Abstrai a forma como os dados são acessados e persistidos. Define interfaces para operações de CRUD (Create, Read, Update, Delete) sobre as entidades do domínio.
            *   Implementações utilizam Spring Data JPA para interagir com o banco de dados.
            *   Exemplos: `UsuarioRepository`, `VeiculoRepository`.
        *   **Domain Model (Entidades):**
            *   Representa os objetos de negócio e suas relações. São classes POJO (Plain Old Java Object) geralmente mapeadas para tabelas no banco de dados usando JPA annotations (ex: `@Entity`).
            *   Exemplos: `Usuario`, `Veiculo`, `Estacao`, `Corrida`, `Pagamento`.

3.  **Banco de Dados:**
    *   **Descrição:** Responsável por persistir todos os dados da aplicação, como informações de usuários, detalhes de veículos, histórico de corridas, etc.
    *   **Tecnologia:** Conforme definido no `pom.xml`, utilizaremos MySQL. Outras opções poderiam ser PostgreSQL, H2 (para desenvolvimento/testes), etc.
    *   A camada de acesso a dados (Repositórios) interage diretamente com o banco de dados.

### Diagrama de Componentes (C4 - Nível 3)

O diagrama a seguir representa os componentes internos do container "API Backend", detalhando como suas diferentes camadas e responsabilidades interagem entre si e com sistemas externos.

```plantuml
@startuml C4_Nivel3_API_Backend
!include https://raw.githubusercontent.com/plantuml-stdlib/C4-PlantUML/master/C4_Component.puml

LAYOUT_WITH_LEGEND()

title Diagrama de Componentes (C4 Nível 3) para a API Backend

Container_Boundary(api, "API Backend (Spring Boot Application)") {
    Component(controllers, "Controladores (Presentation Layer)", "Spring MVC REST Controllers", "Recebe requisições HTTP, valida e delega")
    Component(services, "Serviços (Service Layer)", "Spring Components/Services", "Orquestra lógica de negócio")
    Component(repositories, "Repositórios (Data Access Layer)", "Spring Data JPA Repositories", "Abstrai acesso ao banco de dados")
    Component(entities, "Entidades (Domain Model)", "JPA Entities", "Representa os objetos de negócio")
}

System_Ext(frontend, "Aplicativo Cliente (Frontend)", "Interface do Usuário (Ex: Web/Mobile App)")
SystemDb_Ext(db, "Banco de Dados", "MySQL", "Armazena dados da aplicação")

Rel(frontend, controllers, "Faz requisições HTTP para", "JSON/HTTP")
Rel(controllers, services, "Delega chamadas de negócio para")
Rel(services, repositories, "Usa para acesso a dados")
Rel(services, entities, "Manipula")
Rel(repositories, entities, "Persiste/Recupera")
Rel(repositories, db, "Executa queries em", "SQL/JDBC")

@enduml
```

# Integrantes:

- Antonio De Cesare Del Nero (220277)
- Thiago do Carmo Rodrigues Pinto (237827)
- José Carlos Cieni Júnior (170859)
- Barbara Nascimento (167109)
- Gabriel Augusto Ribeiro Ferreira (171851)
- Gustavo Oliveira de Sousa (247149)