# Documentação Técnica - PsicoLog

Este documento serve como referência técnica para desenvolvedores e mantenedores do aplicativo PsicoLog.

## 1. Banco de Dados (Isar)

Usamos o **Isar Database** por sua performance e suporte nativo a tipos complexos em Dart.

### Esquema de Dados

#### `Entry` (Collection)
Armazena todas as entradas do diário.
- **id**: `Id` (Auto-incremento)
- **content**: `String` (Texto principal)
- **date**: `DateTime` (Indexado para consultas rápidas por data)
- **type**: `EntryType` (Enum: `dream`, `insight`, `emotion`)
- **feelings**: `List<String>` (Tags para sentimentos ou palavras-chave)
- **emotionIntensity**: `double?` (1.0 a 5.0, apenas para `type == emotion`)
- **dreamIsLucid**: `bool` (Apenas para `type == dream`)

#### `AppSettings` (Collection - Singleton)
Armazena configurações do usuário. Geralmente existe apenas 1 registro com ID fixo.
- **isBiometricEnabled**: `bool` (Se o bloqueio de tela está ativo)
- **isOnboardingCompleted**: `bool` (Se o tutorial inicial foi visto)
- **therapyDayOfWeek**: `int?` (1-7, dia do lembrete)
- **therapyHour/Minute**: `int?` (Horário do lembrete)

---

## 2. Arquitetura de Serviços

### `DatabaseService`
- Wrapper em cima do Isar.
- **Responsabilidade**: Abrir banco, realizar queries, transactions e migrations.
- **Singleton**: Instanciado no `main.dart` e injetado via Provider.

### `NotificationService`
- Wrapper em cima do `flutter_local_notifications`.
- **Responsabilidade**: Inicializar canais de notificação, pedir permissões e agendar alarmes.
- **Agendamento**: Usa `zonedSchedule` para garantir precisão de fuso horário.

### `BackupService`
- **Responsabilidade**: Exportar/Importar dados.
- **Formato**: JSON.
- **Fluxo de Exportação**:
  1. Lê todos os registros do Isar.
  2. Converte para Map/JSON.
  3. Usa `FilePicker` para salvar no dispositivo.
- **Fluxo de Importação**:
  1. Lê arquivo JSON.
  2. Valida estrutura.
  3. Limpa banco atual (opcional, atualmente faz merge/append ou limpa dependendo da implementação).
  4. Insere novos registros em lote (`writeTxn`).

---

## 3. Segurança

### Biometria (`AuthService`)
- Usa `local_auth`.
- Verifica `canCheckBiometrics` antes de tentar autenticar.
- Se falhar ou não tiver hardware, faz fallback (atualmente apenas avisa, idealmente fallback para PIN).

### Dados
- O banco Isar é salvo no diretório de documentos do aplicativo (`getApplicationDocumentsDirectory`), inacessível a outros apps em dispositivos não-root.

---

## 4. Guia de Publicação (Release)

Para gerar uma versão de produção (Google Play Store):

### Passo 1: Assinatura (Keystore)
Gere uma chave de upload se ainda não tiver:
```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```
Mova o arquivo `.jks` para a pasta `android/app/` (mas **NÃO** commite no Git).

### Passo 2: Propriedades da Chave
Crie o arquivo `android/key.properties`:
```properties
storePassword=sua_senha_store
keyPassword=sua_senha_key
keyAlias=upload
storeFile=upload-keystore.jks
```

### Passo 3: Configuração do Gradle
Certifique-se de que o `android/app/build.gradle.kts` está configurado para usar `signingConfigs.getByName("release")` no bloco `buildTypes { release { ... } }`.

### Passo 4: Build
Gere o App Bundle (.aab):
```bash
flutter build appbundle --release
```
O arquivo será gerado em: `build/app/outputs/bundle/release/app-release.aab`.

### Passo 5: Teste
Antes de subir, você pode testar o APK de release no seu celular:
```bash
flutter run --release
```
Isso garante que regras de ProGuard/R8 não quebraram nada (ex: serialização JSON).
