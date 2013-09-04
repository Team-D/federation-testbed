require 'sinatra'
require "bundler/setup"
require 'diaspora-federation'

get '/federation/host-meta' do
 hostmeta = DiasporaFederation::WebFinger::HostMeta.from_base_url('http://lala.com')
  hostmeta.to_xml

end

