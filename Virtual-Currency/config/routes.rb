Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resource :coupons do
        get :all
        get '/:code', to: 'coupons#show_by_code'
        get 'active/:active', to: 'coupons#show_by_active'
        patch 'redeem/:code', to: 'coupons#redeem'
      end
      resource :coupon_details do
        get '/:code', to: 'coupon_details#show_by_code'
      end
      resource :user_wallets do
        get :all
        get '/:user_id', to: 'user_wallets#show_by_user_id'
        get 'active/:active', to: 'user_wallets#show_by_active'
        patch 'toggle_off', to: 'user_wallets#toggle_off'
        patch 'recharge', to: 'user_wallets#recharge'
        patch 'withdraw', to: 'user_wallets#withdraw'
        post 'add_coupons', to: 'user_wallets#add_coupons'
        post 'remove_coupons', to: 'user_wallets#remove_coupons'
        post 'payment', to: 'user_wallets#payment'
      end
      resource :user_wallet_details do
        get '/:user_id', to: 'user_wallet_details#show_by_user_id'
      end
      
      resource :currency_packages
    end
  end
end
