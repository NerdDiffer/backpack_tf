#Backpack.tf
a wrapper for the [backpack.tf api](http://backpack.tf/api)

##Interfaces

* IGetPrices
  * [official doc](http://backpack.tf/api/prices)
  * implementation info
* IGetCurrencies
  * [official doc](http://backpack.tf/api/currencies)
  * implementation info
* IGetSpecialItems
  * [official doc](http://backpack.tf/api/special)
  * implementation info
* IGetUsers
  * [official doc](http://backpack.tf/api/users)
  * implementation info
* IGetUserListings
  * [official doc](http://backpack.tf/api/classifieds)
  * implementation info

---

###IGetPrices
Get pricing data for all priced items
###IGetCurrencies
Get internal currency data for a given game
###IGetSpecialItems
Get internal backpack.tf item placeholders for a given game. Read more about it [here](http://backpack.tf/api/special).
###IGetUsers
Get profile info for a list of 64-bit Steam IDs.
###IGetUserListings
Get classified listings for a given user
