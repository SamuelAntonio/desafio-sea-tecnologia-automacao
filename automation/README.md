Automação de Testes — Sea Tecnologia

Projeto de automação de testes desenvolvido com Robot Framework, utilizando a biblioteca Browser (Playwright) para testes de interface e RequestsLibrary para testes de API REST.

1. Tecnologias utilizadas

Python

Robot Framework

Robot Framework Browser

Robot Framework Requests

Playwright

Google Chrome

2. Pré-requisitos

Antes de iniciar, instale:

Python 3

Google Chrome

Para verificar se o Python e o Git estão instalados, execute:

python --version
git --version

3. Baixando o projeto

Clone o repositório:

git clone URL_DO_REPOSITORIO

Acesse a pasta do projeto:

cd NOME_DO_REPOSITORIO

Caso tenha baixado o projeto em ZIP, extraia os arquivos e abra o terminal na pasta raiz.

4. Criando o ambiente virtual

Crie um ambiente virtual para manter as dependências isoladas:

python -m venv .venv

Ativação no Windows

PowerShell:

.venv\Scripts\Activate.ps1

Prompt de Comando (CMD):

.venv\Scripts\activate.bat

Ativação no Linux/macOS

source .venv/bin/activate

5. Instalando as dependências

Com o ambiente virtual ativado, atualize o pip:

python -m pip install --upgrade pip

Instale as bibliotecas do projeto:

pip install -r requirements.txt

6. Configurando o navegador

Após instalar as dependências, inicialize o Browser Library e instale os navegadores necessários:

rfbrowser init

Esse comando prepara o ambiente do Playwright para executar os testes automatizados.

7. Verificando a instalação

Confira se o Robot Framework está instalado:

robot --version

Confira também as bibliotecas instaladas:

pip list

8. Executando os testes

Na raiz do projeto, execute todos os testes:

robot -d results tests/

Para executar um arquivo específico:

robot -d results tests/nome_do_arquivo.robot

Para executar um teste específico pelo nome:

robot -d results -t "Nome do teste" tests/

9. Relatórios de execução

Após a execução, o Robot Framework gera os seguintes arquivos na pasta results/:

Arquivo

Descrição

report.html

Resumo dos resultados dos testes.

log.html

Detalhamento da execução, etapas e evidências.

output.xml

Resultado estruturado da execução.

Abra os relatórios report.html ou log.html em um navegador para consultar os resultados.


10. Observações

Sempre ative o ambiente virtual antes de executar os testes.

Execute rfbrowser init após instalar as dependências ou ao configurar um novo ambiente.

Os testes de interface dependem da disponibilidade da aplicação e do navegador.

Os testes de API dependem da disponibilidade dos endpoints utilizados.

Os relatórios de execução são gerados localmente na pasta results/.