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
	@user = "cucumber"
	@guid = '8a82cc30c12d33bafb6d2cae95cb4355'
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
 	@private_key = OpenSSL::PKey::RSA.new("-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEA28B2MU4p2p/T/LzzXwb8rU3peyYpivKDvy45dpJg+OSjuKlS\nVxFsyYcC/8LhXfVMYmePOEtuqmUkCsgu3oKytz77DcV01QZwYVHJXrsSGm15gTaI\nmF5vdZvt+UUo2EgLBQJfu9R2ekYZHqF2P4pmsEsfdyJpk6wkd78IkJN7RJ2RX+5F\nkpyA29RHpW113d8bRDXWZIGGzWv80vbeQyZ5YRFtZW1fc1xqv2P6aHI1cmxYpqjX\nw956DJt9gnLsCNtTR1gqur5OW7Bb3CcEwsQVNdatYtmlJ14C5aAjdDEf+51uWO2N\ne9NPyb/6J1lhx0826a4aUqzsCxcxz1zHa52yUwIDAQABAoIBAQCZ4w9hu8DnjqFf\nDdrIIxZzLmpgiPryiJ3mFbK77AnoggR83mYA/vzVq6xX+trjd1IEX00WOQzIWoeA\n3Wqk+5W3aW1Z2XrVaurr2+BObGZjB2LdL5k8SnV3QLjHpLzTqK++1EjCOii1u7z/\njEZIfN0oe5MPVJPmi9gF20teI0lhZEIQerSAzL/VPD5Lr2vOOVVUJXz2C7LdnRMO\naWrydugduYiA0m4I8SAFNiMRQlK5NHAwkaaaa/hPGqBNppXd3LeedxeiisyifxQy\nhCNxtU9CHHGTPc8GJyPjtEtj7Rb8hA62aR/7NpxXSmwpF2nKdJMQ5JuVzG2Ag5SN\n5XTc911xAoGBAPKPD860xHVEg7JKdOw2BR5agEbER9lBJS3IO0BDesRbEhvJkPxP\nVpOBKvUK07/MFF0lz2ONxmdTTb/V37P6sG4z8T5TfG6sttcYfEEH4PjEGkpMzYPI\nKdMtSPCzBT/13YWg3o8JemTGSTtYsXPw72aLbepJJPJH6dA2fsYV5ODNAoGBAOft\n3Am3t2Ycsnsu9iF+JLyRM/cRd7ZPMnHvhTkxRZHEOQGEU88aKlxSoznTQ482DPXz\n/ixmGIEQMZMwovOqas+u0HXCgxu60vhjiznz2KFOVs/npwVQfOyZmrs/rerKU4JW\nIX/x/hwIv2LT22u/ESpyIf8XzL75tq9hdF/nMl+fAoGAJJe+m8GbrdFTSO+Aqi4Q\nIZ8noQV1jWoNkNWXUr+bYsoWdki3bckOV5xx/ZvPjCzemZrdqbg2yVnA7gL3B7D3\nMvj1GSEBMbUutE6GWE02/HChQrpJeusUnD5FtcJcNWUDMWiuise0RkW/wItF4ibk\nBwVb5K96Om7s8DN4dqvQ5rUCgYEA3KEhmPzzsmfKQfTCn8noGJno3Tf4sa1VR52b\nFnUQwUHxGMhREcrKUVkrfW7D7hB08+RP/tyAowZMosC5wyJyyW57UArhvhdTaocH\ngvG9OnXTj6PG9v9CV7EnyMkjIR+noW1eIOCL4w9PQSxYp37zTXWVcZ2qYGIcr2n9\n0t2UxfECgYBqLlMxurQG7Ms7rF0yiWJ+MSkkgnhw1kYaZO6Qr6rfurjR1phIYAR7\nBXOsONWr0zhICHmc7LlwN2LIzVaubYBkJ1SpQOeJhk7Jp8jqs6fjACq/BPAmzhqB\neo3+TbL/ehYOXsw3MkZtmdASBkF6cg6HX3jB7pETqxwS9eDN8k5LQg==\n-----END RSA PRIVATE KEY-----\n")

	@public_key = OpenSSL::PKey::RSA.new("-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA28B2MU4p2p/T/LzzXwb8\nrU3peyYpivKDvy45dpJg+OSjuKlSVxFsyYcC/8LhXfVMYmePOEtuqmUkCsgu3oKy\ntz77DcV01QZwYVHJXrsSGm15gTaImF5vdZvt+UUo2EgLBQJfu9R2ekYZHqF2P4pm\nsEsfdyJpk6wkd78IkJN7RJ2RX+5FkpyA29RHpW113d8bRDXWZIGGzWv80vbeQyZ5\nYRFtZW1fc1xqv2P6aHI1cmxYpqjXw956DJt9gnLsCNtTR1gqur5OW7Bb3CcEwsQV\nNdatYtmlJ14C5aAjdDEf+51uWO2Ne9NPyb/6J1lhx0826a4aUqzsCxcxz1zHa52y\nUwIDAQAB\n-----END PUBLIC KEY-----\n")

  # the way to generate keys: 
  # key_size = 512
  # @serialized_private_key = OpenSSL::PKey::RSA::generate(key_size).to_s
  # @serialized_public_key = OpenSSL::PKey::RSA.new(serialized_private_key).public_key.to_s
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
