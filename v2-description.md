### The Internet of Things for Everyone

The Adafruit IO HTTP API provides access to your Adafruit IO data from any programming language or hardware environment that can speak HTTP. The easiest way to get started is with [an Adafruit IO learn guide](https://learn.adafruit.com/series/adafruit-io-basics) and [a simple Internet of Things capable device like the Feather Huzzah](https://www.adafruit.com/product/2821).

This API documentation is hosted on GitHub Pages and is available at [https://github.com/adafruit/io-api](https://github.com/adafruit/io-api). For questions or comments visit the [Adafruit IO Forums](https://forums.adafruit.com/viewforum.php?f=56) or the [adafruit-io channel on the Adafruit Discord server](https://discord.gg/adafruit).

#### Authentication

Authentication for every API request happens through the `X-AIO-Key` header or query parameter and your IO API key. A simple cURL request to get all available feeds for a user with the username "io_username" and the key "io_key_12345" could look like this:

    $ curl -H "X-AIO-Key: io_key_12345" https://io.adafruit.com/api/v2/io_username/feeds

Or like this:

    $ curl "https://io.adafruit.com/api/v2/io_username/feeds?X-AIO-Key=io_key_12345

Using the node.js [request](https://github.com/request/request) library, IO HTTP requests are as easy as:

```js
var request = require('request');

var options = {
  url: 'https://io.adafruit.com/api/v2/io_username/feeds',
  headers: {
    'X-AIO-Key': 'io_key_12345',
    'Content-Type': 'application/json'
  }
};

function callback(error, response, body) {
  if (!error && response.statusCode == 200) {
    var feeds = JSON.parse(body);
    console.log(feeds.length + " FEEDS AVAILABLE");

    feeds.forEach(function (feed) {
      console.log(feed.name, feed.key);
    })
  }
}

request(options, callback);
```

Using the ESP8266 Arduino HTTPClient library, an HTTPS GET request would look like this (replacing `---` with your own values in the appropriate locations):

```arduino
/// based on
/// https://github.com/esp8266/Arduino/blob/master/libraries/ESP8266HTTPClient/examples/Authorization/Authorization.ino

#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>
#include <ESP8266HTTPClient.h>

ESP8266WiFiMulti WiFiMulti;

const char* ssid = "---";
const char* password = "---";

const char* host = "io.adafruit.com";

const char* io_key = "---";
const char* path_with_username = "/api/v2/---/dashboards";

// Use web browser to view and copy
// SHA1 fingerprint of the certificate
const char* fingerprint = "77 00 54 2D DA E7 D8 03 27 31 23 99 EB 27 DB CB A5 4C 57 18";

void setup() {
  Serial.begin(115200);

  for(uint8_t t = 4; t > 0; t--) {
    Serial.printf("[SETUP] WAIT %d...\n", t);
    Serial.flush();
    delay(1000);
  }

  WiFi.mode(WIFI_STA);
  WiFiMulti.addAP(ssid, password);

  // wait for WiFi connection
  while(WiFiMulti.run() != WL_CONNECTED) {
    Serial.print('.');
    delay(1000);
  }

  Serial.println("[WIFI] connected!");

  HTTPClient http;

  // start request with URL and TLS cert fingerprint for verification
  http.begin("https://" + String(host) + String(path_with_username), fingerprint);

  // IO API authentication
  http.addHeader("X-AIO-Key", io_key);

  // start connection and send HTTP header
  int httpCode = http.GET();

  // httpCode will be negative on error
  if(httpCode > 0) {
    // HTTP header has been send and Server response header has been handled
    Serial.printf("[HTTP] GET response: %d\n", httpCode);

    // HTTP 200 OK
    if(httpCode == HTTP_CODE_OK) {
      String payload = http.getString();
      Serial.println(payload);
    }

    http.end();
  }
}

void loop() {}
```

#### Client Libraries

We have client libraries to help you get started with your project: [Python](https://github.com/adafruit/io-client-python), [Ruby](https://github.com/adafruit/io-client-ruby), [Arduino C++](https://github.com/adafruit/Adafruit_IO_Arduino), [Javascript](https://github.com/adafruit/adafruit-io-node), and [Go](https://github.com/adafruit/io-client-go) are available. They're all open source, so if they don't already do what you want, you can fork and add any feature you'd like.

