require 'spec_helper'

describe Cl2009 do
  it 'has a version number' do
    expect(Cl2009::VERSION).not_to be nil
  end

  it "should send a message" do
    response = Cl2009.send_message("您的注册验证码是：1131.请完成注册", "13023106575")
    expect(response).to be true
  end

  it "should send two messages" do
    response = Cl2009.send_messages_to_mobiles("您的注册验证码是：1131.请完成注册", %w(13671778550 13298161575))
    expect(response).to be true
  end

  it "query_balance should return a number" do
    response = Cl2009.query_balance
    expect(response).to be_kind_of(Numeric)
  end

  it "successed_messsage_count should return a number" do
    response = Cl2009.successed_messsage_count
    expect(response).to be_kind_of(Numeric)
  end

  it "failed_messsage_count should return a number" do
    response = Cl2009.failed_messsage_count
    expect(response).to be_kind_of(Numeric)
  end

end
