require 'sinatra'
require "bundler/setup"
require 'diaspora-federation'
require 'open-uri'
require "erb"
require "rest-client"

def get_stream 
  @doc = Nokogiri::XML(open('https://joindiaspora.com/public/carolinagc.atom'))
  @post_title = @doc.xpath('//xmlns:title')

  @post_titles = ""
  for i in 1..(@post_title.length - 1)
    @p = @post_title[i].to_html
    @post_titles << @p.gsub!("title", "div class=post_titles") << "<a href=''>read more </a>"
  end
  @post_bodies = @doc.xpath('//xmlns:content').to_html
end

def generate_keys
  key_size = 512
  @serialized_private_key = OpenSSL::PKey::RSA::generate(key_size).to_s
  @serialized_public_key = OpenSSL::PKey::RSA.new(serialized_private_key).public_key.to_s
end

get '/.well-known/host-meta' do
  hostmeta = DiasporaFederation::WebFinger::HostMeta.from_base_url('http://tinyd.heroku.com')
  hostmeta.to_xml
end

get '/' do
  get_stream         
#  generate_keys
  erb :index
end

get '/webfinger' do
	key_size = 4096
  serialized_private_key = OpenSSL::PKey::RSA::generate(key_size).to_s
  serialized_public_key = OpenSSL::PKey::RSA.new(serialized_private_key).public_key.to_s

  wf = DiasporaFederation::WebFinger::WebFinger.from_account({ 
		acct_uri:    'user@tinyd.heroku.com',
    alias_url:   'https://tinyd.heroku.com/lala/lala3412',
    hcard_url:   'https://tinyd.heroku.com/federation/hcard',
    seed_url:    'https://tinyd.heroku.com/',
    profile_url: 'https://tinyd.heroku.com/',
    updates_url: 'https://tinyd.heroku.com/public/user.atom',
    guid:        '0123456789abcdef',
    pubkey:      serialized_public_key
  })
  wf.to_xml
end

get '/federation/hcard' do
	key_size = 4096
  serialized_private_key = OpenSSL::PKey::RSA::generate(key_size).to_s
  serialized_public_key = OpenSSL::PKey::RSA.new(serialized_private_key).public_key.to_s

  hcard = DiasporaFederation::WebFinger::HCard.from_account({
    guid:             '0123456789abcdef',
    diaspora_handle:  'user@tinyd.heroku.com',
    full_name:        'username',
    url:              'https://tinyd.heroku.com/',
    photo_full_url:   'https://tinyd.heroku.com/public/profile.jpg',
    photo_medium_url: 'https://tinyd.heroku.com/uploads/m.jpg',
    photo_small_url:  'https://tinyd.heroku.com/uploads/s.jpg',
    pubkey:           serialized_public_key,
    searchable:       true,
    first_name:       'user',
    last_name:        'user last name'
  })
  html_string = hcard.to_html
end

def generate_xml(post_content)
		key_size = 4096
  serialized_private_key = OpenSSL::PKey::RSA::generate(key_size).to_s
  serialized_public_key = OpenSSL::PKey::RSA.new(serialized_private_key).public_key.to_s

  e = DiasporaFederation::Entities::StatusMessage.new({
                                                        raw_message: '#{post_content}', guid: SecureRandom.hex(16),
                                                        diaspora_handle: 'carolinagc@wk3.org', created_at: DateTime.now, public: true })
  @xml = DiasporaFederation::Salmon::Slap.generate_xml('carolinagc@wk3.org', serialized_private_key, e)
  #RestClient.post "https://wk3.org/receive/public", {:xml => @xml}
end

post '/' do
  get_stream
  @new_post = "#{params[:post_content]}"
  #generate_xml(@new_post)
  erb :index, :locals => {:new_post => @new_post} 
end

get '/public/user.atom'  do
  @doc = Nokogiri::XML(open('https://joindiaspora.com/public/carolinagc.atom'))
  @post_title = @doc.xpath('//xmlns:title')

  builder :feed
end


