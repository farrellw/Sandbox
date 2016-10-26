class ArticlesController < ApplicationController
	def index
		@articles = Article.all
	end

	def create
		@article = Article.new
		redirect_to articles_path
	end

	def new
		@article = Article.new
	end

	def show
		@article = Article.find_by(id: params[:id])
	end

	def destroy
		Article.find_by(id: params[:id]).destroy
		redirect_to articles_path
	end
end