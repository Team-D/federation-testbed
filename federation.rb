require 'sinatra'
require "bundler/setup"
require 'diaspora-federation'
require 'open-uri'


get '/federation/host-meta' do
  hostmeta = DiasporaFederation::WebFinger::HostMeta.from_base_url('http://lala.com')
  hostmeta.to_xml

end

get '/' do
  @doc = Nokogiri::XML(open('https://joindiaspora.com/public/carolinagc.atom'))
  @post_title = @doc.xpath('//xmlns:title')

  @post_titles = ""
  for i in 1..(@post_title.length - 1)
    @p = @post_title[i].to_html
    @post_titles << @p.gsub!("title", "div class=post_titles") << "<a href=''>read more </a>"
  end
  @post_bodies = @doc.xpath('//xmlns:content').to_html           
  erb :index

end

get '/federation/webfinger' do
  @pkey = OpenSSL::PKey::RSA.new File.read('/home/sonduk/Documentos/mis_cosillas/proyectos/diaspora/wk3/carolinagc_public_wk3.asc')
  wf = DiasporaFederation::WebFinger::WebFinger.from_account({ acct_uri:    'lala@example.com',
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






