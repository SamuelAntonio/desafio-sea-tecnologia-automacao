
*** Settings ***
Resource    ../resources/keywords/cadastro_keywords.robot
Suite Setup       Abrir Página de Cadastro
Test Setup        Preparar Formulário de Cadastro
Suite Teardown    Close Browser

*** Test Cases ***

CT-001 - Cadastrar Funcionário Com Dados Válidos
    [Documentation]    Valida o cadastro completo de um funcionário com dados válidos.
    ${cpf}=    Preparar Dados Para Cadastro Completo
    Tentar Salvar Cadastro
    Validar Funcionário Na API    ${cpf}


CT-002 - Cadastrar Funcionário Que Não Utiliza EPI
    [Documentation]    Valida o cadastro de funcionário sem utilização de EPI.
    ${cpf}=    Preparar Dados Para Cadastro Sem EPI
    Validar Campos de EPI Ausentes
    Tentar Salvar Cadastro
    Validar Funcionário Sem EPI Na API    ${cpf}


CT-003 - Cadastrar Funcionário Que Utiliza EPI
    [Documentation]    Valida o cadastro de funcionário com EPI e CA informado.
    ${cpf}=    Preparar Dados Para Cadastro Completo
    Validar Checkbox Não Usa EPI Desmarcado
    Validar Campos de EPI Visíveis
    Tentar Salvar Cadastro
    Validar Funcionário Com EPI Na API    ${cpf}

CT-004 - Validar Campo UsesEpi Para Funcionário Que Utiliza EPI
    [Documentation]    Valida reprodução do BUG-010
    ${cpf}=    Preparar Dados Para Cadastro Completo
    Validar Opção Utiliza EPI Selecionada
    Tentar Salvar Cadastro
    Validar Campo UsesEpi Na API    ${cpf}

CT-006 - Filtrar Somente Funcionários Ativos
    [Documentation]    Valida se o filtro apresenta somente os funcionários ativos.
    [Setup]    Preparar Tela Inicial
    ${quantidade_inicial}=    Obter Quantidade De Funcionarios Exibidos
    Filtrar Funcionários Ativos
    ${quantidade_filtrada}=    Obter Quantidade De Funcionarios Exibidos
    Should Be True
    ...    ${quantidade_filtrada} < ${quantidade_inicial}
    ...    O filtro não reduziu a quantidade de funcionários exibidos.


CT-007 - Limpar Filtro de Funcionários Ativos
    [Documentation]    Valida se a limpeza do filtro restaura a listagem completa.
    [Setup]    Preparar Tela Inicial
    ${quantidade_inicial}=    Obter Quantidade De Funcionarios Exibidos
    Filtrar Funcionários Ativos
    Limpar Filtros
    ${quantidade_final}=    Obter Quantidade De Funcionarios Exibidos
    Should Be Equal As Integers
    ...    ${quantidade_final}
    ...    ${quantidade_inicial}
    ...    A listagem não retornou à quantidade inicial após limpar o filtro.

CT-008 - Tentar Cadastrar Funcionário Sem Nome
    [Documentation]    Valida a obrigatoriedade do campo Nome.
    ${cpf}=    Preencher Dados Basicos Sem Nome
    Selecionar Cargo
    Selecionar Atividade
    Selecionar EPI
    Preencher Numero Do CA
    Tentar Salvar Cadastro
    Validar Obrigatoriedade Do Nome

CT-014 - Tentar Cadastrar Funcionário Com EPI Sem Informar CA
    [Documentation]    Valida a obrigatoriedade condicional do campo CA.
    ${cpf}=    Preencher Dados Basicos Do Funcionario
    Selecionar Cargo
    Selecionar Atividade
    Selecionar EPI
    Tentar Salvar Cadastro
    Validar Obrigatoriedade Do CA

CT-027 - Cadastrar Funcionário Com CPF Duplicado
    [Documentation]    Reproduz o BUG-001: aplicação permite CPF duplicado.
    ${cpf}=    Preparar Dados Para Cadastro Completo
    Tentar Salvar Cadastro
    Clicar em Adicionar Funcionário
    Preencher Dados Para Cadastro Com CPF Existente    ${cpf}
    Selecionar Cargo
    Selecionar Atividade
    Selecionar EPI
    Preencher Numero Do CA
    Tentar Salvar Cadastro
    Validar Duplicidade De CPF Na API    ${cpf}

CT-028 - Consultar Funcionário Após Cadastro
    [Documentation]    Valida se o funcionário cadastrado aparece na listagem.
    ${cpf}=    Preparar Dados Para Cadastro Completo
    Tentar Salvar Cadastro
    Reload
    Validar Funcionário Na Listagem    ${cpf}    Funcionario QA Automatizado