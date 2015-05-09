require 'httparty'

# namespace for classes & modules inside of the wrapper for the BackpackTF API
module BackpackTF

end

# IMPORTANT! require the Response module before any other class or module
require 'backpack_tf/version'
require 'backpack_tf/response'
require 'backpack_tf/finder'
require 'backpack_tf/client'
require 'backpack_tf/currency'
require 'backpack_tf/item'
require 'backpack_tf/item_price'
require 'backpack_tf/price'
require 'backpack_tf/special_item'
require 'backpack_tf/user'
require 'backpack_tf/user_listing'
