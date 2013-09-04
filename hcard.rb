require 'sinatra'
require "bundler/setup"
require 'diaspora-federation'

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
