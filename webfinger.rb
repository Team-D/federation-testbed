require 'sinatra'
require "bundler/setup"
require 'diaspora-federation'

get '/federation//webfinger' do
#  e = DiasporaFederation::Entities::StatusMessage.new({ raw_message: 'This is a  lala text', guid: SecureRandom.hex(16), diaspora_handle: 'carolina@lala.net', created_at: DateTime.now, public: true})
#  @xml = DiasporaFederation::Salmon::Slap.generate_xml('carolina@lala.net', @pkey, e)
  @pkey = OpenSSL::PKey::RSA.new File.read('/home/sonduk/Documentos/mis_cosillas/proyectos/diaspora/wk3/carolinagc_public_wk3.asc')
  wf = DiasporaFederation::WebFinger::WebFinger.from_account({ acct_uri:    'lala@example.com',
                    alias_url:   'https://server.example/lala/lala3412',
                    hcard_url:   'https://server.example/hcard/users/user',
                    seed_url:    'https://server.example/',
                    profile_url: 'https://server.example/u/user',
                    updates_url: 'https://server.example/public/user.atom',
                    guid:        '0123456789abcdef',
                    pubkey:      @pkey
                  })


  
  @xml = wf.to_xml

  erb :index 

end

