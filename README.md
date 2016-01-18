# backpack_tf

[![Build Status](https://travis-ci.org/NerdDiffer/backpack_tf.svg?branch=master)](https://travis-ci.org/NerdDiffer/backpack_tf)

Backpack.tf is a website for the in-game economies of Team Fortress 2 and
Dota 2. This gem is a wrapper for the backpack.tf [API](http://backpack.tf/api).
The goal is to capture the results and turn them into Ruby objects for use in
your application.

See the [TODO](TODO.md) list if you are interested in contributing.

### Installation

##### from the command line

`$ gem install backpack_tf`

##### from your Gemfile

`gem 'backpack_tf'`

### Usage

* [Register an API key](http://backpack.tf/api)
* Assign your key to an environment variable: `export BPTF_API_KEY='SECRET_KEY'`

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

Responses from this interface are captured in the `BackpackTF::Price` class.
The `BackpackTF::Price` class is not meant to be instantiated. One of the class
attributes is `@items`, a Hash object.

Information on any particular item, (ie: 'Eviction Notice'), is captured in an
instance of the `BackpackTF::Item` class. Furthermore, there may be several
prices for the same item. For example, an Eviction Notice with the Unique
quality has a different price than an Eviction Notice with the Strange quality.

Each price is an instance of the `BackpackTF::ItemPrice` class, and is stored in
the `@prices` hash of that item.

##### A visual representation of this hierarchy

* `BackpackTF::Price` class
  * `@items` hash of `BackpackTF::Price` class.
    * `BackpackTF::Item` object (ie: 'Beast From Below')
    * `BackpackTF::Item` object (ie: 'Taunt: Rock, Paper Scissors')
    * `BackpackTF::Item` object (ie: 'Eviction Notice')
      * `@prices` hash of an `BackpackTF::Item` object
        * `BackpackTF::ItemPrice` object (ie: price of Unique Eviction Notice)
        * `BackpackTF::ItemPrice` object (ie: price of Vintage Eviction Notice)
        * `BackpackTF::ItemPrice` object (ie: price of Strange Eviction Notice)

#### IGetCurrencies

* Get internal currency data
* [official doc](http://backpack.tf/api/currencies)

API responses from this interface are captured in the `Currency` class.
Similar the `BackpackTF::Price` class, it has a set of class methods, and
attributes to describe the API response.
Unlike, the `Price` class, this one can be instantiated. There are currently 4
currencies available through the API.
Each one is an instance of `BackpackTF::Currency` and is held in the
`@currencies` hash of the `BackpackTF::Currency` class.

#### IGetSpecialItems

* Get internal backpack.tf item placeholders
* [official doc](http://backpack.tf/api/special)

This is for items that only exist on backpack.tf. They are not real game items,
but you will see them returned in a call to `IGetSpecialItems`.
The class for this interface is `BackpackTF::SpecialItem`.

#### IGetUsers

* Get profile info for a list of 64-bit Steam IDs.
* Does not require an API key
* [official doc](http://backpack.tf/api/users)

Get some basic information for a list of backpack.tf users. It's basically the
info that you'd see on their profile page.
The response for this interface is captured in the `BackpackTF::User` class.
You can request several users at once by sending them in an array.

#### IGetUserListings

* Get classified listings for a given user
* [official doc](http://backpack.tf/api/classifieds)

Request all classified listings for one user.
You must pass in the 64-bit `steamid`.
The response is captured in the `BackpackTF::UserListing` class.
