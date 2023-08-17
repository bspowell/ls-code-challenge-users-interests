require "yaml"
require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

before do
  @users = YAML.load(File.read("users.yaml"))
end

helpers do
  def user_list(name)
    @users.each_with_object([]) do |(user, _), array|
      array << user if user != name
    end
  end

  def count_interests
    total = 0
    @users.each_key do |user|
      total += @users[user][:interests].count
    end
    total
  end
end

get "/" do
  redirect "/users"
end

get "/users" do
  erb :users
end

get "/:user_name" do
  @user_name = params[:user_name].to_sym
  @email = @users[@user_name][:email]
  @interests = @users[@user_name][:interests]

  erb :user
end