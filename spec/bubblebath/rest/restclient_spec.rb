require 'spec_helper'

describe 'rest tests' do

  specify "simple" do
    sc = RestClient.new
    puts sc.inspect
  end
end