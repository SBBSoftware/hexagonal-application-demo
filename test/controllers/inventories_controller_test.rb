require 'test_helper'

class InventoriesControllerTest < ActionController::TestCase

  setup do
    @inventory = create(:inventory)
  end

  should 'get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:inventories)
  end

  should 'get new' do
    get :new
    assert_response :success
  end

  should 'create inventory' do
    params = attributes_for(:inventory)
    assert_difference('Inventory.count') do
      post :create, inventory: params
    end
    assert_redirected_to inventory_path(assigns(:inventory))
  end

  should 'show inventory' do
    get :show, id: @inventory
    assert_response :success
  end

  should 'get edit' do
    get :edit, id: @inventory
    assert_response :success
  end

  should 'update inventory' do
    patch :update, id: @inventory, inventory: { sku: 'hellow' }
    assert_redirected_to inventory_path(assigns(:inventory))
  end

  should 'destroy inventory' do
    assert_difference('Inventory.count', -1) do
      delete :destroy, id: @inventory
    end
    assert_redirected_to inventories_path
  end

  should 'reorder when inventory qualifies' do
    inventory = create(:inventory_needing_reorder)
    assert_difference('inventory.inventory_reorders.count') do
      patch :reorder, id: inventory
      assert_redirected_to inventory_path(assigns(:inventory))
    end
  end

  should 'not reorder unless inventory qualifies' do
    assert_no_difference('@inventory.inventory_reorders.count') do
      patch :reorder, id: @inventory
      assert_redirected_to inventory_path(assigns(:inventory))
    end
  end

end
