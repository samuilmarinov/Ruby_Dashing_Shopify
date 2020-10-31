require 'json'
require 'net/http'
require 'net/https'
require 'shopify_api'
	

login = 'f377251f6fbf4630ab441823f874097a'
secret = '2444fcf48b9f798f117ca4f427b20054'
shop = 'morale-patch-armory'
shop_url = "https://" + login + ":" + secret + "@" + shop + ".myshopify.com/admin"
	
	
SCHEDULER.every '10s' do
    # make the GET request
    resp = Net::HTTP.get(URI("http://graph.facebook.com/fql?q=SELECT%20share_count,%20like_count,%20comment_count,%20total_count%20FROM%20link_stat%20WHERE%20url=%22http://www.google.fr%22&format=json"))

    # parse the JSON into a ruby hash
    json = JSON.parse(resp)

    # pull the like_count value out of the response
	current_valuation = json["data"][0]["like_count"]
	
	ShopifyAPI::Base.site = shop_url
	shop = ShopifyAPI::Shop.current

	orderCount = ShopifyAPI::Order.count()

	send_event('valuation', { current: current_valuation})
	send_event('synergy',   { value: orderCount })
	send_event('valuation', { current: current_valuation})
end