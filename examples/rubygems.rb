require 'restful_mapper'
require 'pp'

class Dependency
  include StructureMapper::Hash
  attribute name: String
  attribute requirements: String
end

class RubyGemInfo
  include StructureMapper::Hash
  attribute name: String
  attribute downloads: Fixnum
  attribute version: String
  attribute version_downloads: Fixnum
  attribute platform: String
  attribute authors: String
  attribute info: String
  attribute licenses: []
  attribute project_uri: String
  attribute gem_uri: String
  attribute homepage_uri: String
  attribute wiki_uri: String
  attribute documentation_uri: String
  attribute mailing_list_uri: String
  attribute source_code_uri: String
  attribute bug_tracker_uri: String
  attribute dependencies: {String => [Dependency]}
end

class RubyGemsService < RestfulMapper::Service
  
  base_url 'https://rubygems.org/api/v1'

  get :gems do
    path 'gems/rails.json', {}
    responses 200 => RubyGemInfo
  end
end


pp RubyGemsService.gems({})