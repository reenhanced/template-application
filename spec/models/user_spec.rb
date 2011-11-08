require 'spec_helper'

describe User do
  subject { Factory(:user) }

  it { should persist_attribute(:first_name) }
  it { should persist_attribute(:last_name) }

  it { should validate_uniqueness_of(:email).with_message(/is already taken/) }
end

describe ".find_for_facebook_oauth" do
  subject { User }
  let(:omniauth_params) do
    { "extra" => { "user_hash" => { "email" => "foo@example.com" } } }
  end

  it "calls find_by_email with params" do
    subject.stubs(:find_by_email)
    subject.find_for_facebook_oauth(omniauth_params)
    subject.should have_received(:find_by_email).
      with(omniauth_params["extra"]["user_hash"]["email"])
  end
end
