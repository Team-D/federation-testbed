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

get '/federation/host-meta' do
  hostmeta = DiasporaFederation::WebFinger::HostMeta.from_base_url('http://lala.com')
  hostmeta.to_xml

end

get '/' do
  get_stream         
#  generate_keys
  erb :index
end

get '/federation/webfinger' do
  @pkey = OpenSSL::PKey::RSA.new File.read('/home/sonduk/Documentos/mis_cosillas/proyectos/diaspora/wk3/carolinagc_public_wk3.asc')
  wf = DiasporaFederation::WebFinger::WebFinger.from_account({ 
		acct_uri:    'lala@example.com',
    alias_url:   'https://server.example/lala/lala3412',
    hcard_url:   'https://server.example/hcard/users/user',
    seed_url:    'https://server.example/',
    profile_url: 'https://server.example/u/user',
    updates_url: 'https://diaspora-fr.org/public/carolina.atom',
    guid:        '0123456789abcdef',
    pubkey:      @pkey
  })
  wf.to_xml
end

get '/federation/hcard' do
  hcard = DiasporaFederation::WebFinger::HCard.from_account({
    guid:             '0123456789abcdef',
    diaspora_handle:  'lala@lala.com',
    full_name:        'Lala lala',
    url:              'https://lala.com/',
    photo_full_url:   'https://lala.com/uploads/f.jpg',
    photo_medium_url: 'https://lala.com/uploads/m.jpg',
    photo_small_url:  'https://lala.com/uploads/s.jpg',
    pubkey:           'ABCDEF==',
    searchable:       true,
    first_name:       'lala',
    last_name:        'Lala'
  })
  html_string = hcard.to_html
end

def generate_xml(post_content)
  e = DiasporaFederation::Entities::StatusMessage.new({
                                                        raw_message: '#{post_content}', guid: SecureRandom.hex(16),
                                                        diaspora_handle: 'carolinagc@wk3.org', created_at: DateTime.now, public: true })
  @pkey =  OpenSSL::PKey::RSA::generate(4096).to_s
  @xml = DiasporaFederation::Salmon::Slap.generate_xml('carolinagc@wk3.org', @pkey, e)
  RestClient.post "https://wk3.org/receive/public", {:xml => @xml}
end

post '/' do
  get_stream
  @new_post = "#{params[:post_content]}"
  generate_xml(@new_post)
  erb :index, :locals => {:new_post => @new_post} 
end

get '/rss'  do
  @doc = Nokogiri::XML(open('https://joindiaspora.com/public/carolinagc.atom'))
  @post_title = @doc.xpath('//xmlns:title')

  builder :feed
end


