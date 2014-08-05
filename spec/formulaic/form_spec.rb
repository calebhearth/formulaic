require 'spec_helper'

describe Formulaic::Form do
  it 'throws an error if it does not know how to fill an attribute type' do
    expect { Formulaic::Form.new(nil, nil, { invalid: nil }) }.to raise_error(Formulaic::Form::InvalidAttributeTypeError)
  end
end
