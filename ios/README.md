

# Configuração do Projeto


Para integrar a SDK da Minds no seu projeto iOS, é necessário seguir os seguintes passos:

- Abra o seu projeto no Xcode e selecione o target do seu aplicativo.
- Clique na aba "Swift Packages" na parte superior da janela.
- Clique no botão "+" no canto inferior esquerdo da janela para adicionar um pacote.
- Na caixa de diálogo que aparece, cole a URL do repositório da SDK da Minds: https://github.com/mindsdigital/minds-sdk-mobile-ios.git
- Certifique-se de que o destino esteja selecionado corretamente e clique em "Finish".
- Aguarde a importação da SDK ser concluída.

# Criar AppDelegate

Importe o SDK no seu projeto. Na classe AppDelegate, importe o SDK adicionando a linha abaixo:

```swift
import MindsSDK
```

Crie um canal de comunicação (`Method Channel`). Na mesma classe `AppDelegate`, adicione o seguinte trecho de código:

```swift
let controller = window.rootViewController as! FlutterViewController
let mindsChannel = FlutterMethodChannel(name: "digital.minds", binaryMessenger: controller.binaryMessenger)

mindsChannel.setMethodCallHandler({
    [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
    self?.flutterResult = result
    let args = call.arguments as? Dictionary<String, Any>
    
    switch(call.method){
    case "authentication", "enrollment":
        guard let args = call.arguments as? [String: Any],
              let cpf = args["cpf"] as? String,
              let token = args["token"] as? String,
              let telephone = args["telephone"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required arguments", details: nil))
            return
        }
        self?.startSDK(processType: call.method == "authentication" ? .authentication : .enrollment, cpf: cpf, token: token, telephone: telephone, externalId: nil, externalCustomerId: nil)
        
    default:
        result(FlutterMethodNotImplemented)
        return
    }
})
```

## Inicialize o SDK com as configurações necessárias. Ainda na classe `AppDelegate`, adicione o método `startSDK` abaixo:


```swift
private func startSDK(processType: MindsSDK.ProcessType, cpf: String, token: String, telephone: String, externalId: String?, externalCustomerId: String?) {
    guard let navigationController: UINavigationController = navigationController else { return }
    
    sdk = MindsSDK(delegate: self)
    sdk?.setToken(token)
    sdk?.setExternalId(externalId)
    sdk?.setExternalCustomerId(externalCustomerId)
    sdk?.setPhoneNumber(telephone)
    sdk?.setShowDetails(true)
    sdk?.setCpf(cpf)
    sdk?.setProcessType(processType)
    sdk?.setEnvironment(.sandbox)
    
    sdk?.initialize(on: navigationController) { error in
        if let error = error {
            do {
                throw error
            } catch DomainError.invalidCPF(let message) {
                print("\(message ?? "")")
            } catch {
                print("\(error): \(error.localizedDescription)")
            }
            self.flutterResult?(nil)
        }
    }
}
```
## Implemente o protocolo MindsSDKDelegate para lidar com as respostas do SDK.

```swift
    private func biometricsReceive(_ response: BiometricResponse) {
        let json: [String: Any?] = [
            "success": response.success,
            "error": [
                "code": response.error?.code,
                "description": response.error?.description
            ],
            "id": response.id,
            "cpf": response.cpf,
            "external_id": response.externalID,
            "created_at": response.createdAt,
            "result": [
                "recommended_action": response.result?.recommendedAction as Any,
                "reasons": response.result?.reasons as Any
            ],
            "details": [
                "flag": [
                    "id": response.details?.flag?.id as Any ,
                    "type": response.details?.flag?.type as Any,
                    "description": response.details?.flag?.description as Any,
                    "status": response.details?.flag?.status as Any
                ],
                "voice_match": [
                    "result": response.details?.voiceMatch?.result as Any,
                    "confidence": response.details?.voiceMatch?.confidence as Any,
                    "status": response.details?.voiceMatch?.status as Any
                ]
            ]
        ]
        if let jsonData = try? JSONSerialization.data(withJSONObject: json),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
            flutterResult?(jsonString)
        }
    }
    
}

extension AppDelegate: MindsSDKDelegate {
    func showMicrophonePermissionPrompt() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            print("granted: \(granted)")
        }
    }
    
    func microphonePermissionNotGranted() {
        print("microphonePermissionNotGranted")
    }
    
    func onSuccess(_ response: BiometricResponse) {
        self.biometricsReceive(response)
    }
    
    func onError(_ response: BiometricResponse) {
        self.biometricsReceive(response)
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

Adicione permissão ao seu arquivo `Info.plist`.

```xml
<key>NSMicrophoneUsageDescription</key>
<string>Descrição do uso do microfone</string>
```

Adicione também a permissão a seu arquivo PodFile:

<details>
<summary>Podfile</summary>

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    # Start of the permission_handler configuration
    target.build_configurations.each do |config|

      # You can enable the permissions needed here. For example to enable camera
      # permission, just remove the `#` character in front so it looks like this:
      #
      # ## dart: PermissionGroup.camera
      # 'PERMISSION_CAMERA=1'
      #
      #  Preprocessor definitions can be found in: https://github.com/Baseflow/flutter-permission-handler/blob/master/permission_handler_apple/ios/Classes/PermissionHandlerEnums.h
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',

        ## dart: PermissionGroup.microphone
        'PERMISSION_MICROPHONE=1',

      ]

    end 
    # End of the permission_handler configuration
  end
end
```

</details>







