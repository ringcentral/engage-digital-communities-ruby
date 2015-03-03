# encoding: utf-8

require 'spec_helper'

describe Dimelo::CCP::User do
  describe "#avatar_url" do
    before :each do
      @user = Dimelo::CCP::User.new
    end
    describe "with avatar" do
      before :each do
        @user.avatar = {
          "id" => 1076212,
          "original" => {
            "height" => 960,
            "width" => 640,
            "url" => "http://dimelo.machin.amazonaws.com/identity_avatars/c567/avata.png"
          },
          "small" => {
            "height" => 32,
            "width" => 32,
            "url" => "http://dimelo.machin.amazonaws.com/identity_avatars/c567/avatar_small.png"
          },
          "normal" => {
            "height" => 48,
            "width" => 48,
            "url" => "http://dimelo.machin.amazonaws.com/identity_avatars/c567/avatar_normal.png"
          }
        }
      end

      describe "with avatar_url" do
        before :each do
          @user.avatar_url = "http://dimelo.machin/other_avatar.png"
        end

        it "should return avatar_url" do
          expect(@user.avatar_url).to eq("http://dimelo.machin/other_avatar.png")
        end
      end

      it "should return normal avatar" do
        expect(@user.avatar_url).to eq("http://dimelo.machin.amazonaws.com/identity_avatars/c567/avatar_normal.png")
      end

      it "should return asked size avatar" do
        expect(@user.avatar_url("small")).to eq("http://dimelo.machin.amazonaws.com/identity_avatars/c567/avatar_small.png")
      end
    end

    describe "without avatar" do
      describe "with avatar_url" do
        before :each do
          @user.avatar_url = "http://dimelo.machin/other_avatar.png"
        end

        it "should return avatar_url" do
          expect(@user.avatar_url).to eq("http://dimelo.machin/other_avatar.png")
        end
      end

      it "should return nil" do
        expect(@user.avatar_url).to eq(nil)
      end
    end
  end
end
