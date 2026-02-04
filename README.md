# PsicoLog 🧠✨

**PsicoLog** é um companheiro de saúde mental moderno, focado em privacidade, construído com Flutter. Ele funciona como um santuário digital onde usuários podem registrar seus sonhos, insights diários e emoções em um ambiente seguro e _local-first_.

Projetado com uma estética premium "Glassbiometria" (Glassmorphism), ele prioriza a experiência do usuário através de animações fluidas, micro-interações e uma interface calmante.

---

## 🚀 Funcionalidades Principais

### 1. Diário (Journal) 📔
O coração do PsicoLog. Usuários criam diferentes tipos de entradas:
- **Sonhos**: Registre experiências oníricas com tags específicas (ex: #Lucido, #Pesadelo) e humor ao acordar.
- **Insights**: Capture realizações súbitas ou ideias.
- **Emoções**: Rastreie a intensidade emocional (1-5) e o contexto do dia.
- **Privacidade**: Todo dado é salvo localmente usando **Isar Database**.

### 2. Catarse (Catharsis) 🌬️
Uma funcionalidade única desenhada para ajudar usuários a "deixar ir" pensamentos intrusivos.
- O usuário digita suas preocupações ou estressores.
- Ao confirmar, o texto "evapora" visualmente (usando animações complexas de partículas), simbolizando o ato de soltar.
- **Efêmero**: Estas entradas **não** são salvas no banco de dados.

### 3. Ecos (Echoes) 🔊
Ferramenta de análise inteligente.
- Analisa padrões nos textos do seu diário.
- Identifica palavras-chave e sentimentos recorrentes.
- Fornece feedback visual sobre temas comuns na sua vida.

### 4. Segurança & Privacidade 🔒
- **Bloqueio Biométrico**: Proteja seu diário usando a impressão digital ou FaceID do seu dispositivo.
- **Backup & Restauração**: Exporte seus dados para um arquivo JSON seguro e restaure quando quiser. Nada de nuvem obrigatória.

### 5. Bem-Estar & Notificações 📅
- **Lembrete de Terapia**: Configure notificações semanais para não esquecer de registrar seus insights pós-sessão.
- **Mood Heatmap**: Um gráfico estilo GitHub para visualizar seus dias de alta e baixa energia emocional.

---

## 🛠️ Stack Tecnológica

Este projeto utiliza o que há de mais moderno no ecossistema Flutter:

- **Framework**: [Flutter](https://flutter.dev) (Dart 3)
- **Gerenciamento de Estado**: [Provider](https://pub.dev/packages/provider) para acesso limpo e escopado.
- **Banco de Dados**: [Isar](https://isar.dev) - Banco NoSQL local extremamente rápido e ACID-compliant.
- **Segurança**:
    - `local_auth` para biometria.
    - Sistema de backup criptografado (JSON).
- **UI/Animações**:
    - `flutter_animate` para animações declarativas.
    - `flutter_heatmap_calendar` para o rastreador de humor.
    - `google_fonts` para tipografia.
    - `flutter_local_notifications` para agendamento local.

---

## 📂 Estrutura do Projeto

O projeto segue um padrão de arquitetura limpa e segregada:

```
lib/
├── data/           # Camada de Dados
│   ├── models/     # Entidades Isar (Entry, AppSettings)
│   └── services/   # Serviços de dados (DatabaseService - Isar)
├── logic/          # Lógica de Negócio
│   ├── providers/  # Gerenciamento de Estado (JournalProvider, EchoesProvider)
│   └── services/   # Serviços de Lógica (AuthService, BackupService, NotificationService)
├── ui/             # Camada de Apresentação
│   ├── screens/    # Telas completas (Home, Settings, Dreams, LockScreen)
│   ├── widgets/    # Componentes reutilizáveis (EntryCard, GlassContainer)
│   └── app_theme.dart # Configuração centralizada de tema
└── services/       # Serviços globais/core (ex: NotificationService)
```

---

## ⚡ Como Rodar o Projeto

### Pré-requisitos
- Flutter SDK (3.10+)
- Dart SDK
- Android Studio / VS Code configurados

### Instalação

1. **Clone o repositório**
   ```bash
   git clone https://github.com/seu-usuario/psicolog.git
   cd psicolog
   ```

2. **Instale as Dependências**
   ```bash
   flutter pub get
   ```

3. **Gere os Adaptadores do Banco (Isar)**
   Como usamos Isar, é necessário gerar código:
   ```bash
   dart run build_runner build
   ```

4. **Rode o App**
   ```bash
   flutter run
   ```

---

## 🎨 Filosofia de Design

PsicoLog usa uma estética **Dark/Glass**:
- **Cores**: Roxos profundos, verde-azulado (Teal) e cinzas escuros.
- **Tipografia**: Fontes limpas e sem serifa para máxima legibilidade.
- **Movimento**: Tudo deve parecer "vivo". Listas entram em cascata, botões pulam suavemente, e interações têm feedback imediato.

---

## 📄 Licença
Este projeto está sob a licença MIT - sinta-se livre para usar e modificar.
