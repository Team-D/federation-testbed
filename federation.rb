require 'sinatra'
require "bundler/setup"
require 'diaspora-federation'
require 'open-uri'
require "erb"
require "rest-client"


before do
	@new_post 
	@posts_array = []
	get_keys
	set_up_user
end

def set_up_user
	@user = "bob"
	@guid = '1guidnotyettaken'
end

def get_stream 
  @doc = Nokogiri::XML(open('https://joindiaspora.com/public/carolinagc.atom'))
  @post_titles = @doc.xpath('//xmlns:title')

  @post_titles_str = ""
  for i in 1..(@post_titles.length - 1)
    @p = @post_titles[i].to_html
    @post_titles_str << @p.gsub!("title", "div class=post_titles ") << "<a id=" << i.to_s << " onclick='jump_to(id)'>read more </a>"
  end

  @post_bodies = @doc.xpath('//xmlns:content')
  @post_bodies_str = ""
  for i in 1..(@post_bodies.length - 1)
    @p = @post_bodies[i].to_html
    @post_bodies_str << @p.gsub!("content", "div class=post_titles " << "id=" << (100*i).to_s)
  end
end

def get_keys
	 #yes this private key has been published on purpose
	@private_key = OpenSSL::PKey::RSA.new("-----BEGIN RSA PRIVATE KEY-----
MIIBOQIBAAJBAKtyhJJ31VEwBydStIxJQNFqRCSm1/OEUXPXNvjrzlOw3eu8HUNv
Y+N9SOmUiZXvaSxbMJdpMo5aCMc8vkoubbsCAwEAAQJAMzDORK1jFAqzGBqprflx
URXZotfuQtePOndYAprl0DbR7HsJV67EZWsFCdOEQE4zgf7syrsR7Yq2afa6mR1r
AQIhANT8yrVx8Bxj3qd8gkXr8vREcLTQ6VWdtyOb80tDxKnpAiEAzhImFA3ijIUR
1G/j0fPYMbYQzh8mG5+sQ01xlE8m8AMCIFAWOhbeH/5c40UxQT8PiMymy4aCI6sI
4etm4aYEdne5AiBMybyAuo/R9wAm3i7RnIDSPVrTxA2qO3ywc5pAPqJuywIgI2kt
eQhMdKZgywr+rKn170HYlW6mWE9OWM9M48NtAEg=
-----END RSA PRIVATE KEY-----")

	@public_key = OpenSSL::PKey::RSA.new("-----BEGIN PUBLIC KEY-----
MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAKtyhJJ31VEwBydStIxJQNFqRCSm1/OE
UXPXNvjrzlOw3eu8HUNvY+N9SOmUiZXvaSxbMJdpMo5aCMc8vkoubbsCAwEAAQ==
-----END PUBLIC KEY-----")
	#the way to generate keys: 
		#key_size = 512
	  #@serialized_private_key = OpenSSL::PKey::RSA::generate(key_size).to_s
	  #@serialized_public_key = OpenSSL::PKey::RSA.new(serialized_private_key).public_key.to_s
end

def generate_xml_public(post_content)
	#generates from the post content the xml which is needed to send it to other pods
  e = DiasporaFederation::Entities::StatusMessage.new({
      raw_message: '#{post_content}', guid: SecureRandom.hex(16),
      diaspora_handle: "#{@user}@tinyd.heroku.com", created_at: DateTime.now, public: true })
  @xml = DiasporaFederation::Salmon::Slap.generate_xml("#{@user}@tinyd.heroku.com", @private_key, e)
  RestClient.post "https://wk3.org/receive/public", {:xml => @xml}
end

def read_posts_file()
	posts_file = File.open('posts.txt', 'a+') 
	posts_file.each_line {|line| @posts_array.push(line)}
	posts_file.close
end

def save_posts_to_file(post_content)
	posts_file = File.open('posts.txt', 'a+')
	posts_file << post_content << "\n"
	posts_file.close
end


#routes

get '/.well-known/host-meta' do
  hostmeta = DiasporaFederation::WebFinger::HostMeta.from_base_url('https://tinyd.heroku.com')
  hostmeta.to_xml
end

get '/' do
  get_stream 
  read_posts_file()   
  erb :index
end

get '/webfinger' do
	wf = DiasporaFederation::WebFinger::WebFinger.from_account({ 
		acct_uri:    "#{@user}@tinyd.heroku.com",
    alias_url:   'https://tinyd.heroku.com/lala/lala3412',
    hcard_url:   'https://tinyd.heroku.com/federation/hcard',
    seed_url:    'https://tinyd.heroku.com/',
    profile_url: 'https://tinyd.heroku.com/',
    updates_url: 'https://tinyd.heroku.com/public/user.atom',
    guid:        @guid,
    pubkey:      @public_key
  })
  wf.to_xml
end

get '/federation/hcard' do
  hcard = DiasporaFederation::WebFinger::HCard.from_account({
    guid:             @guid,
    diaspora_handle:  "#{@user}@tinyd.heroku.com",
    full_name:        @user,
    url:              'https://tinyd.heroku.com/',
    photo_full_url:   'https://tinyd.heroku.com/profile.jpg',
    photo_medium_url: 'https://tinyd.heroku.com/profile.jpg',
    photo_small_url:  'https://tinyd.heroku.com/profile.jpg',
    pubkey:           @public_key,
    searchable:       true,
    first_name:       "#{@user}",
    last_name:        'foo'
  })
  html_string = hcard.to_html
end

post '/' do
  get_stream
 	@new_post = "#{params[:post_content]}"
 	generate_xml_public(@new_post)
 	save_posts_to_file(@new_post)
 	read_posts_file()
  erb :index
end

get '/public/user.atom'  do
  @doc = Nokogiri::XML(open('https://joindiaspora.com/public/carolinagc.atom'))
  @post_title = @doc.xpath('//xmlns:title')

  builder :feed
end

get '/read_post' do

end
