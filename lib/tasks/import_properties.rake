# frozen_string_literal: true

require Rails.root.join('lib', 'import_properties')

namespace :properties do
  task import: :environment do
    ImportProperties.new('Southwark').perform
    ImportProperties.new('Lambeth').perform
    ImportProperties.new('City of London').perform
    ImportProperties.new('Tower Hamlets').perform
    ImportProperties.new('Lewisham').perform
  end
end
