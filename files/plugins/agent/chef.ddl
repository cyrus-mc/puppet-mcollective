metadata :name          => "chef-client agent",
         :description   => "Agent used to run chef-client on chef nodes",
         :author        => "Matthew Ceroni",
         :license       => "",
         :url           => "http://8x8.com",
         :version       => "0.1",
         :timeout       => 30

action "run", :description => "Run chef-client on chef node" do
        display :always

        input :debug,
                :prompt         => 'DEBUG',
                :description    => 'Run chef-client in debug mode (-l option)',
                :type           => :boolean,
                :optional       => true
end
