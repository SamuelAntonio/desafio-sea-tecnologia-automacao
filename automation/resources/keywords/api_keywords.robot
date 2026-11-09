
*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource   ../variables/config.robot


*** Keywords ***
Criar Sessao API
    Create Session    api    ${URL_BASE}


Consultar Todos Funcionarios
    ${resposta}=    GET On Session
    ...    api
    ...    /employees
    ...    expected_status=200
    RETURN    ${resposta}


Consultar Funcionario Por ID
    [Arguments]    ${id}    ${status_esperado}=200

    ${resposta}=    GET On Session
    ...    api
    ...    /employees/${id}
    ...    expected_status=${status_esperado}

    RETURN    ${resposta}


Validar Estrutura Do Funcionario
    [Arguments]    ${funcionario}

    Dictionary Should Contain Key    ${funcionario}    id
    Dictionary Should Contain Key    ${funcionario}    state
    Dictionary Should Contain Key    ${funcionario}    createdAt

    ${state}=    Get From Dictionary    ${funcionario}    state

    Dictionary Should Contain Key    ${state}    employee

    ${employee}=    Get From Dictionary    ${state}    employee

    Should Be True    isinstance($employee, dict)


*** Keywords ***
Criar Payload Funcionario
    [Arguments]    ${nome}    ${cpf}    ${uses_epi}=${FALSE}

    ${employee}=    Create Dictionary
    ...    isActive=${FALSE}
    ...    name=${nome}
    ...    gender=masculino
    ...    cpf=${cpf}
    ...    birthDay=1995-06-15
    ...    rg=4756139
    ...    role=Cargo 01
    ...    usesEpi=${uses_epi}
    ...    activity=Ativid 04
    ...    epi=capacete-de-segurança
    ...    caNumber=72978312

    ${state}=    Create Dictionary    employee=${employee}
    ${payload}=    Create Dictionary    state=${state}

    RETURN    ${payload}


Cadastrar Funcionario
    [Arguments]    ${payload}    ${status_esperado}=201

    ${resposta}=    POST On Session
    ...    api
    ...    /employees
    ...    json=${payload}
    ...    expected_status=${status_esperado}

    RETURN    ${resposta}


Atualizar Funcionario
    [Arguments]    ${id}    ${payload}    ${status_esperado}=200

    ${resposta}=    PUT On Session
    ...    api
    ...    /employees/${id}
    ...    json=${payload}
    ...    expected_status=${status_esperado}

    RETURN    ${resposta}

Excluir Funcionario
    [Arguments]    ${id}    ${status_esperado}=204

    ${resposta}=    DELETE On Session
    ...    api
    ...    /employees/${id}
    ...    expected_status=${status_esperado}

    RETURN    ${resposta}
