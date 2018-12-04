# frozen_string_literal: true

require Rails.root.join('lib', 'import_properties')

namespace :properties do
  task import: :environment do
    ImportProperties.instance.perform
  end
end
