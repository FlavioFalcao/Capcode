$:.unshift( "../lib" )
require 'capcode'
require 'rubygems'
require 'fileutils'

module Capcode
  class Index < Route '/'
    def get
      render :markaby => :index
    end
    
    def post
      FileUtils.cp( 
        params["upfile"][:tempfile].path, 
        ::File.join( static[:path], params["upfile"][:filename] )
      )
      render :static => params["upfile"][:filename]
    end
  end
end

module Capcode::Views
  def index
    html do
      body do
        h1 "Upload..."
        form :method => "POST", :enctype => 'multipart/form-data' do
          input :type => "file", :name => "upfile"; br
          input :type => "submit", :value => "Upload"
        end
      end
    end
  end
end

Capcode.run( :static => "data" ) {
  FileUtils.mkdir_p 'data'
}