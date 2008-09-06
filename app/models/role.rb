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

  def self.admin_role(company)
    puts company.id
    puts company.name + "_admin"
    role_id = Client.find(CLIENT_ID).get(:role_id_from_name, :role_name => company.name + "_admin")
    role = Role.find(role_id)    
  end
  
end
