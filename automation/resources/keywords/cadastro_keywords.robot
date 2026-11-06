
*** Settings ***
Library    Browser
Library    RequestsLibrary
Library    Collections
Library    ../libraries/CpfLibrary.py
Resource   ../variables/config.robot

*** Keywords ***
Abrir Página de Cadastro
    New Browser    ${BROWSER}    headless=False
    New Page    ${URL_BASE}

Preparar Formulário de Cadastro
    Go To    ${URL_BASE}
    Clicar em Adicionar Funcionário

Clicar em Adicionar Funcionário
    Get Text    text=Adicionar Funcionário
    Click    text=Adicionar Funcionário

Validar Formulário de Cadastro
    Wait For Elements State
    ...    css=form
    ...    visible
    ...    timeout=${TIMEOUT}

Validar Checkbox Não Usa EPI Desmarcado
    ${estado}=    Get Property    css=input[type="checkbox"]    checked
    Should Be Equal    ${estado}    ${False}

Validar Campos de EPI Visíveis
    Wait For Elements State    css=.epiSelect    visible
    Wait For Elements State    css=input[name="caNumber"]    visible

Marcar Checkbox Não Usa EPI
    Click    text=O trabalhador não usa EPI.

Validar Campos de EPI Ausentes
    ${quantidade_epi}=    Get Element Count    css=.epiSelect
    ${quantidade_ca}=    Get Element Count    css=input[name="caNumber"]
    Should Be Equal As Integers    ${quantidade_epi}    0
    Should Be Equal As Integers    ${quantidade_ca}    0

Tentar Salvar Cadastro
    Click    text=Salvar

Validar Obrigatoriedade Do CA
    ${required}=    Get Property    css=input[name="caNumber"]    required
    Should Be True    ${required}

    ${valid}=    Evaluate JavaScript  # O Evaluate JavaScript permite consultar a propriedade aninhada diretamente no elemento.
    ...    css=input[name="caNumber"]
    ...    (element) => element.validity.valid
    Should Be Equal    ${valid}    ${False}

    ${mensagem}=    Get Property    css=input[name="caNumber"]    validationMessage
    Should Be Equal    ${mensagem}    Preencha este campo.

Selecionar EPI
    Click    css=.epiSelect
    Click    text=Óculos de proteção
    ${selecionado}=    Get Text
    ...    css=.epiSelect .ant-select-selection-item
    Should Be Equal    ${selecionado}    Óculos de proteção

Preencher Dados Basicos Do Funcionario
    Fill Text    input[name="name"]    Funcionario QA Automatizado
    ${cpf}=    Gerar Cpf Valido
    Log To Console    CPF utilizado no cadastro: ${cpf}
    Fill Text    input[name="cpf"]    ${cpf}
    Fill Text    input[name="birthDay"]    1995-05-15
    Fill Text    input[name="rg"]    5555555
    Fill Text    input[name="caNumber"]    1234
    RETURN    ${cpf}

Selecionar Cargo
    Click    css=.ant-select >> nth=0
    Click    text=Cargo 03
    ${cargo}=    Get Text    css=.ant-select >> nth=0 >> .ant-select-selection-item
    Should Be Equal    ${cargo}    Cargo 03

Selecionar Atividade
    Click    css=.ant-select >> nth=1
    Wait For Elements State
    ...    css=.ant-select-item-option[title="Ativid 02"]
    ...    visible
    Click
    ...    css=.ant-select-item-option[title="Ativid 02"]
    ${atividade}=    Get Text
    ...    css=.ant-select >> nth=1 >> .ant-select-selection-item
    Log To Console    Atividade após seleção: ${atividade}
    Should Be Equal    ${atividade}    Ativid 02

Preparar Dados Para Cadastro Completo
    ${cpf}=    Preencher Dados Basicos Do Funcionario
    Selecionar Cargo
    Selecionar Atividade
    Selecionar EPI
    RETURN    ${cpf}

Consultar Funcionários Na API
    Create Session    api    ${URL_BASE}
    ${resposta}=    GET On Session    api    /employees
    Should Be Equal As Integers    ${resposta.status_code}    200
    ${funcionarios}=    Set Variable    ${resposta.json()}
    RETURN    ${funcionarios}

Validar Funcionário Na API
    [Arguments]    ${cpf_teste}
    ${funcionarios}=    Consultar Funcionários Na API
    ${encontrados}=    Create List

    FOR    ${registro}    IN    @{funcionarios}
        ${state}=    Get From Dictionary    ${registro}    state
        ${employee}=    Get From Dictionary    ${state}    employee
        ${cpf_api}=    Get From Dictionary    ${employee}    cpf

        IF    $cpf_api == $cpf_teste
            Append To List    ${encontrados}    ${registro}
        END
    END

    Should Not Be Empty    ${encontrados}

    Length Should Be    ${encontrados}    1
    ${funcionario}=    Get From List    ${encontrados}    0
    ${state}=    Get From Dictionary    ${funcionario}    state
    ${employee}=    Get From Dictionary    ${state}    employee

    Should Be Equal    ${employee}[name]    Funcionario QA Automatizado
    Should Be Equal    ${employee}[role]    Cargo 03
    Should Be Equal    ${employee}[activity]    Ativid 02
    Should Be Equal    ${employee}[caNumber]    1234