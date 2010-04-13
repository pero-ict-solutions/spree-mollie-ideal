require File.dirname(__FILE__) + '/../spec_helper'

describe IdealPayment do
  before(:each) do
    @ideal_payment = IdealPayment.new
  end

  it "should be valid" do
    @ideal_payment.should be_valid
  end
end
