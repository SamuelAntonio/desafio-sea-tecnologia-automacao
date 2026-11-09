
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