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

Preparar Tela Inicial
    Go To    ${URL_BASE}  
    Wait For Elements State    css=.c-kGuehp    visible  #aguarda o container da listagem.
    Wait For Function    () => document.querySelectorAll('.c-bXqUbA').length > 0  #aguarda até existir pelo menos um card de funcionário.

Filtrar Funcionários Ativos
    Click    text=Ver apenas ativos

Limpar Filtros
    Click    button.clear

Obter Quantidade De Funcionarios Exibidos
    ${quantidade}=    Get Element Count    css=.c-bXqUbA
    Log To Console    Funcionários exibidos: ${quantidade}
    RETURN    ${quantidade}

Clicar em Adicionar Funcionário
    Get Text    text=Adicionar Funcionário
    Click    text=Adicionar Funcionário

Definir Status Do Funcionario
    [Arguments]    ${status}=Ativo

    ${estado_atual}=    Get Attribute    css=button[role="switch"]    aria-checked

    IF    '${status}' == 'Ativo' and '${estado_atual}' == 'false'
        Click    css=button[role="switch"]
    ELSE IF    '${status}' == 'Inativo' and '${estado_atual}' == 'true'
        Click    css=button[role="switch"]
    END

    ${estado_final}=    Get Attribute    css=button[role="switch"]    aria-checked

    IF    '${status}' == 'Ativo'
        Should Be Equal    ${estado_final}    true
    ELSE IF    '${status}' == 'Inativo'
        Should Be Equal    ${estado_final}    false
    ELSE
        Fail    Status inválido: ${status}. Utilize Ativo ou Inativo.
    END

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
    Click    css=label.ant-checkbox-wrapper
    ${estado}=    Get Property    css=input.ant-checkbox-input    checked
    Should Be True    ${estado}

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

Preencher Numero Do CA
    Fill Text    input[name="caNumber"]    1234

Preencher Dados Basicos Do Funcionario
    Fill Text    input[name="name"]    Funcionario QA Automatizado
    ${cpf}=    Gerar Cpf Valido
    Log To Console    CPF utilizado no cadastro: ${cpf}
    Fill Text    input[name="cpf"]    ${cpf}
    Fill Text    input[name="birthDay"]    1995-05-15
    Fill Text    input[name="rg"]    5555555
    RETURN    ${cpf}

Preparar Dados Para Cadastro Completo
    Definir Status Do Funcionario    Ativo
    ${cpf}=    Preencher Dados Basicos Do Funcionario
    Selecionar Cargo
    Selecionar Atividade
    Selecionar EPI
    Preencher Numero Do CA
    RETURN    ${cpf}

Preparar Dados Para Cadastro Sem EPI
    Definir Status Do Funcionario    Inativo
    ${cpf}=    Preencher Dados Basicos Do Funcionario
    Selecionar Cargo
    Marcar Checkbox Não Usa EPI
    RETURN    ${cpf}

Preencher Dados Basicos Sem Nome
    ${cpf}=    Gerar Cpf Valido
    Log To Console    CPF utilizado no cadastro: ${cpf}
    Fill Text    input[name="cpf"]    ${cpf}
    Fill Text    input[name="birthDay"]    1995-05-15
    Fill Text    input[name="rg"]    5555555
    RETURN    ${cpf}

Preencher Dados Para Cadastro Com CPF Existente
    [Arguments]    ${cpf}
    Fill Text    input[name="name"]    Funcionario QA Duplicado
    Fill Text    input[name="cpf"]    ${cpf}
    Fill Text    input[name="birthDay"]    1995-05-15
    Fill Text    input[name="rg"]    7777777

Validar Obrigatoriedade Do Nome
    ${required}=    Get Property    input[name="name"]    required
    Should Be True    ${required}

    ${mensagem}=    Get Property    input[name="name"]    validationMessage
    Should Not Be Empty    ${mensagem}

Validar Duplicidade De CPF Na API
    [Arguments]    ${cpf_teste}

    ${funcionarios}=    Consultar Funcionários Na API
    ${encontrados}=    Create List

    FOR    ${registro}    IN    @{funcionarios}
        ${state}=    Get From Dictionary    ${registro}    state
        ${employee}=    Get From Dictionary    ${state}    employee
        ${cpf_api}=    Get From Dictionary    ${employee}    cpf

        IF    $cpf_api == $cpf_teste
            Append To List    ${encontrados}    ${employee}
        END
    END

    Length Should Be    ${encontrados}    2
    Log To Console    CPF ${cpf_teste} encontrado em ${2} registros.

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

Localizar Funcionario Na API 
    [Arguments]    ${cpf_teste}

    ${funcionarios}=    Consultar Funcionários Na API
    ${encontrados}=    Create List

    FOR    ${registro}    IN    @{funcionarios}
        ${state}=    Get From Dictionary    ${registro}    state
        ${employee}=    Get From Dictionary    ${state}    employee
        ${cpf_api}=    Get From Dictionary    ${employee}    cpf

        IF    $cpf_api == $cpf_teste
            Append To List    ${encontrados}    ${employee}
        END
    END

    Should Not Be Empty    ${encontrados}
    Length Should Be    ${encontrados}    1

    ${funcionario}=    Get From List    ${encontrados}    0
    RETURN    ${funcionario}

Validar Dados Basicos Do Funcionario Na API
    [Arguments]    ${employee}

    Should Be Equal    ${employee}[name]    Funcionario QA Automatizado
    Should Be Equal    ${employee}[role]    Cargo 03

Validar Funcionário Sem EPI Na API
    [Arguments]    ${cpf_teste}

    ${employee}=    Localizar Funcionario Na API    ${cpf_teste}
    Validar Dados Basicos Do Funcionario Na API    ${employee}

    ${epi}=    Get From Dictionary    ${employee}    epi    ${None}
    ${ca}=    Get From Dictionary    ${employee}    caNumber    ${None}

    Should Be True    $epi is None or $epi == ''
    Should Be True    $ca is None or $ca == ''


Validar Funcionário Com EPI Na API 
    [Arguments]    ${cpf_teste}

    ${employee}=    Localizar Funcionario Na API    ${cpf_teste}
    Validar Dados Basicos Do Funcionario Na API    ${employee}

    Should Be Equal    ${employee}[activity]    Ativid 02

    ${epi}=    Get From Dictionary    ${employee}    epi
    ${ca}=    Get From Dictionary    ${employee}    caNumber

    Should Not Be Empty    ${epi}
    Should Be Equal    ${ca}    1234

Validar Opção Utiliza EPI Selecionada
    ${estado}=    Get Property    css=input.ant-checkbox-input    checked
    Should Be Equal    ${estado}    ${False}

Validar Campo UsesEpi Na API
    [Arguments]    ${cpf_teste}
    ${employee}=    Localizar Funcionario Na API    ${cpf_teste}

    Log To Console    Valor de usesEpi retornado pela API: ${employee}[usesEpi]

    Should Be True    ${employee}[usesEpi]

Validar Funcionário Na Listagem
    [Arguments]    ${cpf_teste}    ${nome_esperado}

    ${cpf_formatado}=    Evaluate    '${cpf_teste}'[:3] + '.' + '${cpf_teste}'[3:6] + '.' + '${cpf_teste}'[6:9] + '-' + '${cpf_teste}'[9:]

    ${card}=    Set Variable    css=.c-bXqUbA:has(.c-iYbcAK:text-is("${cpf_formatado}"))

    Wait For Elements State    ${card}    visible
    ${nome}=    Get Text    ${card} >> span
    Should Be Equal    ${nome}    ${nome_esperado}