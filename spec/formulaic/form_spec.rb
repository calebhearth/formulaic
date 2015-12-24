require 'spec_helper'

describe Formulaic::Form do
  context "attribute is invalid type" do
    it "throws an error" do
      expect { Formulaic::Form.new(nil, nil, { invalid: nil }) }.to raise_error(Formulaic::Form::InvalidAttributeTypeError)
    end
  end
end
