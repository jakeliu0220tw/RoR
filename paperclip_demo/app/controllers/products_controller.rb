class ProductsController < ApplicationController
    def index
      @products = Product.order('created_at DESC').limit(10)
    end
    
    def show
      @product = Product.find(params[:id])
    end
    
    def new
      puts "=== new ==="
      @product = Product.new
    end
    
    def create
      puts "=== create ==="
      @product = Product.new(allowed_params)

      # download photo from url and associate with imgurl field
      unless @product.imgurl.nil?
        filename = "./tmp/#{@product.imgurl.split('/').last}"
        cmd = %x[wget #{@product.imgurl} -O #{filename}]
        File.open(filename) do |f|
            @product.photo = f
        end
      end
      
      if @product.save
        flash[:notice] = "Successfully created product."
        redirect_to @product
      else
        render :new
      end
    end
    
    def edit
      puts "=== edit ==="
      @product = Product.find(params[:id])
    end
    
    def update
      puts "=== update ==="
      @product = Product.find(params[:id])
      
      if @product.update_attributes(allowed_params)
        flash[:notice] = "Successfully updated product."
        # download photo from url and associate with imgurl field
        unless @product.imgurl.nil?
            filename = "./tmp/#{@product.imgurl.split('/').last}"
            cmd = %x[wget #{@product.imgurl} -O #{filename}]
            File.open(filename) do |f|
                @product.photo = f
            end
            @product.save
            @product.reload
        end
        redirect_to @product
      else
        render :edit
      end
    end
    
    def destroy
      @product = Product.find(params[:id])
      @product.destroy
      flash[:notice] = "Successfully destroyed product."
      redirect_to products_url
    end
    
    private
    
    def allowed_params
      params.require(:product).permit!
    end
  end