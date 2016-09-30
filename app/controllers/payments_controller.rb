class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:success, :fail]

  before_action :find_payment, only: [:status, :cancel]

  def index
    @payments = Payment.order(:id)
  end

  def create
    payment = Payment.create!(payment_params)
    redirect_to Assist.payment_url(payment.id, payment.amount)
  end

  def status
    @payment.check_status!
    redirect_to root_url, notice: "Status updated"
  end

  def cancel
    @payment.cancel!
    redirect_to root_url, notice: "Payment canceled"
  end

  def success
    callback
    redirect_to root_url, notice: "Successful payment: #{@payment.attributes}"
  end

  def fail
    callback
    redirect_to root_url, notice: "Failed payment: #{@payment.attributes}"
  end

  private

  def payment_params
    params.require(:payment).permit(:amount)
  end

  def callback
    @payment = Payment.find(params[:ordernumber])
    @payment.register!(params[:billnumber])
    @payment.check_status!
  end

  def find_payment
    @payment = Payment.find(params[:id])
  end
end
