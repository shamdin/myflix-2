require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe '.create' do
      it "makes a successful charge", :vcr do
        token = Stripe::Token.create(
          card: {
            number: "4242424242424242",
            exp_month: 6,
            exp_year: 2018,
            cvc: 314
          }
        ).id

        response = StripeWrapper::Charge.create(
          amount: 999,
          source: token,
          description: "Valid example charge for valid@example.com"
        )

        expect(response).to be_successful
      end

      it "makes a card declined charge", :vcr do
        token = Stripe::Token.create(
          card: {
            number: "4000000000000002",
            exp_month: 6,
            exp_year: 2018,
            cvc: 314
          }
        ).id

        response = StripeWrapper::Charge.create(
          amount: 999,
          source: token,
          description: "Invalid example charge for invalid@example.com"
        )

        expect(response).not_to be_successful
      end

      it "returns the error message for declined charges", :vcr do
        token = Stripe::Token.create(
          card: {
            number: "4000000000000002",
            exp_month: 6,
            exp_year: 2018,
            cvc: 314
          }
        ).id

        response = StripeWrapper::Charge.create(
          amount: 999,
          source: token,
          description: "Invalid example charge"
        )

        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end
end