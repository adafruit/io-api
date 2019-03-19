require 'json'
require 'erb'
require 'fileutils'

content = open('v2.json').read()

DOCS = JSON.parse(content)
REF = {
  'parameters' => DOCS['parameters'],
  'definitions' => DOCS['definitions']
}
REFERENCE_MATCHER = /#\/([a-z]+)\/(.+)/

template = DATA.read
docs = ERB.new(template)

def template_data(method, path, section)
  summary = section['summary']
  description = section['description']

  _response = section['responses']['200']

  if _response['schema']
    if ref = _response['schema']['$ref']
      _, ref_type, label = REFERENCE_MATCHER.match(ref).to_a
      resp_content = REF[ref_type][label]
      response = JSON.pretty_generate(resp_content)
    else
      response = JSON.pretty_generate(_response['schema'])
    end
  else
    response = nil
  end

  response_description = _response['description']
  parameters = { "path" => [], "query" => [], "body" => [] }

  if section['parameters']
    section['parameters'].each do |param|
      if ref = param['$ref']
        _, ref_type, label = REFERENCE_MATCHER.match(ref).to_a
        param = REF[ref_type][label]

        parameters[param['in']] << {
          parameter: param['name'],
          type: param['type'] || (param['schema']['type']),
          required: !!param['required'],
          description: param['description'],
        }
      end
    end
  end
  request = "#{method.upcase} #{path}"

  # puts "-" * 90
  # puts "REQUEST: #{request}"
  # puts "SUMMARY: #{summary}"
  # puts "DESCRIPTION: #{description}"
  # puts "RESPONSE: #{response}"
  # puts "PARAMETERS: #{parameters}"

  [ binding, section['tags'][0] ]
end

DOCS['paths'].keys.each do |path|
  url_section = DOCS['paths'][path]

  tags = {}

  %w(get post put delete).each do |method|
    if url_section[method]
      template_binding, tag = template_data(method, path, url_section[method])
      filename = "export/_#{ tag.downcase }.md.erb"

      if tags[tag].nil?
        FileUtils.touch(filename)
        open(filename, 'w') do |f|
          f.puts "# #{ tag }"
        end
        tags[tag] = true
      end

      puts "--- #{ tag } #{ method } #{ path } > #{ filename } ---"
      out = docs.result(template_binding)

      open(filename, 'a') do |f|
        f.puts ""
        f.puts out
        f.puts ""
      end
    end
  end
end

__END__
## <%= summary %>

```shell
```

```python
```

```cpp
```

```ruby
```

> Response Sample:

```json
<%= response %>
```

<%= response_description %>


### HTTP Request

`<%= request %>`

<% if parameters['path'].size > 0 %>
### Path Parameters

Parameter |   Type  |  Required |       Description
--------- | ------- | --------- | -----------------------
<% parameters['path'].each do |param| %><%= param[:parameter] %> | <%= param[:type] %> | <%= param[:required] %> | <%= param[:description] %><% end %>
<% end %>


<% if parameters['query'].size > 0 %>
### Query Parameters

Parameter |   Type  |  Required |       Description
--------- | ------- | --------- | -----------------------
<% parameters['query'].each do |param| %><%= param[:parameter] %> | <%= param[:type] %> | <%= param[:required] %> | <%= param[:description] %><% end %>
<% end %>


<% if parameters['body'].size > 0 %>
### Body Parameters

Parameter |   Type  |  Required |       Description
--------- | ------- | --------- | -----------------------
<% parameters['body'].each do |param| %><%= param[:parameter] %> | <%= param[:type] %> | <%= param[:required] %> | <%= param[:description] %><% end %>
<% end %>

