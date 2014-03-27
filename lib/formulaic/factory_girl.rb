require 'formulaic/dsl'
require 'factory_girl'
require 'active_support/concern'

module Formulaic
  module FactoryGirl
    include ::FactoryGirl::Syntax::Methods
    def fill_with_factory(model_name, *attribute_whitelist, factory_arguments: [])
      attributes = attributes_for(model_name, *factory_arguments)

      if attribute_whitelist.any?
        attributes = attributes.slice(*attribute_whitelist)
      end

      fill_form(model_name, attributes)
    end
  end

  Formulaic::Dsl.send(:include, Formulaic::FactoryGirl)
end
