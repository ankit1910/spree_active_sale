require 'spec_helper'

describe Spree::HomeController do
  stub_authorization!
  let(:product) { create(:product) }
  let(:taxon) { create(:taxon) }

  # This should return the minimal set of attributes required to create a valid
  # Spree::ActiveSaleEvent. As you add validations to Spree::ActiveSaleEvent, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {
      "name"=>"Dummy Event", 
      "description"=>"Dummy event description data", 
      "start_date"=> Time.now.strftime("%Y/%m/%d %H:%M:%S %z"), 
      "end_date"=> (Time.now+2.months).strftime("%Y/%m/%d %H:%M:%S %z"), 
      "eventable_type"=> product.class.to_s, 
      "eventable_name"=> product.name, 
      "is_active"=>"1", 
      "is_hidden"=>"0", 
      "is_permanent"=>"0"
    }
  end

  def active_sale_valid_attributes
    { 
      "name" => "Dummy Sale",
      "description"=>"Dummy event description data", 
      "start_date"=> Time.zone.now.strftime("%Y/%m/%d %H:%M:%S %z"), 
      "end_date"=> (Time.zone.now+2.months).strftime("%Y/%m/%d %H:%M:%S %z"), 
      "permalink" => taxon.permalink,
      "eventable_type"=> taxon.class.to_s,
      "eventable_id" => taxon.id,
      "is_active"=>"1", 
      "is_hidden"=>"0", 
      "is_permanent"=>"0"
     }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Spree::HomeController. Be sure to keep this updated too.
  def valid_session
    { "warden.user.user.key" => session["warden.user.user.key"] }
  end

  before do
    @active_sale = Spree::ActiveSale.create! active_sale_valid_attributes
    @active_sale.active_sale_events.create! valid_attributes
  end

  describe "GET index" do
    it "assigns all active_sale_event_events as @active_sale_event_events" do
      spree_get :index, {}, valid_session
      @active_sale.active_sale_events.each{ |event| event.live_and_active?.should be_true }
      assigns(:sale_events).should eq(Spree::ActiveSaleEvent.live_active.non_parents.to_a)
    end
  end

end
