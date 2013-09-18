    xml.instruct! :xml, :version => '1.0'
    xml.rss :version => "2.0" do
      xml.channel do
        xml.author "The author"
        xml.title "Liftoff News"
        xml.description "Liftoff to Space Exploration."
        xml.link "http://liftoff.msfc.nasa.gov/"
	        
        @post_title.each do |post|
          xml.entry do
            xml.title post
            xml.link "http://liftoff.msfc.nasa.gov/posts/"
	    xml.published Time.now
            xml.guid "http://liftoff.msfc.nasa.gov/posts/"
          end
        end
      end
    end
