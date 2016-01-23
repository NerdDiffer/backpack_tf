require 'backpack_tf/response/user'
require 'backpack_tf/interface/user'

module BackpackTF
  # Ruby representations of a JSON response to IGetUsers
  class User
    include Helpers

    attr_reader :steamid
    attr_reader :success
    attr_reader :backpack_value
    attr_reader :backpack_update
    attr_reader :name
    attr_reader :backpack_tf_reputation
    attr_reader :backpack_tf_group
    attr_reader :backpack_tf_banned
    attr_reader :backpack_tf_trust
    attr_reader :steamrep_scammer
    attr_reader :ban_economy
    attr_reader :ban_community
    attr_reader :ban_vac
    attr_reader :notifications

    def initialize attr
      attr = hash_keys_to_sym(attr)

      @steamid                = attr[:steamid]
      @success                = attr[:success]
      @backpack_value         = attr[:backpack_value]
      @backpack_update        = attr[:backpack_update]
      @name                   = attr[:name]
      @backpack_tf_reputation = attr[:backpack_tf_reputation]
      @backpack_tf_group      = attr[:backpack_tf_group]
      @backpack_tf_banned     = attr[:backpack_tf_banned]
      @backpack_tf_trust      = attr[:backpack_tf_trust]
      @steamrep_scammer       = attr[:steamrep_scammer]
      @ban_economy            = attr[:ban_economy]
      @ban_community          = attr[:ban_community]
      @ban_vac                = attr[:ban_vac]
      @notifications          = attr[:notifications]
    end
  end
end
