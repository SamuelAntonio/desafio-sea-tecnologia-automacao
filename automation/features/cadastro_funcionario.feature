Feature: Cadastro de funcionários

  Como usuário do sistema
  Quero acessar o formulário de cadastro
  Para iniciar o registro de um funcionário

  Scenario: Exibir formulário de cadastro
    Given que acesso a página de cadastro de funcionários
    When clico no botão Adicionar Funcionário
    Then o formulário de cadastro deve ser exibido

  Scenario: Exibir campos de EPI quando o trabalhador utiliza EPI
    Given que estou no formulário de cadastro
    And a opção "O trabalhador não usa EPI" está desmarcada
    Then os campos de seleção de EPI e número do CA devem estar visíveis

  Scenario: Ocultar campos de EPI quando o trabalhador não utiliza EPI
    Given que estou no formulário de cadastro
    When marco a opção "O trabalhador não usa EPI"
    Then os campos de seleção de EPI e número do CA devem desaparecer imediatamente

  Scenario: Impedir cadastro sem informar o número do CA
    Given que estou no formulário de cadastro
    And a opção "O trabalhador não usa EPI" está desmarcada
    When tento salvar sem informar o número do CA
    Then o sistema deve impedir o envio do formulário
    And deve indicar que o número do CA é obrigatório