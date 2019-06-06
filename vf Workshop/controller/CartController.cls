public class CartController {
	List<ProductWrapper> productWrapperInCartList = new List<ProductWrapper>();
    
    
    /*
     * @param selectedProductWrapperMap
     * 
     * this method initializing cart list
	*/
    public void initializeCart(Map<Id,ProductWrapper> selectedProductWrapperMap)
    {
        //list will contain selected product
        List<ProductWrapper> selectedProducts = (List<ProductWrapper>)selectedProductWrapperMap.values();
        
        for(ProductWrapper pw : selectedProducts)
        {
            if(pw.availableQuantity <= 0)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Product : '+pw.product.Name+' not available'));
            }
            else if(productWrapperInCartList.contains(pw))
            {
                pw.quantity++;
                pw.availableQuantity--;
            }
            else{
                pw.quantity = 1;
                pw.availableQuantity--;
                productWrapperInCartList.add(pw);
            }
        }
    }
    
    
    /*
     * @param selectedProductWrapperMap
     * @param selectedItem
     * 
     * This method updating cart when we are changing the quantity of cart item
	*/
    public void updateCart(Map<Id,ProductWrapper> selectedProductWrapperMap,Id selectedItem){
        ProductWrapper product;
        if(selectedProductWrapperMap.containsKey(selectedItem)) {
			product = selectedProductWrapperMap.get(selectedItem); 
        }	
        else {
            for(ProductWrapper pw:productWrapperInCartList) {
                if(pw.product.Id.equals(selectedItem)) {
                    product = pw;
                    break;
                }
            }
        }
        if(product.originalQuantity < product.quantity){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,product.product.Name + ' Required Quantity not available'));
            product.quantity = product.originalQuantity - product.availableQuantity;
            
            return;
        }
        else if(product.quantity <= 0){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,product.product.Name + ' Quantity cannot be zero or less'));
            product.quantity = product.originalQuantity - product.availableQuantity;
            
            return;
        }
        
        product.availableQuantity = product.originalQuantity - product.quantity;
    }
    
    /*
     * @param selectedItem,Id of item from cart which you want to delete
     * 
     * This method deleting item from cart 
	*/
    public void removeProductFromCart(Id selectedItem){
        Integer indexOfItemInListToDelete =-1;
        
        for(ProductWrapper pw : productWrapperInCartList){
            if(pw.product.Id.equals(selectedItem)){
                indexOfItemInListToDelete = productWrapperInCartList.indexOf(pw);
                pw.availableQuantity+=pw.quantity;
                pw.quantity =0;
                break;
            }
        }
        if(indexOfItemInListToDelete!=-1){
            productWrapperInCartList.remove(indexOfItemInListToDelete);
        }
    }
        
        
        
    /*
     * @return products in cart 
	*/
    public List<ProductWrapper> getProductsInCart() {
        return this.productWrapperInCartList; 
    }
}