class Client < ActiveResource::Base
  self.site = PREALLOWED_HOST
  self.user = PREALLOWED_LOGIN
  self.password = PREALLOWED_PASSWORD
end
