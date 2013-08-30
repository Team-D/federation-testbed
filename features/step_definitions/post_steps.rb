Given(/^a public message$/) do
  e = DiasporaFederation::Entities::StatusMessage.new({ raw_message: 'This is a  lala text', guid: SecureRandom.hex(16), diaspora_handle: 'carolina@wk3.org', created_at: DateTime.now, public: true})
  @pkey = OpenSSL::PKey::RSA.new File.read('/home/sonduk/Documentos/mis_cosillas/proyectos/diaspora/wk3/carolina_wk3.asc')
  @xml = DiasporaFederation::Salmon::Slap.generate_xml('carolina@wk3.org', @pkey, e)
puts "PUBLIC XML" + @xml
end

Given(/^a private message$/) do
#  @pkey = OpenSSL::PKey::RSA.new @private_key
  @pkey = OpenSSL::PKey::RSA.new File.read('/home/sonduk/Documentos/mis_cosillas/proyectos/diaspora/wk3/carolina_wk3.asc')
  @pubkey= OpenSSL::PKey::RSA.new File.read('/home/sonduk/Documentos/mis_cosillas/proyectos/diaspora/wk3/carolina_wk3_public.asc')
  e = DiasporaFederation::Entities::StatusMessage.new({ raw_message: 'text', guid: SecureRandom.hex(16), diaspora_handle: 'carolina@wk3.org', created_at: DateTime.now,  public: false})
  @xml = DiasporaFederation::Salmon::EncryptedSlap.generate_xml('carolina@wk3.org', @pkey, e, @pubkey)

puts "PRIVATE XML" + @xml
end

When(/^I send a public message$/) do
  RestClient.post "https://wk3.org/receive/public", {:xml => @xml}
end

When(/^I send a private message$/) do
  RestClient.post "https://wk3.org/receive/users/#{@guid}", {:xml => @xml}
end
