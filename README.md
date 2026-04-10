# Fast Location 📍

O **Fast Location** é um aplicativo Flutter desenvolvido para otimizar a rotina de entregadores. Ele permite a consulta rápida de endereços (via CEP ou Logradouro), o armazenamento de um histórico local e a geração de rotas de navegação em tempo real.

## 🚀 Funcionalidades

* **Busca por CEP**: Integração com a API ViaCEP para retorno imediato de endereços.
* **Busca por Endereço**: Pesquisa avançada utilizando campos de UF, Cidade e Logradouro.
* **Histórico Local**: Persistência de dados offline utilizando o banco NoSQL **Hive**, permitindo gerenciar e limpar consultas anteriores.
* **Traçar Rota**: Integração com serviços de mapas para calcular rotas entre a **localização atual (GPS)** e o destino pesquisado.
* **Interface Reativa**: Gerenciamento de estado performático com **MobX** e navegação por abas (Tabs).

## 🛠️ Pré-requisitos Técnicos

Para garantir a estabilidade do ambiente de desenvolvimento e execução (especialmente em sistemas Linux/Fedora), utilize as seguintes versões:

* **Java JDK**: 17 (LTS)
* **Flutter**: 3.x (Canal Stable)
* **Android SDK**: API Level 34
* **Gradle**: 8.14

## 📥 Instalação e Configuração

### 1. Clonar o Repositório
```bash
git clone [https://github.com/seu-usuario/fast_location.git](https://github.com/seu-usuario/fast_location.git)
cd fast_location
```

### 2. Preparar as Dependências e Código Gerado
Instale os pacotes e execute o `build_runner` para gerar os arquivos necessários para o MobX e Hive:
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Configuração do Emulador
Para testar a função de "Traçar Rota" em um emulador, você deve injetar uma localização manual:
1. No emulador, acesse **Extended Controls (...) > Location**.
2. Pesquise por uma localização (Ex: Indaial, SC) e clique em **Set Location**.

### 4. Executar o Aplicativo
No Linux/Fedora, recomenda-se desativar o motor Impeller para evitar instabilidades gráficas no emulador:
```bash
flutter run --no-impeller
```

## 🏗️ Estrutura do Projeto

* `/lib/src/modules`: Divisão por funcionalidades, contendo Views, Controllers e Repositories.
* `/lib/src/shared`: Componentes visuais padronizados, temas de cores e métricas.
* `/lib/src/http`: Configuração do cliente HTTP (Dio) para consumo da API.
* `/lib/src/routes`: Definição centralizada das rotas nomeadas.

## 📝 Observações Importantes
* **Configuração Android**: O arquivo `AndroidManifest.xml` foi configurado com as tags `<queries>` e permissões de localização necessárias para a integração com mapas e GPS.
* **Qualidade de Código**: O projeto foi limpo de avisos (*warnings*) de lint, aplicando checagens de `mounted` em contextos assíncronos.

---
*Projeto desenvolvido para fins acadêmicos.*