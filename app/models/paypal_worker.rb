class PaypalWorker
  # To change this template use File | Settings | File Templates.
  #include Sidekiq::Worker

  def self.perform(requezs)
    @request = Request.find(id)
    @paypal = PaypalInterface.new(@request)
    @paypal.do_express_checkout
  end
end