# encoding: utf-8
require_relative "../../spec_helper"
require "sinatra"
require "app/modules/plugins"
require "logstash/json"

describe LogStash::Api::Plugins do

  include Rack::Test::Methods

  def app()
    described_class
  end

  before(:all) do
    get "/"
  end

  let(:payload) { LogStash::Json.load(last_response.body) }

  it "respond to plugins resource" do
    expect(last_response).to be_ok
  end

  it "return valid json content type" do
    expect(last_response.content_type).to eq("application/json")
  end

  context "#schema" do
    it "return the expected schema" do
      expect(payload.keys).to include("plugins", "total")
      payload["plugins"].each do |plugin|
        expect(plugin.keys).to include("name", "version")
      end
    end
  end

  context "#values" do

    it "return totals of plugins" do
      expect(payload["total"]).to eq(payload["plugins"].count)
    end

    it "return a list of available plugins" do
      payload["plugins"].each do |plugin|
        expect(plugin).to be_available?
      end
    end

    it "return non empty version values" do
      payload["plugins"].each do |plugin|
        expect(plugin["version"]).not_to be_empty
      end
    end

  end
end
