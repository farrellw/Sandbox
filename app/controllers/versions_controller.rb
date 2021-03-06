class VersionsController < ApplicationController
	before_action :authenticate_user!, except: [:index, :show]
	before_action :check_if_banned

	def index
		@article = Article.find_by(id: params[:article_id])
		@versions = @article.versions[0..-2]
	end

	def show
		@version = Version.find_by(id: params[:id])
	end

	def new
		@article = Article.find_by(id: params[:article_id])
	end

	def create
		@article = Article.find_by(id: params[:article_id])
		@version = Version.new(version_params.merge(editor: current_user, article: @article))
		if @version.save
			redirect_to article_path(@article)
		else
			@errors = @version.errors.full_messages
			render "versions/new"
		end
	end

	def destroy
		if admin_user?
			@article = Article.find_by(id: params[:article_id])
			Version.find_by(id: params[:id]).destroy
			versions_left = @article.versions.length
			redirect_to article_versions_path(@article) if versions_left > 1
			redirect_to article_path(@article) if versions_left == 1
			redirect_to articles_path if versions_left < 1
		else
			render file: "/public/422.html"
		end
	end

	private
		def version_params
			params.require(:version).permit(:title, :body)
		end
end
