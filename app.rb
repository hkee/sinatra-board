gem 'json', '~> 1.6'
require 'sinatra'
require 'sinatra/reloader'
require 'bcrypt'
require './model.rb'

before do 
  p '***************************'
  p params
  p '***************************'
end
get '/' do # routing, '/' 경로로 들어왔을 때
 send_file 'index.html' # index.html 파일을 보내줘
end

get '/lunch' do # '/lunch' 경로로 들어왔을 때
  @lunch = ["멀캠20층", "바스버거", "소고기"]
  erb :lunch # views폴더 안에 있는 lunch.erb를 보여줘
end

# 게시글을 모두 보여주는 곳
get '/posts' do
  @posts = Post.all
  erb :'posts/posts'
end

# 게시글을 쓸 수 있는 곳
get '/posts/new' do
  erb :'posts/new'
end

get '/posts/create' do
  @title = params[:title]
  @body = params[:body]
  Post.create(title: @title, body: @body)
  erb :'posts/create'
end

get '/posts/:id' do
  # 게시글 id를 받아서
  @id = params[:id]
  # db에서 찾는다
  @post = Post.get(@id)
  erb:'posts/show'
end




get '/posts/destroy/:id' do
  Post.get(params[:id]).destroy
  # erb :'posts/destroy'
  redirect '/posts'
end

# 값을 받아서 뿌려주기 위한 용도
get '/posts/edit/:id' do
  @id = params[:id]
  @post = Post.get(@id)
  erb :'posts/edit'
end

get '/posts/update/:id' do
  @id = params[:id]
  Post.get(@id).update(title: params[:title], body: params[:body])
  redirect '/posts/'+@id
end


get '/users/new' do
 erb :"users/new"
end

get '/users/create' do
  if params[:pwd] !=params[:pwd_confirm]
    redirect '/'
  else
    User.create(name: params[:name],email: params[:email],password: Bcrpyt::password.create(params[:pwd]))
  end
  erb :"users/create"
end


get '/users' do

  @users=User.all
  erb:"users/users"
end
