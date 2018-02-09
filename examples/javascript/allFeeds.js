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
      console.log(" ", feed.name, "||", feed.key);
    })
  }
}

request(options, callback);
