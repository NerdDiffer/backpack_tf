# backpack_tf

Backpack.tf is a website for the in-game economies of Team Fortress 2 and
Dota 2. This gem is a wrapper for the backpack.tf [API](http://backpack.tf/api).
The goal is to capture the results and turn them into Ruby objects for use in
your application.

### Contributing

If you are interested in contributing, please see
[issues](https://github.com/NerdDiffer/backpack_tf/issues) and branch off of
the `development` branch.

### Usage

* [Register an API key](http://backpack.tf/api). You'll need to log in with your
  Steam account if you haven't already done so.
* Assign your key to an environment variable: `export BPTF_API_KEY='SECRET_KEY'`
  * **NOTE**: In the next release, you will be able to simply pass in your key
    as you are initializing your client.

### Examples

``` ruby
#
# create a new Client object
#
bp = BackpackTF::Client.new

#
# fetch some data
#
fetched_prices = bp.fetch(:prices, { :compress => 1 })
fetched_currencies = bp.fetch(:currencies, { :compress => 1 })
fetched_special_items = bp.fetch(:special_items, { :compress => 1})
fetched_users = bp.fetch(:users, { :steamids => [steam_id_64, steam_id_64] })
fetched_listings = bp.fetch(:user_listings, { :steamid => steam_id_64 })

#
# update a class with the data
# *note*: you should send a message from your Client object to the class before
# using any of those class' methods.
# This does not apply to the `Item` class and the `ItemPrice` class.
# Those are updated through the `Price` class.
#

bp.update(BackpackTF::Price, fetched_prices)
bp.update(BackpackTF::Currency, fetched_currencies)
bp.update(BackpackTF::SpecialItem, fetched_special_items)
bp.update(BackpackTF::User, fetched_users)
bp.update(BackpackTF::UserListing, fetched_listings)

#
# look at prices of a random item
#
random_key = BackpackTF::Price.items.sample
BackpackTF::Price.items[random_key]
```

## Interfaces

#### IGetPrices
* Get pricing data for all priced items
* [official doc](http://backpack.tf/api/prices)

API responses from this interface are captured in the `Price` class. The `Price`
class is not meant to be instantiated. One of the class attributes is `@@items`,
a Hash object. Information on any particular item, ie: 'Eviction Notice', is
captured in an instance of the `Item` class. Furthermore, there may be several
prices for the same item, ie: an Eviction Notice with the Unique quality has a
different price than a Eviction Notice with a Strange quality. Each price is an
instance of the `ItemPrice` class, and is stored in the `@prices` hash of that
item.

##### a visual

* `Price` class
  * `@@items` hash of `Price` class.
    * `Item` object (ie: 'Beast From Below')
    * `Item` object (ie: 'Taunt: Rock, Paper Scissors')
    * `Item` object (ie: 'Eviction Notice')
      * `@prices` hash of an `Item` object
        * `ItemPrice` object (ie: price for Unique Eviction Notice)
        * `ItemPrice` object (ie: price for Collector's Eviction Notice)
        * `ItemPrice` object (ie: price for Strange Eviction Notice)

#### IGetCurrencies

* Get internal currency data for a given game
* [official doc](http://backpack.tf/api/currencies)

API responses from this interface are captured in the `Currency` class. Similar
the `Price` class, it has a set of class methods, and attributes to describe the
API response. Unlike, the `Price` class, this one can be instantiated. There are
currently 4 currencies available through the API. Each one is an instance of
`Currency` and is held in the `@@currencies` hash of the `Currency` class.

#### IGetSpecialItems

* Get internal backpack.tf item placeholders for a given game.
* [official doc](http://backpack.tf/api/special)

This is for items that only exist on backpack.tf. They are not real game items,
but you will see them returned in a call to `IGetPrices`. The class for this
interface is `SpecialItem`.

#### IGetUsers

* Get profile info for a list of 64-bit Steam IDs.
* Does not require an API key
* [official doc](http://backpack.tf/api/users)

Get some basic information for a list of backpack.tf users. It's basically the
info that you'd see on their profile page. The response for this interface is
captured in the `User` class. You can request several users at once by sending
them in an array.

#### IGetUserListings

* Get classified listings for a given user
* [official doc](http://backpack.tf/api/classifieds)

Request all classified listings for one user. You must pass in the 64-bit
`steamid`. The response is captured in the `UserListing` class.
