# 📱 Projeto Final - Dispositivos Móveis

Este projeto Flutter foi desenvolvido como entrega final da disciplina de **Dispositivos Móveis**. O foco principal é demonstrar domínio sobre **temas, navegação animada, validações de formulário, personalização visual e organização de código Flutter**, com uso do FVM para gerenciamento da versão do SDK.

---

## 🎯 Funcionalidades e Tecnologias

### 🎨 Temas Avançados

- Customização completa de **`TextFormField`**:
  - Estados: foco, erro, desabilitado, preenchido
- Temas visuais para **`ElevatedButton`**, **`OutlinedButton`** e **`TextButton`**
- Suporte a **modo claro e escuro**

### 🔤 Fontes Personalizadas

- Integração de fontes externas via `pubspec.yaml`
- Aplicadas globalmente via `ThemeData`

### 💼 Formulários com Validação

- Campos com `TextFormField` integrados a `Form`
- Validações:
  - Campo obrigatório
  - Formato de e-mail
  - Validação de senha e confirmação
- Feedback visual integrado ao tema (cores de erro, foco, label flutuante)

### 🧭 Navegação com Transições

- Transições de tela com animações personalizadas (`PageRouteBuilder`, `FadeTransition`, `SlideTransition`)
- Navegação nomeada com argumentos entre telas

### 🚀 Gerenciamento com FVM

- Projeto configurado com [FVM](https://fvm.app) para garantir consistência da versão do Flutter
- Arquivo `.fvmrc` incluído
-----
## Modelagem do APP
| Caso de uso                                | Onde será usado                     |
| ------------------------------------------ | ----------------------------------- |
| Criar produto                              | Cadastro rápido ou tela de produtos |
| Buscar produtos existentes                 | Ao montar nova lista                |
| Criar nova lista de compras                | Tela de nova lista                  |
| Adicionar item à lista (produto + unidade) | Tela de edição da lista             |
| Marcar item como comprado                  | Tela da lista ativa                 |
| Adicionar preço a item comprado            | Imediatamente após checkar          |
| Ver histórico de listas                    | Tela de histórico                   |
| Renomear lista                             | Editar detalhes da lista            |

## 🧩 Requisitos de design de dados
- Produto e Lista têm ID único
- ItemCompra associa produto a lista (relacional)
- Preço só aparece quando o item está comprado
- Histórico = lista salva como finalizada

## Funcionalidades por Tela
### 🛒 Lista Ativa
- Ver itens agrupados por categoria
- Checkar produtos comprados
- Inserir preço ao checkar

### ➕ Nova Lista
- Nome da lista
- Adicionar produtos (buscar existentes ou criar novo)
- Escolher unidade e quantidade
- 
### 📁 Histórico
- Listagem de listas finalizadas
- Visualizar totais e detalhes
- 
### 📦 Produtos
- Tela (opcional) para gerenciar produtos fixos
