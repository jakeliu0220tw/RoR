class BooksController < ApplicationController
	layout 'standard'

	# list all books in the database
	def list
		@books = Book.all
	end
	
	# display details of a single book
	def show
		@book = Book.find(params[:id])
	end
	
	# new a object and take user input from display page
	def new
		@book = Book.new
		@subjects = Subject.all
	end
	
	# create a record and save into the database
	def create
		@book = Book.new(book_params)
		
		if @book.save
			redirect_to :action => 'list'
		else
			@subjects = Subject.all
			render :action => 'new'
		end
	end
	
	# display details of a single book, and it's editable
	def edit
		@book = Book.find(params[:id])
		@subjects = Subject.all
	end
	
	# this action will be called when user complete edit and 'post'
	def update
		@book = Book.find(params[:id])
		
		if @book.update_attributes(book_params)
			redirect_to :action => 'show', :id => @book
		else
			@subjects = Subject.all
			render :action => 'edit'
		end
	end
	
	# destroy this book object
	def delete
		Book.find(params[:id]).destroy
		redirect_to :action => 'list'
	end
	
	def show_subjects
		@subject = Subject.find(params[:id])
	end
	
	private
	
	def book_params
		params.require(:book).permit(:title, :price, :subject_id, :description)
	end
end
