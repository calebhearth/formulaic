require 'spec_helper'

describe Formulaic::Form do
  it 'throws an error if it does not know how to fill an attribute type' do
    expect do
      Formulaic::Form.new(nil, nil, { invalid: nil })
    end.to raise_error(Formulaic::Form::InvalidAttributeTypeError)
  end

  it "doesn't throw error for Rack::Multipart::UploadedFile object" do
    rack_multipart_uploaded_file = Rack::Multipart::UploadedFile.new(__FILE__)

    expect do
      Formulaic::Form.new(:user, :new, { avatar: rack_multipart_uploaded_file })
    end.not_to raise_error
  end
end
