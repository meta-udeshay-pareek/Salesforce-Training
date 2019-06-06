public class CheckoutController {
    
    public Decimal totalAmount {get; set;}
    
    public CheckoutController(){
        this.totalAmount = 0;
    }
    
    /*
     * @param ProductsInCart , list of cart products
     * @returning totalAmount, total amount of products which are added in cart
	 */
    public Decimal calculateTotalAmount(List<ProductWrapper> ProductsInCart){
        if(ProductsInCart == null){
            return 0.00;
        }
        
        this.totalAmount = 0;
        for(ProductWrapper pw : ProductsInCart){
            this.totalAmount += pw.quantity*pw.product.Price__c;
        }
        
        return this.totalAmount;
    }
    
    
    public Decimal getTotalAmount () {
		return this.totalAmount;
    }
    
     public void placeOrder(List<ProductWrapper> productWrapperInCartList) {
        
        
        Purchase_Order__c purchaseOrder = new Purchase_Order__c(Order_Price__c = this.totalAmount, Order_Status__c = 'Pending');
        insert purchaseOrder;
        List<PurchaseOrderLineItems__c> purchaseOrderLineItemList = new List<purchaseOrderLineItems__c>();
        List<Product2> productList = new List<Product2>();
        for(ProductWrapper pw : productWrapperInCartList) {
            purchaseOrderLineItemList.add(new PurchaseOrderLineItems__c(Purchase_Order__c = purchaseOrder.Id ,
                                                                       Product__c = pw.product.Id ,
                                                                       Ordered_quantity__c = pw.quantity ,
                                                                       Amount__c = pw.quantity * pw.product.Price__c));
            pw.product.quantity__c = pw.availableQuantity;
            productList.add(pw.product);
        }
        
		update productList;        
        
		insert purchaseOrderLineItemList;   
        
    }
    
    

}