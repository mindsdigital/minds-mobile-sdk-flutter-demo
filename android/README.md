

# Configuração do Projeto

# Adicionando o plugin do Google Artifact Registry:

Para adicionar o plugin Gradle que permite a integração do projeto com o Google Artifact Registry, inclua a seguinte linha no arquivo `build.gradle`:

```gradle
plugins {
    id "com.google.cloud.artifactregistry.gradle-plugin" version "2.1.5"
}
```
Certifique-se de especificar a versão mais recente do plugin compatível com o seu projeto.

Essa etapa é importante para que o Gradle possa buscar e baixar as dependências necessárias para o projeto no Google Artifact Registry.

# Adicionando um repositório Maven

Para adicionar um repositório Maven no Gradle, inclua a seguinte linha no arquivo `build.gradle`:

```gradle
repositories {
    google()
    mavenCentral()
    maven {
        url "artifactregistry://us-east1-maven.pkg.dev/minds-digital-238513/mobile-sdk-android"
    }
}
```

Certifique-se de especificar a URL correta do repositório Maven que você deseja adicionar.

Essa etapa é importante para que o Gradle possa buscar e baixar as dependências necessárias para o projeto no repositório Maven especificado.

# Habilitando as funcionalidades de binding:

Para habilitar as funcionalidades de binding de views e binding de dados do Android no projeto, inclua as seguintes linhas no arquivo `build.gradle`:

```gradle
android {
    buildFeatures {
        viewBinding true
        dataBinding true
    }
}
```

# Adicionando dependências:

Para adicionar as dependências necessárias para o projeto, inclua as seguintes linhas no arquivo `build.gradle`:

```gradle
dependencies {
    implementation 'digital.minds.clients.sdk.android:release:1.17.2'
    implementation 'digital.minds.clients.sdk.kotlin.core:release:1.0.13'
}
```

## Aplicando o plugin:

Para aplicar o plugin do Google Artifact Registry ao projeto, inclua a seguinte linha no arquivo `build.gradle`:


```gradle
apply plugin: 'com.google.cloud.artifactregistry.gradle-plugin'
```
Essa etapa é importante para que o Gradle possa buscar e baixar as dependências necessárias para o projeto no Google Artifact Registry.


# Configuração da Classe Minds Config

A classe MindsConfig é responsável por configurar a SDK para a operação de autenticação ou cadastro de biometria, dependendo do método escolhido.

Os métodos `enrollment` e `authentication` criam um objeto `MindsSDK` com as configurações necessárias para cada operação, incluindo o CPF do usuário, o token de acesso, o telefone do usuário e outras informações relevantes.

```kotlin
import digital.minds.clients.sdk.kotlin.domain.helpers.Environment
import digital.minds.clients.sdk.kotlin.domain.helpers.ProcessType
import digital.minds.clients.sdk.kotlin.main.MindsSDK

class MindsConfig {
    companion object {
        fun enrollment(cpf: String, token: String, telephone: String): MindsSDK {
            return MindsSDK
                .Builder()
                .setToken(token)
                .setCPF(cpf)
                .setEnvironment(Environment.SANDBOX)
                .setExternalID(null)
                .setPhoneNumber(telephone)
                .setProcessType(ProcessType.ENROLLMENT)
                .setExternalCustomerId(null)
                .setShowDetails(true)
                .build()
        }

        fun authentication(cpf: String, token: String, telephone: String): MindsSDK {
            return MindsSDK
                .Builder()
                .setToken(token)
                .setCPF(cpf)
                .setEnvironment(Environment.SANDBOX)
                .setExternalID(null)
                .setPhoneNumber(telephone)
                .setProcessType(ProcessType.AUTHENTICATION)
                .setExternalCustomerId(null)
                .setShowDetails(true)
                .build()
        }
    }
}
```

O objeto `MindsSDK` retornado por esses métodos é passado para a SDK através do método `MindsDigital.getIntent()`, que é responsável por iniciar a operação na SDK


# Configuração do Method Channel

Primeiramente, é necessário criar uma instância do MethodChannel que será utilizado para se comunicar com a aplicação Flutter. O nome do canal de comunicação é "digital.minds".

```kotlin
private val channel = "digital.minds"
```

Em seguida, é criada uma instância das classes `enrollmentMindsSDK` e `authenticationMindsSDK`, que serão utilizadas para realizar as operações de cadastro e autenticação de usuários, respectivamente. Além disso, é criada uma variável `_result` do tipo `MethodChannel.Result`, que será utilizada para retornar o resultado das operações ao Flutter.

```kotlin
private lateinit var enrollmentMindsSDK: MindsSDK
private lateinit var authenticationMindsSDK: MindsSDK
private lateinit var _result: MethodChannel.Result
```
O método `configureFlutterEngine` é sobrescrito para configurar a `FlutterEngine`. Nele, é criado um `MethodChannel` e um `MethodCallHandler` para receber chamadas de métodos do Flutter.

```kotlin
override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
        .setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            // código do handler
        }
}
```

Dentro do `MethodCallHandler`, é verificado qual método foi chamado pelo Flutter e é feita a chamada à SDK correspondente. É utilizado o `CoroutineScope` para realizar a chamada de forma assíncrona, e o resultado é retornado ao Flutter através da variável `_result`.

```kotlin
when (call.method) {
    "authentication" -> {
        authenticationMindsSDK =
            MindsConfig.authentication(cpf!!, token!!, telephone!!)
        CoroutineScope(Dispatchers.Main).launch {
            try {
                val intent =
                    MindsDigital.getIntent(context, authenticationMindsSDK)
                startActivityForResult(intent, 0)
            } catch (e: Exception) {
                result.error("MINDS_SDK_INIT_ERROR", e.message, null)
            }
        }
    }
    "enrollment" -> {
        enrollmentMindsSDK = MindsConfig.enrollment(cpf!!, token!!, telephone!!)
        CoroutineScope(Dispatchers.Main).launch {
            try {
                val intent = MindsDigital.getIntent(context, enrollmentMindsSDK)
                startActivityForResult(intent, 0)
            } catch (e: Exception) {
                result.error("MINDS_SDK_INIT_ERROR", e.message, null)
            }
        }
    }
    else -> result.notImplemented()
}
```

Quando a operação é concluída na SDK, é chamado o método `onActivityResult`, que retorna o resultado ao Flutter através da variável `_result`.

```kotlin
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (resultCode != Activity.RESULT_OK || data == null) return
        val mindsSDKResponse = data.extras?.get(VOICE_MATCH_RESPONSE) as? VoiceMatchResponse
        val jsonObject = JSONObject().apply {
            put("success", mindsSDKResponse?.success)
            put("error", JSONObject().apply {
                put("code", mindsSDKResponse?.error?.code)
                put("description", mindsSDKResponse?.error?.description)
            })
            put("id", mindsSDKResponse?.id)
            put("cpf", mindsSDKResponse?.cpf)
            put("external_id", mindsSDKResponse?.external_id)
            put("created_at", mindsSDKResponse?.created_at)
            put("result", JSONObject().apply {
                put("recommended_action", mindsSDKResponse?.result?.recommended_action)
                put("reasons", JSONArray(mindsSDKResponse?.result?.reasons))
            })
            put("details", JSONObject().apply {
                put("flag", JSONObject().apply {
                    put("id", mindsSDKResponse?.details?.flag?.id)
                    put("type", mindsSDKResponse?.details?.flag?.type)
                    put("description", mindsSDKResponse?.details?.flag?.description)
                    put("status", mindsSDKResponse?.details?.flag?.status)
                })
                put("voice_match", JSONObject().apply {
                    put("result", mindsSDKResponse?.details?.voice_match?.result)
                    put("confidence", mindsSDKResponse?.details?.voice_match?.confidence)
                    put("status", mindsSDKResponse?.details?.voice_match?.status)
                })
            })
        }
        val jsonString = jsonObject.toString()
        _result.success(jsonString)
    }
}
```

# Chamar `MethodChannel` no Flutter

Crie um MethodChannel e defina o nome do canal para a comunicação com a plataforma nativa:

```dart
final channel = MethodChannel('digital.minds');
```
Defina o método que será chamado na plataforma nativa e os argumentos a serem passados para ele:

```dart
Future<void> _authentication(String cpf, String token, String telephone) async {
  try {
    await channel.invokeMethod('authentication', {'cpf': cpf, 'token': token, 'telephone': telephone});
  } on PlatformException catch (e) {
    // Handle error
  }
}
```

## 📌 Observação

É importante ressaltar que o integrador deve garantir que a permissão do microfone seja fornecida em seu aplicativo Flutter antes de utilizar a SDK. Sem essa permissão, a SDK não funcionará corretamente. É responsabilidade do integrador garantir que seu aplicativo tenha as permissões necessárias para utilizar a SDK com sucesso.


## 🛠️ Corrigir possíveis problemas 

Em caso de erro "What went wrong: Execution failed for task `:app:processDebugMainManifest` , você deve adicionar a tag "tools:replace" com o valor "android:label" dentro da tag <application> no arquivo AndroidManifest.xml do seu projeto. 

Esse erro ocorre porque há um conflito no arquivo AndroidManifest.xml, especificamente com a tag <application>. O atributo application@label está presente tanto no arquivo AndroidManifest.xml do projeto quanto no arquivo AndroidManifest.xml da SDK da Minds.

O código deve ficar assim:

```dart
<application
    tools:replace="android:label">
</application>
```

Dessa forma, o atributo label do arquivo da SDK será substituído pelo atributo label do seu projeto. Essa configuração permitirá que o erro seja resolvido.





