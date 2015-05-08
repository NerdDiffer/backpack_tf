#backpack_tf
Backpack.tf is a website for the in-game economies of Team Fortress 2 and Dota 2. This gem is a wrapper for the backpack.tf [API](http://backpack.tf/api). The goal is to capture the results and turn them into Ruby objects for use in your application.

It is in the very early stages of development. See the [TODO](TODO.md) list if you are interested in contributing.

###Installation
#####install any dependencies
`bundle install`

######Install it as a gem:  
`gem install backpack_tf`  

######Or add it to your project's Gemfile:  
`gem 'backpack_tf'`

###Usage
* [Register an API key](http://backpack.tf/api). You'll need to log in with your Steam account if you haven't already done so.  
* Assign your key to an environment variable through your terminal:  
  `export BPTF_API_KEY='SECRET_KEY'`
* Load the gem into your project:  
  `require 'backpack_tf'`

###Examples

#####create a new Client object  
`bp = BackpackTF::Client.new`

#####get the latest prices or currencies
`fetched_prices = bp.fetch(:prices, { :compress => 1 })`  
`fetched_currencies = bp.fetch(:currencies, { :compress => 1 })`

#####update the Prices or Currencies object with the data
*note*: you should send a message from your Client object to the class before using any of those class' methods. This only applies to `Prices` and `Currencies` class. The `Item` and the `ItemPrice` class are updated through the `Prices` class.

`bp.update(BackpackTF::Prices, fetched_prices)`  
`bp.update(BackpackTF::Currencies, fetched_currencies)`

#####look at prices of a random item
```
random_key = BackpackTF::Prices.items.sample
BackpackTF::Prices.items[random_key]
```

##Interfaces

####IGetPrices
* Get pricing data for all priced items
* [official doc](http://backpack.tf/api/prices)

API responses from this interface are captured in the `Prices` class. The `Prices` class is not meant to be instantiated. One of the class attributes is `@@items`, a Hash object. Information on any particular item, ie: 'Eviction Notice', is captured in an instance of the `Item` class. Furthermore, there may be several prices for the same item, ie: an Eviction Notice with the Unique quality has a different price than a Eviction Notice with a Strange quality.  Each price is an instance of the `ItemPrice` class, and is stored in the `@prices` hash of that item.

######a visual
* `Prices` class
  * `@@items` hash of `Price` class.
    * `Item` object (ie: 'Beast From Below')
    * `Item` object (ie: 'Taunt: Rock, Paper Scissors')
    * `Item` object (ie: 'Eviction Notice')
      * `@prices` hash of an `Item` object
        * `ItemPrice` object (ie: price for Unique Eviction Notice)
        * `ItemPrice` object (ie: price for Collector's Eviction Notice)
        * `ItemPrice` object (ie: price for Strange Eviction Notice)

####IGetCurrencies
* Get internal currency data for a given game
* [official doc](http://backpack.tf/api/currencies)

API responses from this interface are captured in the `Currencies` class. Similar the `Prices` class, it has a set of class methods, and attributes to describe the API response. Unlike, the `Prices` class, this one can be instantiated. There are currently 4 currencies available through the API. Each one is an instance of `Currencies` and is held in the `@@currencies` hash of the `Currencies` class.

####IGetSpecialItems *(not yet implemented)*
* Get internal backpack.tf item placeholders for a given game.
* [official doc](http://backpack.tf/api/special)

####IGetUsers *(not yet implemented)*
* Get profile info for a list of 64-bit Steam IDs.
* Does not require an API key
* [official doc](http://backpack.tf/api/users)

####IGetUserListings *(not yet implemented)*
  * Get classified listings for a given user
  * [official doc](http://backpack.tf/api/classifieds)
