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
	@user = "deleted_soon"
	@guid = '20bae424196dac5a'
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
 	@private_key = OpenSSL::PKey::RSA.new("-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEAvFa9tnvEzbt+lB02CM01f1xfTXSZptwDx81QyWRDMP0J4Q2G\nSE4ErMTvhnSVFV1HlrMSHFk9C1j8NLTQV9pfsXN38yp3tGHcgqDDkj9STGR9eOlg\nDjVXXiAZ1Tu9mbDWdzEbXIrjPtdKpyIUAdz8i5R52ss1RrZTfds7+G4rdsl02h4v\nBftZSgW5Ri88GuaBeQqJhLf7YJJnzbAfsqxlEHwmvEj3xADrmp4Sd4IUDiZjsSHD\nfWfCQBmRxYM/tORhzheL0YinD284D/gXKIG/Hz+nTELgKrNPCbkhGvQcU/J2/dWO\nT5iBCVnX/Z1gXTMEP9iO8kb3F18N5lHS7OBzDQIDAQABAoIBAE60ROVMRYrfzl6g\n8mKtNqz5cg4RKuCS0rWdNCRk1LtVEtrMZxAyIjv8tEfQ0jgyWec8/9V+6Uajsglo\ngiQkapbiNP8WAR4NQzQHcJLeCUtJNzHe/LgTTGZWLdVw+KOQRZ9bkx6SH7K0D0tW\nr1uz+Ilvy5hGEQZyzOMsSZxglaM2hoSUAnWXoPi699hmJ5P6Nn0K9D38FBGv/3Yh\nm7y2J6DPANIJAiEE7j+J6GZ4V1ejnZhkGM/fgea5gsSxX9f37C2jeE5ylikNZFiv\nMnjqosb0d6hD/SVEoLFAnsxOco8NV7Xok7EoE3bZQTe/fzQ5H/ztw/YZCgc1Wn9d\nJWdA/XUCgYEA7uwpUHKOJBr7Af2SNOQGyBgThNkuD+VLGD9FpD3xRr7utgAPFiIm\nMA6HHk6WugaMv+pesPjq4OwzMrIT4PPHimVkAzhdkQFpFjaiTOCapD/lxzypGnif\nPe81w9O0FtlOj5YcJpqHsVM3fgCvnEr6jY57MYu+L84l0MJhyFjq0f8CgYEAycz+\nB5ZLorbjwAxU1At+fxXahj7mK3oLR5wXN0gbYpo2zUZwmaDQ+Kgj2pdE3XcPZbpG\n0GmLmseslwJr11MV3ejb2/XIyp+zGDrL4pCKih7y/a0jLTnj7XQMyBCaMEuYXw9o\nB41Sf/Mvcl3DH4BvEdxf9ugNoiCdTnuOHBdo4vMCgYEAy0D7MKYTyCFv0lSusfIe\n1tCsokLETd+Jz/nbvAq6HK5Hk2tfajvo8s8ZIa5Hyb/Ss12l6rYH0wr9zy3xfVjG\nMzVoLNkhuD9T8ALQdchJplt5ldJEJfHhvqWmvo52UU3S6JISJsElmLQrrDTXMIYU\nuqIwqYixZifgwcTrvK3wLm8CgYBLWpihDKZBpDl3RSOH6qLZobdv2ZzpLzF3E/o3\nUl2nfB5qmJsDQuHFeEOrJEE60XKWcfBvcnoG2fjAis7qIMRRkNpIUIch4nBl486u\nU3roCJaD01sHUE6kJGmBa3GoBxJmrMITz9m2nYBiHFD4OmU/LiNHd29f0v3qiIiQ\nRM2NsQKBgQDE1VBubwhJkyP/QzrZf+tr7jwF4w8xHzmW/DWanrGFaWZZpYnO0ge6\nVnxvhp8hzeeEtI/8j0+XE8EXtVoeZwFjG425puyvFFk6HBoo4E8GSarA7MTmvBfw\n/FUlBOpzIqwcnYnebVWmIKEBlVMrysUnZq0gxm14Tlbhoza1pEriSA==\n-----END RSA PRIVATE KEY-----\n")

	@public_key = OpenSSL::PKey::RSA.new("-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvFa9tnvEzbt+lB02CM01\nf1xfTXSZptwDx81QyWRDMP0J4Q2GSE4ErMTvhnSVFV1HlrMSHFk9C1j8NLTQV9pf\nsXN38yp3tGHcgqDDkj9STGR9eOlgDjVXXiAZ1Tu9mbDWdzEbXIrjPtdKpyIUAdz8\ni5R52ss1RrZTfds7+G4rdsl02h4vBftZSgW5Ri88GuaBeQqJhLf7YJJnzbAfsqxl\nEHwmvEj3xADrmp4Sd4IUDiZjsSHDfWfCQBmRxYM/tORhzheL0YinD284D/gXKIG/\nHz+nTELgKrNPCbkhGvQcU/J2/dWOT5iBCVnX/Z1gXTMEP9iO8kb3F18N5lHS7OBz\nDQIDAQAB\n-----END PUBLIC KEY-----\n")

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
