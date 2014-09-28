require 'paypal-sdk-merchant'
class PaypalInterface
  attr_reader :api, :express_checkout_response

  def initialize(request)
    @api = PayPal::SDK::Merchant::API.new
    @request = request
  end

  def express_checkout
    total = @request.price.round(2)+(@request.price*SysProperty.get_maker_benchmark.to_f).round(2)
    puts total
    @set_express_checkout = @api.build_set_express_checkout({
        SetExpressCheckoutRequestDetails: {
            ReturnURL: Rails.application.routes.url_helpers.paid_request_url(host: HOST_WO_HTTP, id:@request.id),
            CancelURL: Rails.application.routes.url_helpers.revoked_request_url(host: HOST_WO_HTTP, id:@request.id),
            PaymentDetails: [{
               NotifyURL: Rails.application.routes.url_helpers.ipn_request_url(host: HOST_WO_HTTP, id:@request.id),
               OrderTotal: {
                   currencyID:  @request.user.country.currency.currency_code,
                   value: total
               },
               ItemTotal: {
                   currencyID:  @request.user.country.currency.currency_code,
                   value:  total
               },
               ShippingTotal: {
                   currencyID:  @request.user.country.currency.currency_code,
                   value: "0"
               },
               TaxTotal: {
                   currencyID:  @request.user.country.currency.currency_code,
                   value: "0"
               },
               PaymentDetailsItem: [{
                  Name: @request.title,
                  Quantity: 1,
                  Amount: {
                      currencyID:  @request.user.country.currency.currency_code,
                      value: total
                  },
                  ItemCategory: "Physical"
               }],
               PaymentAction: "Sale"
            }]
        }
    })

    # Make API call & get response
    @express_checkout_response = @api.set_express_checkout(@set_express_checkout)
    puts  @express_checkout_response.inspect
    # Access Response
    if @express_checkout_response.success?
      @request.payment_token=@express_checkout_response.Token
      @request.save
    else
      puts  @express_checkout_response.Errors.inspect
      @express_checkout_response.Errors
    end
  end

  def do_express_checkout
    @do_express_checkout_payment = @api.build_do_express_checkout_payment({
        DoExpressCheckoutPaymentRequestDetails: {
            PaymentAction: "Sale",
            Token: @request.payment_token,
            PayerID:@request.payerID,
            PaymentDetails: [{
               OrderTotal: {
                   currencyID: @request.user.country.currency.currency_code,
                   value: @request.price
               },
               NotifyURL: Rails.application.routes.url_helpers.ipn_request_url(host: HOST_WO_HTTP, id:@request.id)
            }]
        }
    })
    # Make API call & get response
    @do_express_checkout_payment_response = @api.do_express_checkout_payment(@do_express_checkout_payment)
    # Access Response
    if @do_express_checkout_payment_response.success?
      details = @do_express_checkout_payment_response.DoExpressCheckoutPaymentResponseDetails
      #@request.set_payment_details(prepare_express_checkout_response(details))
      return true,details
    else
      errors = @do_express_checkout_payment_response.Errors # => Array
      return false,errors[0]
    end
  end



end