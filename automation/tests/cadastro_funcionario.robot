
*** Settings ***
Resource    ../resources/keywords/cadastro_keywords.robot

Suite Setup       Abrir Página de Cadastro
Test Setup        Preparar Formulário de Cadastro
Suite Teardown    Close Browser

*** Test Cases ***
Exibir Formulário De Cadastro
    Validar Formulário de Cadastro

Exibir Campos De EPI Quando Trabalhador Utiliza EPI
    Validar Checkbox Não Usa EPI Desmarcado
    Validar Campos de EPI Visíveis

Ocultar Campos De EPI Quando Trabalhador Não Utiliza EPI
    Marcar Checkbox Não Usa EPI
    Validar Campos de EPI Ausentes

Impedir Cadastro Sem Informar Numero Do CA
    Validar Checkbox Não Usa EPI Desmarcado
    Validar Campos de EPI Visíveis
    Tentar Salvar Cadastro
    Validar Obrigatoriedade Do CA

Cadastrar Funcionário Com Dados Válidos
    ${cpf}=    Preparar Dados Para Cadastro Completo
    Tentar Salvar Cadastro
    Validar Funcionário Na API    ${cpf}
