public class ShoppingCartController 
{   
    public String selectedProduct {get; set;}
    public Boolean showNewOrderButton {get; set;}
    public Boolean showPurchaseHistoryArea {get; set;}
    public Boolean showProducts {get; set;} //For showing product area
    public Boolean showCart {get; set;}	//For showing Cart area
    public Boolean showCheckout {get; set;} //For showing checkout area
    
    
    private PurchaseHistoryController purchaseHistoryObj;
    private ProductsController productsObj;
    private CartController cartObj;
    private CheckoutController checkoutObj;
    /*
     * Constructor
	*/
    public ShoppingCartController(){
        this.purchaseHistoryObj = new PurchaseHistoryController();
        this.productsObj = new ProductsController();
        this.cartObj = new CartController();
        this.checkoutObj = new CheckoutController();
        this.showPurchaseHistoryArea = TRUE;
        this.showNewOrderButton = true;
        this.showCart = false;
        this.showProducts = false;
        this.showCheckout = false;
    }
    
    /*
     * making product area visible
	*/
    public void newPurchase()
    {
        this.showProducts = true;
        this.showNewOrderButton = false;
    }
    
    
    /****** Purchase order history start ***********/
    
    public List<Purchase_Order__c> getPurchaseOrders() {
        return this.purchaseHistoryObj.getPurchaseOrders();
    }
    
    public void sortByOrderId() {
        this.purchaseHistoryObj.sortByOrderId();
    }
    public void sortByOrderPrice() {
        this.purchaseHistoryObj.sortByOrderPrice();
    }
    
    public void sortByOrderStatus() {
        this.purchaseHistoryObj.sortByOrderStatus();
    }
    
    public Integer getPageSize() {return this.purchaseHistoryObj.getPageSize();}
    public Integer getPageNumber() {return this.purchaseHistoryObj.getPageNumber();}
    public Integer getResultSize() {return this.purchaseHistoryObj.getResultSize();}
    public void next() { this.purchaseHistoryObj.next(); }
    public void previous() { this.purchaseHistoryObj.previous(); }
    public void first() { this.purchaseHistoryObj.first(); }
    public void last() { this.purchaseHistoryObj.last(); }
    public Boolean getHasNext() { return this.purchaseHistoryObj.getHasNext(); }
    public Boolean getHasPrevious() { return this.purchaseHistoryObj.getHasPrevious(); }
    
    /****** Purchase order history ends ***********/
    
    /****** products area starts ***********/
	
    public void search() {
		this.productsObj.search();
    }
    
    public String getProductTobeSearched() {
        return this.productsObj.getProductTobeSearched();
    } 
    
    public void setProductTobeSearched(String productName) {
        this.productsObj.setProductTobeSearched(productName);
    }
    
    public Boolean getShowProducts() {
        return this.ShowProducts;
    }
    
    public List<ProductWrapper> getProductWrapperList () {
        return this.productsObj.getProductWrapperList();
    }
    
    public Integer getPageSizeProduct() {return this.productsObj.getPageSize();}
    public Integer getPageNumberProduct() {return this.productsObj.getPageNumber();}
    public Integer getResultSizeProduct() {return this.productsObj.getResultSize();}
    public void nextProductPage() { this.productsObj.next(); }
    public void previousProductPage() { this.productsObj.previous(); }
    public void firstProductPage() { this.productsObj.first(); }
    public void lastProductPage() { this.productsObj.last(); }
    public Boolean getHasNextProductPage() { return this.productsObj.getHasNext(); }
    public Boolean getHasPreviousProductPage() { return this.productsObj.getHasPrevious(); }
    
     /****** products area ends ***********/
    
    /******* Cart Area starts ************/
    
    public void addToCart() {
		this.productsObj.updateProductWrapperMap();
        this.cartObj.initializeCart(this.productsObj.getSelectedProductWrapperMap());
        System.debug('size : '+this.cartObj.getProductsInCart().size());
        if(this.cartObj.getProductsInCart().size() > 0){
            this.showCart = TRUE;
        }
    }
    
    
    public void updateCart(){
        this.cartObj.updateCart(this.productsObj.getSelectedProductWrapperMap(), this.selectedProduct);
    }
    
    public void removeProductFromCart() {
        this.cartObj.removeProductFromCart(this.selectedProduct);
        if(this.cartObj.getProductsInCart().isEmpty()) {
            this.showCart = FALSE;
        }
    }
   
    public List<ProductWrapper> getProductsInCart() {
        return this.cartObj.getProductsInCart(); 
    }
    
     public void checkout() {
        
        if(ApexPages.hasMessages()){
            
            return;
        }
         
        this.showPurchaseHistoryArea = FALSE;
        this.showProducts = FALSE;
        this.showCart = FALSE;
        this.showNewOrderButton = FALSE;
        
        this.checkoutObj.calculateTotalAmount(getProductsInCart());
        this.showCheckout = TRUE;
        
	}
	
    /******* Cart Area Ends ************/
    
    /******* checkout area starts ******/
    
    public Boolean getShowCheckout() {
        return this.showCheckout;
    }
    
    public Decimal getTotalAmount() {
        return this.checkoutObj.getTotalAmount();
    }
    
    public PageReference placeOrder() {
       	this.checkoutObj.placeOrder(getProductsInCart()); 
        PageReference page = ApexPages.currentPage();
		page.setRedirect(TRUE);
        return page;
    }
    
    
}