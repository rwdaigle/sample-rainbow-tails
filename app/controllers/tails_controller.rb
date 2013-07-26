
class TailsController < ApplicationController

  def buy_tail
    @credit_card = CreditCard.new
  end

  def transparent_redirect_complete
    return if error_saving_card

    @payment_method_token = params[:token]
    @credit_card = CreditCard.new(SpreedlyCore.get_payment_method(@payment_method_token))
    return render(:action => :buy_tail) unless @credit_card.valid?

    response = SpreedlyCore.purchase(params[:token], (( 0.02 * @credit_card.how_many.to_i ) * 100).to_i )
    return redirect_to(successful_purchase_url) if response.code == 200

    set_flash_error(response)
    render(:action => :buy_tail)
  end

  def successful_purchase

  end


  private
  def set_flash_error(response)
    if response["errors"]
      flash.now[:error] = response["errors"]["error"]["__content__"]
    else
      flash.now[:error] = "#{response['transaction']['response']['message']} #{response['transaction']['response']['error_detail']}"
    end
  end

  def error_saving_card
    return false if params[:error].blank?

    @credit_card = CreditCard.new
    flash.now[:error] = params[:error]
    render(:action => :buy_tail)
    true
  end

end
