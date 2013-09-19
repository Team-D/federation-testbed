Given(/^a public message$/) do
  # MK: I propose to use more meaningful variable names
  e = DiasporaFederation::Entities::StatusMessage.new({
    raw_message: 'Writing another test message from outside on september 18th', guid: SecureRandom.hex(16),
    diaspora_handle: 'carolinagc@wk3.org', created_at: DateTime.now, public: true })
  # MK: This will not work on any other machine than your own
  @pkey = OpenSSL::PKey::RSA.new File.read('/home/sonduk/Documentos/mis_cosillas/proyectos/diaspora/wk3/carolinagc_private_wk3.asc')
#  @pubkey = OpenSSL::PKey::RSA.new File.read('/home/sonduk/Documentos/mis_cosillas/proyectos/diaspora/wk3/carolinagc_public_wk3.asc')
  @xml = DiasporaFederation::Salmon::Slap.generate_xml('carolinagc@wk3.org', @pkey, e)


  puts "PUBLIC XML" + @xml

end

Given(/^a private message$/) do
  @pkey = OpenSSL::PKey::RSA.new File.read('/home/sonduk/Documentos/mis_cosillas/proyectos/diaspora/wk3/carolinagc_private_wk3.asc')
  @pubkey= OpenSSL::PKey::RSA.new File.read('/home/sonduk/Documentos/mis_cosillas/proyectos/diaspora/wk3/carolinagc_public_wk3.asc')
  e = DiasporaFederation::Entities::StatusMessage.new({ raw_message: 'text', guid: SecureRandom.hex(16), diaspora_handle: 'carolinagc@wk3.org', created_at: DateTime.now,  public: false})
  @xml = DiasporaFederation::Salmon::EncryptedSlap.generate_xml('carolinagc@wk3.org', @pkey, e, @pubkey)

  puts "PRIVATE XML" + @xml
end

When(/^I send a public message$/) do
  # MK: Just speculating because I cannot test it myself right now, but have you tried it like this?
  #   RestClient.post("https://wk3.org/receive/public", @xml)
  RestClient.post "https://wk3.org/receive/public", {:xml => @xml}
end

When(/^I send a private message$/) do
  RestClient.post "https://wk3.org/receive/users/#{@guid}", {:xml => @xml}
end
