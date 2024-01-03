# Auth mechanism adapted from https://stackoverflow.com/a/3560286/2490003

register do
  def auth(type)
    condition do
      unless send("is_#{type}?")
        flash[:notice] = "You must sign in first"
        redirect "/login"
      end
    end
  end
end

helpers do
  def is_person?
    @person != nil
  end
end

before do
  if session[:expires_at] && Time.at(session[:expires_at]) > Time.now
    @person = Person.find_by_id(session[:person_id])
  end
end

get "/login" do
  erb :"auth/login"
end

post "/login" do
  username = params["login"]["username"]
  password = params["login"]["password"]

  person = Person.find_by_name(username)
  if person.nil?
    flash[:error] = "Invalid credentials"
    redirect back
  end

  if person.password != password
    flash[:error] = "Invalid credentials"
    redirect back
  end

  session[:person_id] = person.id
  session[:expires_at] = (Time.now + (60*60*24)*7).to_i # 7 days from now
  redirect to("/")
end

get "/logout" do
  session[:person_id] = nil
  session[:expires_at] = nil

  flash[:notice] = "You have been logged out"

  redirect to("/login")
end
