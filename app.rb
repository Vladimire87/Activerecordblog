#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, { adapter: 'sqlite3', database: 'blog.db' }

class Post < ActiveRecord::Base
	validates :title, presence: true, length: { maximum: 50 }
  validates :author, presence: true
  validates :content, presence: true
	has_many :comments
end

class Comment < ActiveRecord::Base
  validates :content, presence: true, length: { maximum: 250 }
end

before do
 @posts = Post.order("updated_at DESC")
 @comments = Comment.all
end

get '/' do
  erb :posts
end

get '/posts' do
  erb :posts
end

get '/newpost' do
	@post = Post.new
  erb :newpost
end

post '/newpost' do
	@post = Post.new params[:post]
	if @post.save
		erb :posts
	else
		@error = @post.errors.full_messages.first
		erb :newpost
	end
end

get "/post/:id" do
	@post = Post.find(params[:id])
	@comment = Comment.new

	erb :post
end

post "/post/:id" do
	@post = Post.find(params[:id])
	@comment = Comment.new params[:comment]

	if @comment.save
		erb :post
	else
		@error = @comment.errors.full_messages.first
		erb :post
	end
end