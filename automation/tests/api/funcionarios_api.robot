*** Settings ***
Resource    ../../resources/keywords/api_keywords.robot
Library     String

Suite Setup       Criar Sessao API
Suite Teardown    Delete All Sessions


*** Test Cases ***
CT-API-001 - Cadastrar funcionario com dados validos
    [Documentation]    Verifica o cadastro de funcionario e a consistencia dos dados retornados pela API.
    ${payload}=    Criar Payload Funcionario
    ...    Funcionario QA API
    ...    12345678901
    ...    ${TRUE}
    ${resposta}=    Cadastrar Funcionario    ${payload}
    Should Be Equal As Integers    ${resposta.status_code}    201
    ${funcionario}=    Set Variable    ${resposta.json()}
    Validar Estrutura Do Funcionario    ${funcionario}
    ${id}=    Get From Dictionary    ${funcionario}    id
    Log To Console    Funcionário cadastrado com ID: ${id}
    ${state}=    Get From Dictionary    ${funcionario}    state
    ${employee}=    Get From Dictionary    ${state}    employee
    ${nome}=    Get From Dictionary    ${employee}    name
    ${cpf}=    Get From Dictionary    ${employee}    cpf
    ${uses_epi}=    Get From Dictionary    ${employee}    usesEpi
    Should Be Equal    ${nome}    Funcionario QA API
    Should Be Equal    ${cpf}    12345678901
    Should Be Equal    ${uses_epi}    ${TRUE}
    ...    msg=BUG-010: API retornou usesEpi diferente do esperado.

CT-API-002 - Consultar listagem de funcionarios
    [Documentation]    Verifica se a API retorna a listagem de funcionarios.
    ${resposta}=    Consultar Todos Funcionarios
    ${funcionarios}=    Set Variable    ${resposta.json()}
    Should Be True    isinstance($funcionarios, list)
    FOR    ${funcionario}    IN    @{funcionarios}
        Validar Estrutura Do Funcionario    ${funcionario}
    END


CT-API-003 - Consultar funcionario existente por ID
    [Documentation]    Verifica se a API retorna o funcionario correspondente ao ID informado.
    ${resposta_lista}=    Consultar Todos Funcionarios
    ${funcionarios}=    Set Variable    ${resposta_lista.json()}
    Should Not Be Empty    ${funcionarios}
    ${primeiro_funcionario}=    Get From List    ${funcionarios}    0
    ${id}=    Get From Dictionary    ${primeiro_funcionario}    id
    ${resposta}=    Consultar Funcionario Por ID    ${id}
    ${resultado}=    Set Variable    ${resposta.json()}
    Should Be True    isinstance($resultado, dict)
    Validar Estrutura Do Funcionario    ${resultado}
    ${id_retornado}=    Get From Dictionary    ${resultado}    id
    Should Be Equal    ${id_retornado}    ${id}

CT-API-006 - Cadastrar funcionario sem CPF
    [Documentation]    Verifica se a API rejeita o cadastro de funcionario sem a propriedade CPF.
    ${payload}=    Criar Payload Funcionario
    ...    Funcionario QA Sem CPF
    ...    12345678901
    ...    ${FALSE}
    ${state}=    Get From Dictionary    ${payload}    state
    ${employee}=    Get From Dictionary    ${state}    employee
    Remove From Dictionary    ${employee}    cpf
    ${resposta}=    Cadastrar Funcionario    ${payload}    anything
    Log To Console    Status HTTP: ${resposta.status_code}
    Log To Console    Corpo da resposta: ${resposta.text}
    Should Be True
    ...    ${resposta.status_code} >= 400
    ...    msg=Defeito de validacao: API aceitou cadastro sem CPF.

CT-API-007 - Consultar funcionario com ID inexistente
    [Documentation]    Verifica se a API retorna HTTP 404 ao consultar um funcionario inexistente.
    ${id_inexistente}=    Generate Random String    32    [LETTERS][NUMBERS]
    ${resposta}=    Consultar Funcionario Por ID
    ...    ${id_inexistente}
    ...    anything
    Should Be Equal As Integers    ${resposta.status_code}    404
    ${corpo}=    Set Variable    ${resposta.json()}
    Dictionary Should Contain Key    ${corpo}    error
    Should Be Equal
    ...    ${corpo}[error]
    ...    Funcionário não encontrado.