require 'test_helper'

class ProductsControllerText < ActionDispatch::IntegrationTest
  def setup
    login
  end
  
  test 'render a list of products' do
    get products_path

    assert_response :success
    assert_select '.product', 12
    assert_select '.category', 12
  end

  test 'render a list of products filtered by category' do
    get products_path(category_id: categories(:jeans).id)

    assert_response :success
    assert_select '.product', 1
  end

  test 'render a list of products filtered by min price and max price' do
    get products_path(min_price: 2000, max_price: 2200)

    assert_response :success
    assert_select '.product', 1
    assert_select 'h2', 'One million'
  end

  
  test 'search a product by query_text' do
    get products_path(query_text: 'One million')

    assert_response :success
    assert_select '.product', 1
    assert_select 'h2', 'One million'
  end

  test 'sort products by expensive prices first' do
    get products_path(order_by: 'expensive')

    assert_response :success
    assert_select '.product', 12
    assert_select '.products .product:first-child h2', 'Seat Panda clásico'
  end

  test 'sort products by cheaper prices first' do
    get products_path(order_by: 'cheapest')

    assert_response :success
    assert_select '.product', 12
    assert_select '.products .product:first-child h2', 'El hobbit'
  end

  test 'render a detailed product page' do 
    get product_path(products(:nautica))

    assert_response :success
    assert_select '.title', 'Nautica'
    assert_select '.description', 'Perfume de hombre economico'
    assert_select '.price', '$800'
  end

  test 'render a new product form' do
    get new_product_path

    assert_response :success
    assert_select 'form'
  end 

  test 'allows to create a new product' do
    post products_path, params: { 
      product: {
        title: '360',
        description: 'El rojo',
        price: 1600,
        category_id: categories(:perfumes).id
      }
    }

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Tu producto se ha creado correctamente'
  end

  test 'does not allow to create a new product' do
    post products_path, params: { 
      product: {
        title: '',
        description: 'El rojo',
        price: 1600
      }
    }

    assert_response :unprocessable_entity
  end

  test 'render an edit product form' do
    get edit_product_path(products(:nautica))

    assert_response :success
    assert_select 'form'
  end 

  test 'allows to update a new product' do
    patch product_path(products(:nautica)), params: { 
      product: {
        price: 900
      }
    }

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Tu producto se ha actualizado correctamente'
  end

  test 'does not allow to update a new product' do
    patch product_path(products(:nautica)), params: { 
      product: {
        price: nil
      }
    }

    assert_response :unprocessable_entity
  end

  test 'can delete products' do 
    assert_difference('Product.count', -1) do
      delete product_path(products(:nautica))
    end

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Tu producto se ha eliminado correctamente'
  end
end