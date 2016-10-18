class Payment < ApplicationRecord
  validates :amount, presence: true, numericality: {greater_than_or_equal_to: 0}

  enum status: [:not_registered, :registered, :paid, :delayed, :rejected, :canceled]

  def register!(billnumber)
    self.billnumber = billnumber
    registered!
  end

  def check_status!
    start_time = created_at - 1.day

    order_status =
      Assist.order_status(
        id,
        "StartDay"   => start_time.day,
        "StartMonth" => start_time.month,
        "StartYear"  => start_time.year
      )
    raise "Wrong billnumber" if billnumber != order_status.billnumber
    update_status! order_status.status
  end

  def confirm!
    result = Assist.confirm_order(billnumber).result
    raise "Wrong order ID" if id != result[:ordernumber].to_i

    update_status! result[:orderstate]
  end

  def cancel!
    result = Assist.cancel_order(billnumber).result
    raise "Wrong order ID" if id != result[:ordernumber].to_i

    update_status! result[:orderstate]
  end

  private

  def update_status!(status)
    case status
    when "Approved"                    then paid!     unless paid?
    when "Delayed"                     then delayed!  unless delayed?
    when "Declined", "Timeout"         then rejected! unless rejected?
    when "Canceled", "PartialCanceled" then canceled! unless canceled?
    end
  end
end
