# backpack_tf

[![Build Status](https://travis-ci.org/NerdDiffer/backpack_tf.svg?branch=master)](https://travis-ci.org/NerdDiffer/backpack_tf)

Backpack.tf is a website for the in-game economies of Team Fortress 2 and
Dota 2. This gem is a wrapper for the backpack.tf [API](http://backpack.tf/api).
The goal is to capture the results and turn them into Ruby objects for use in
your application.

### Contributing

If you are interested in contributing, please see any open
[issues](https://github.com/NerdDiffer/backpack_tf/issues), let me know, and
branch off of the `development` branch.

### Installation

###### from the command line

`$ gem install backpack_tf`

###### from your Gemfile

`gem 'backpack_tf'`

### Usage

* [Register an API key](http://backpack.tf/api)
* Assign your key to an environment variable: `export BPTF_API_KEY='SECRET_KEY'`

### Examples

``` ruby
#
# create a new Client object
#
bp = BackpackTF::Client.new(<your_api_key>)

#
# fetch some data
#
fetched_prices = bp.fetch(:prices)
fetched_currencies = bp.fetch(:currencies)
fetched_special_items = bp.fetch(:special_items)
fetched_users = bp.fetch(:users, { steamids: [array,of,64,bit,steam,ids] })
fetched_listings = bp.fetch(:user_listings, { steamid: 64_bit_steam_id })

#
# assign fetched data to the corresponding module
#
BackpackTF::Price.response = fetched_prices
BackpackTF::Currency.response = fetched_currencies
BackpackTF::SpecialItem.response = fetched_special_items
BackpackTF::User.response = fetched_users
BackpackTF::UserListing.response = fetched_listings
```

## Interfaces & Responses

#### IGetPrices

* Get pricing data for all priced items
* [official doc](http://backpack.tf/api/prices)

Information on any particular item, (ie: 'Eviction Notice'), is captured in an
instance of `BackpackTF::Item`. Furthermore, there may be several prices for the
same item. For example, an Eviction Notice with the Unique quality has a
different price than an Eviction Notice with the Strange quality.

Each price is an instance of `BackpackTF::ItemPrice`, and is stored in the
`@prices` hash of that item.

##### A visual representation of this hierarchy

* `BackpackTF::Price` module
  * `@items` hash of `BackpackTF::Price::Response`.
    * `BackpackTF::Item` object (ie: 'Beast From Below')
    * `BackpackTF::Item` object (ie: 'Taunt: Rock, Paper Scissors')
    * `BackpackTF::Item` object (ie: 'Eviction Notice')
      * `@prices` hash of a `BackpackTF::Item` object
        * `BackpackTF::ItemPrice` object (ie: price of Unique Eviction Notice)
        * `BackpackTF::ItemPrice` object (ie: price of Vintage Eviction Notice)
        * `BackpackTF::ItemPrice` object (ie: price of Strange Eviction Notice)

#### IGetCurrencies

* Get internal currency data
* [official doc](http://backpack.tf/api/currencies)

There are currently 4 currencies available through the API.
Each one is an instance of `BackpackTF::Currency` and is held in the
`@currencies` hash of the `BackpackTF::Currency::Response` class.

#### IGetSpecialItems

* Get internal backpack.tf item placeholders
* [official doc](http://backpack.tf/api/special)

This is for items that only exist on backpack.tf. They are not real game items,
but you will see them returned in a call to `IGetSpecialItems`.

#### IGetUsers

* Get profile info for a list of 64-bit Steam IDs.
* Does not require an API key
* [official doc](http://backpack.tf/api/users)

Get some basic information for a list of backpack.tf users. It's basically the
info that you'd see on their profile page.
You can request several users at once by sending an array.

#### IGetUserListings

* Get classified listings for a given user
* [official doc](http://backpack.tf/api/classifieds)

Request all classified listings for one user.
You must pass in the 64-bit `steamid`.
