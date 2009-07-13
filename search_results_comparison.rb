require 'rubygems'
require 'sinatra'
require 'hpricot'
require 'json'
require 'ruby-web-search'

BOSS_API_KEY = "key goes here"

layout 'layout.erb'

get '/' do
  erb :index
end

post '/results' do
  @google_results = RubyWebSearch::Google.search(:query => params[:query], :size => 10)
  @yahoo_results = build_yahoo_result(params[:query])
  erb :results
end

helpers do
    
  def build_yahoo_result(query)
    base_search_url = "http://boss.yahooapis.com/ysearch/web/v1/"
    search_url = "#{base_search_url}#{URI.encode(query)}?appid=#{BOSS_API_KEY}&count=10&start=0"
    resp = Net::HTTP.get_response(URI.parse(search_url))
    data = resp.body
    
    yahoo_result = JSON.parse(data)
    
    if yahoo_result.has_key? 'Error'
      raise 'web service error'
    end
    return yahoo_result['ysearchresponse']
  end
  
end

use_in_file_templates!

__END__

@@ layout
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>

	<title>Search Engine Result Comparison</title>
	<script type="text/javascript" charset="utf-8" src="http://jqueryjs.googlecode.com/files/jquery-1.3.2.min.js"> </script>
	<script type="text/javascript" charset="utf-8" src="application.js"> </script>
  <link rel="stylesheet" href="application.css" type="text/css" media="screen" title="no title" charset="utf-8" />
</head>

<body>
  <div id="header">
    <h1>Search Engine Result Comparison</h1>
  </div>
  <%= yield %>
    
@@ index
<div id="select">
  <form action="/results" method="post" accept-charset="utf-8">
    <input type="text" name="query" />
    <input type="image" src="img/search_button.png" />
  </form>
</div>

@@ results
<h3>Pick the result you feel is most relevant</h3>
<ul id="1">
  <% @google_results.results.each do |r| %>
  <li class="result" id="1_<%= r.id %>">
    <a href="<%= r[:url] %>"><%= r[:title] %></a><br/>
    <p><%= r[:content] %></p>
    <button value="1" class="picker">pick me!</button>
  </li>
  <% end %>
</ul>
<ul id="2">
  <% @yahoo_results['resultset_web'].each do |y| %>
    <li class="result" id="2_<%= y.id %>">
      <a href="<%= y['url'] %>"><%= y['title'] %></a><br/>
      <p><%= y['abstract'] %></p>
      <button value="2" class="picker">pick me!</button>
    </li>
  <% end %>
</ul>
<div id="results">
  
</div>