public class ProductWrapper {
    public Product2 product {get; set;}
    public Boolean checked {get; set;}
    public Integer quantity {get; set;}
    public Integer availableQuantity {get; set;}
    public Integer originalQuantity {get; set;}
    
    public ProductWrapper(Product2 product, Boolean checked)
    {
    	this.product = product;
        this.checked = checked;
        this.availableQuantity = (Integer)product.Quantity__c;
        this.originalQuantity =  (Integer)product.Quantity__c;
    }
    
    public ProductWrapper(ProductWrapper prodWrapper)
    {
    	this.product = prodWrapper.product;
        this.checked = prodWrapper.checked;
        this.quantity = prodWrapper.quantity;
        this.availableQuantity = prodWrapper.availableQuantity;
        this.originalQuantity = prodWrapper.originalQuantity;
    }
    

}