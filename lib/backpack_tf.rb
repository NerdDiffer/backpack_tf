require 'httparty'

# namespace for classes & modules inside of the wrapper for the BackpackTF API
module BackpackTF

end

# IMPORTANT! require the Response module before any other class or module
require_relative 'backpack_tf/version'
require_relative 'backpack_tf/response'
require_relative 'backpack_tf/client'
require_relative 'backpack_tf/currency'
require_relative 'backpack_tf/item'
require_relative 'backpack_tf/item_price'
require_relative 'backpack_tf/price'
require_relative 'backpack_tf/special_item'
require_relative 'backpack_tf/user'
require_relative 'backpack_tf/user_listing'
