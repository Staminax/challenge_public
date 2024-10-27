# Weather App - Challenge

## Pré-requisitos

Certifique-se de ter as ferramentas necessárias instaladas:

1. **Flutter**: [Guia de instalação](https://flutter.dev/docs/get-started/install)
2. **Extensões**: Instale as extensões do Flutter e Dart no VSCode e/ou Android Studio
3. **Android Studio**: (para emuladores Android) ou **Xcode** (para iOS)
4. Um emulador Android ou um dispositivo físico para rodar o projeto
5. Após clonar o repositório, abra o projeto em sua IDE (VSCode ou Android Studio), execute o comando 'flutter pub get' para instalar as dependências.
6. Através do menu do VSCode, por exemplo, basta clicar em 'Run > Start Debugging ou Run Without Debugging' ou aperte F5.
7. **Importante**: Caso deseje rodar o projeto em Debug, certifique-se de alterar as chaves/parâmetros das API's respectivas utilizadas. Vá até o arquivo ```KeysOrParams.dart``` e substitua os valores de ```OPEN_WEATHER_API_KEY``` e ```GEONAMES_API_USERNAME```
8. **Importante**: Altere a chave de API do Google Maps no arquivo ```AndroidManifest.xml```, na Tag ```<meta-data android:name="com.google.android.geo API_KEY" android:value="YOUR_GOOGLE_MAPS_API_KEY"/>```
9. API's Utilizadas: ```https://api.openweathermap.org/data/3.0/onecall```, ```http://api.geonames.org/findNearbyPlaceNameJSON``` e ```Google Maps API```
