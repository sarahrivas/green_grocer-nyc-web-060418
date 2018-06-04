def consolidate_cart(cart)
  grocery_hash = {}
  cart.each do |item_hash|
    item_hash.each do |name, properties|
      if grocery_hash[name]
        grocery_hash[name][:count] += 1
      else 
        grocery_hash[name] = properties
        grocery_hash[name][:count] = 1
      end  
    end  
  end  
  grocery_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item = cart[coupon[:item]]
    if item
      remaining_items = item[:count] - coupon[:num]
      if (remaining_items > -1)
        if cart["#{coupon[:item]} W/COUPON"]
          cart["#{coupon[:item]} W/COUPON"][:count] = 1
          cart["#{coupon[:item]} W/COUPON"][:price] += coupon[:cost]
        else
          cart["#{coupon[:item]} W/COUPON"] = {
            :price => coupon[:cost],
            :clearance => item[:clearance],
            :count => 1
          }         
        end        
        item[:count] = remaining_items
      end      
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item_name, properties|
    if (properties[:clearance])
      cart[item_name][:price] = (cart[item_name][:price] * 0.8).round(3)
    end
  end
  cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
    total_cost_cart = 0
    cart_after_coupon = apply_coupons(cart,coupons)
    cart_after_clearance = apply_clearance(cart_after_coupon)
    cart_after_coupon.each do |item_name, properties|
      total_cost_cart += properties[:price]
    end
    if(total_cost_cart > 100)
      total_cost_cart = total_cost_cart * 0.90
    end  
    total_cost_cart
  end  
   
    
