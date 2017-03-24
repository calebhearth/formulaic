require 'spec_helper'

describe Formulaic::Form do
  context "attribute is invalid type" do
    it "throws an error" do
      invalid_attribute_error = Formulaic::Form::InvalidAttributeTypeError

      expect{ formulaic_request }.to raise_error(invalid_attribute_error)
    end

    def formulaic_request
      Formulaic::Form.new(nil, nil, { invalid: nil })
    end
  end
end
