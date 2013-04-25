enable :sessions
# Redirecting a user back to the "log in" screen 
# if they try to view the secret page without being logged in

get '/' do
  redirect '/login'
end

get '/login' do

  erb :index
end

post '/login' do
  user = User.find_by_email(params[:email])
  user = User.authenticate(params[:email], params[:password])
  if user 
    session[:id] = user.id
    redirect "/secret_page"
  else
    @errors = "Invalid email and password" #do ajax later to add errors in
    erb :index
  end
end

get '/secret_page' do
  if session[:id]
    erb :secret
  else
    redirect '/'
  end
end


get '/signup' do

  erb :signup
end

post '/signup' do
  user = User.new(params)
  if user.save
    session[:id] = user.id
    redirect '/secret_page'
  else
    @errors = user.errors.full_messages
    render '/'
  end
end

post '/logout' do
  session[:id] = nil
  redirect '/'
end
