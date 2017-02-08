require 'rails_helper'

RSpec.describe ProductsController do

  before :all do
    @product = FactoryGirl.create(:product)
    @user = FactoryGirl.create(:user, :processor)
  end

  before :each do
    sign_in(@user)
  end

  describe "GET index" do
    before do
      get :index
    end

    it "assigns @products" do
      expect(assigns(:products)).to include(@product)
    end

    it "renders index template" do
      expect(response).to render_template('index')
    end
  end

  describe "GET show" do

    before do
      get :show, params: { id: @product.id }
    end

    it "assigns @product" do
      expect(assigns(:product)).to eq(@product)
    end

    it "renders products/show template" do
      expect(response).to render_template('show')
    end
  end

  describe "GET new" do
    before do
      get :new
    end

    it "builds @product" do
      expect(assigns(:product)).to be_a_new(Product)
    end

    it "renders the new form" do
      expect(response).to render_template('new')
    end
  end

  describe "GET edit" do
    before do
      get :edit, params: { id: @product.id }
    end

    it "assigns @product" do
      expect(assigns(:product)).to eq(@product)
    end

    it "renders the edit form" do
      expect(response).to render_template('edit')
    end
  end

  describe "POST create successfully" do
    before do
      @product_params = FactoryGirl.attributes_for(:product)

      post :create, params: { product: @product_params }
    end

    it "creates the new product" do
      expect(assigns(:product).valid?).to be(true)
    end

    it "redirects to the product page" do
      expect(response).to redirect_to(product_path(assigns(:product)))
    end
  end

  describe "POST create invalid data" do
    before do
      post :create, params: { product: {name: ""} }
    end

    it "renders the new form" do
      expect(response).to render_template("new")
    end
  end

  describe "PUT update successfully" do
    before do
      @new_product_params = FactoryGirl.attributes_for(:product)

      put :update, params: { id: @product.id, product: @new_product_params }
    end

    it "updates the product" do
      @product.reload
      expect(@product.name).to eq(@new_product_params[:name])
    end

    it "redirects to the product page" do
      expect(response).to redirect_to(product_path(@product))
    end
  end

  describe "PUT update invalid params" do
    before do
      put :update, params: { id: @product.id, product: { name: '' } }
    end

    it "renders the edit form" do
      expect(response).to render_template("edit")
    end

    it "does not update the @product" do
      @product.reload
      expect(@product.name).not_to eq('')
    end
  end

  describe "DELETE destroy" do
    before do
      delete :destroy, params: { id: @product.id }
    end

    it "deletes the product" do
      expect(Product.exists?(@product.id)).to be(false)
    end

    it "redirects to the product index" do
      expect(response).to redirect_to(products_path)
    end
  end
end
