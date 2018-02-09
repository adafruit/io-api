# Adafruit IO API Documentation

The HTTP REST API documentation for [Adafruit IO](https://io.adafruit.com) written using [Swagger v2](http://swagger.io).


## Generating Client Libraries With Swagger

While we provide custom API clients in several languages (Javascript, Python, Ruby, Go), there are just too many languages for us to support everything. The good news is that Swagger can generate clients based on our [existing API documentation](https://io.adafruit.com/api/docs/).

The easiest way to generate a client in a new language ([supported languages listed here](https://github.com/swagger-api/swagger-codegen#api-clients)) is to open up our documentation in the Swagger Editor at http://editor.swagger.io. Use `File` -> `Import URL...` to load the Adafruit IO API specification.

![Swagger file menu](https://github.com/adafruit/io-api/blob/gh-pages/images/swagger-file-menu.png)

The URL to use for the current API is `https://io.adafruit.com/api/docs/v2.json`.

Next, select the language you'd like to generate a library for, and download the resulting .zip file.

![Swagger generate client menu](https://github.com/adafruit/io-api/blob/gh-pages/images/swagger-generate-client-menu.png)

Unfortunately, we can't provide support for specific, auto-generated clients, but we're always available to provide general support for our API. Please get in touch [on the Forum](https://forums.adafruit.com/viewforum.php?f=56) if you have any questions.


## License

Copyright (c) 2015 [Adafruit Industries](https://adafruit.com). Licensed under the [MIT license](/LICENSE?raw=true).

[Adafruit](https://adafruit.com) invests time and resources providing this open source code. Please support Adafruit and open-source hardware by purchasing products from [Adafruit](https://adafruit.com).
