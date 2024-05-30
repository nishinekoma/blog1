class User < ApplicationRecord
    #secure 安全な
    has_secure_password
end
# has_secure_password　public_method doc:https://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html#method-i-has_secure_password
# 