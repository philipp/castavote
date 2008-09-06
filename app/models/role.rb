class Role < ActiveResource::Base
  self.site = CLIENTS_URI
  self.user = PREALLOWED_LOGIN
  self.password = PREALLOWED_PASSWORD

  # return true in case of success, false otherwise
  def add_to_resource(resource)
    res = resource.put(:add_role, :id => resource.id, :role_id => self.id, :client_id => CLIENT_ID)
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      return true
    else
      return false
    end
  end

  # return true in case of success, false otherwise
  def add_to_subject(subject)
    res = subject.put(:add_role, :id => subject.id, :role_id => self.id, :client_id => CLIENT_ID)
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      return true
    else
      return false
    end
  end
  # return true in case of success, false otherwise
  def remove_from_subject(subject)
    res = subject.put(:remove_role, :id => subject.id, :role_id => self.id, :client_id => CLIENT_ID)
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      return true
    else
      return false
    end
  end

end
