@isTest
public class CartControllerTest {
	
    /*
     * This method genrating data for testing 
	 */
    @testSetUp
    public static void setupProductsInstock()
    {
        List<Product2> productInStockList = new List<Product2>();
        for(Integer count = 0 ; count < 5; count++)
        {
            productInStockList.add(new Product2(Name = 'TestProduct ' + count , ProductCode = 'PCode' + count ,Price__c = 10 * (count+1) ,Quantity__c = (count)));
        }
        insert productInStockList;
    }
    
 	/*
     * This method genrating data for testing 
	 */
    
    @isTest
    public static void testInitializeCart()
    {
        Map<Id, ProductWrapper> selectedProductWrapperMap = new Map<Id, ProductWrapper>();
        List<Product2> productsList = [SELECT Name, ProductCode , Price__c , Quantity__c , Description FROM Product2];
        for(Product2 product : productsList){
            if(product.Quantity__c > 1) {
                selectedProductWrapperMap.put(product.Id, new ProductWrapper(product, true));
            }
        }
        
        CartController cartObj = new CartController();
        cartObj.initializeCart(selectedProductWrapperMap);//initializign cart by passing map of selected item in it
        
        
        //comparing number of product in cart which has quantity more than 1
        //4 is expected product in cart 
        System.assertEquals(3, cartObj.getProductsInCart().size());
    }
    
    /*
     * testing initializingCart method when item is already in cart list but increasing quantity of some items
	 */
    @isTest
    static void initializingCartTest2() {
       
       Map<Id, ProductWrapper> selectedProductWrapperMap = new Map<Id, ProductWrapper>();
       List<Product2> productsList = [SELECT Name, ProductCode , Price__c , Quantity__c , Description FROM Product2];
        for(Product2 product :productsList) {
            if(product.Quantity__c > 2) {
                selectedProductWrapperMap.put(product.Id, new ProductWrapper(product, true));
            }
        }
        
        CartController cartObj = new CartController();
        cartObj.initializeCart(selectedProductWrapperMap);
        selectedProductWrapperMap.remove(productsList[3].id);
        cartObj.initializeCart(selectedProductWrapperMap);
        
        Integer expectedProductInCart = 2;
        System.assertEquals(expectedProductInCart, cartObj.getProductsInCart().size());
        
        Integer expectedProduct1Quntity = 1;
        Integer expectedProduct2Quntity = 2;
       
        System.assertEquals(expectedProduct1Quntity, cartObj.getProductsInCart()[0].quantity);
        System.assertEquals(expectedProduct2Quntity, cartObj.getProductsInCart()[1].quantity);
    }
    
    
    /*
     * testing initializingCart method  when user gives quantity to 0
	 */
    @isTest
    static void initializingCartTest3() {
       
       Map<Id, ProductWrapper> selectedProductWrapperMap = new Map<Id, ProductWrapper>();
       List<Product2> productList = [SELECT Name, ProductCode , Price__c , Quantity__c , Description 
                                     FROM Product2 
                                     WHERE Quantity__c < 2 ];
        for(Product2 product :productList) {
            selectedProductWrapperMap.put(product.Id, new ProductWrapper(product, TRUE));
        }
        
        PageReference shoppingCartPage = Page.shoppingCart;
        Test.setCurrentPage(shoppingCartPage);
        CartController cartObj = new CartController();
        cartObj.initializeCart(selectedProductWrapperMap);
        
        System.assert(ApexPages.hasMessages());
        System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR));
        System.assert(ApexPages.getMessages().size() == 1);
    }
    

	/*
	 * testing method when updating in quantity of cart item
	 */    
    @isTest
    static void updateCartTest1(){
        Map<Id, ProductWrapper> selectedProductWrapperMap = new Map<Id, ProductWrapper>();
        List<Product2> productList = [SELECT Name, ProductCode , Price__c , Quantity__c , Description 
                                     FROM Product2 ];
        for(Product2 product :productList) {
            product.Quantity__c += 3;
            selectedProductWrapperMap.put(product.Id, new ProductWrapper(product, TRUE));
        }
        
        CartController cartObj = new CartController();
        cartObj.initializeCart(selectedProductWrapperMap);
        
        ProductWrapper pw = selectedProductWrapperMap.get(productList[0].Id);
        pw.quantity = 3;
        cartObj.updateCart(selectedProductWrapperMap, productList[0].Id);
        
        Integer expectedProductQuantityInCart = 3;
        Integer expectedProductAvailableQty = 0;
        Integer expectedProductOriginalQty = 3;
        
        ProductWrapper productWrp;
        for(ProductWrapper prdw: cartObj.getProductsInCart()) {
            if(prdw.product.Id.equals(productList[0].Id)) {
				productWrp = prdw;
            }
        }
        System.assertEquals(expectedProductQuantityInCart,productWrp.quantity);
        System.assertEquals(expectedProductAvailableQty,productWrp.availableQuantity);
        System.assertEquals(expectedProductOriginalQty,productWrp.originalQuantity); 
    }
    
    
    /*
     * testing method when new item has added in cart
	 */
    
    @isTest
    static void updateCartTest2()
    {
         
       Map<Id, ProductWrapper> selectedProductWrapperMap = new Map<Id, ProductWrapper>();
       List<Product2> productList = [SELECT Name, ProductCode , Price__c , Quantity__c , Description 
                                     FROM Product2];
        for(Product2 product :productList) {
            product.Quantity__c += 5;
            selectedProductWrapperMap.put(product.Id, new ProductWrapper(product, TRUE));
        }
        
        CartController cartObj = new CartController();
        cartObj.initializeCart(selectedProductWrapperMap);
        
        ProductWrapper prod = selectedProductWrapperMap.get(productList[0].id);
        prod.quantity = 3;
        selectedProductWrapperMap.remove(productList[0].id);
 
        cartObj.updateCart(selectedProductWrapperMap, productList[0].id);
        
        Integer expectedProductQuantityInCart = 3;
        Integer expectedProductAvailableQty = 2;
        Integer expectedProductOriginalQty = 5;
        
        ProductWrapper processedProduct;
        for(ProductWrapper product: cartObj.getProductsInCart()) {
            if(product.product.Id.equals(productList[0].id)) {
				processedProduct = product;
            }
        }
        System.assertEquals(expectedProductQuantityInCart,processedProduct.quantity);
        System.assertEquals(expectedProductAvailableQty,processedProduct.availableQuantity);
        System.assertEquals(expectedProductOriginalQty,processedProduct.originalQuantity);
    }
    
    /*
     * testing method when cart item quantity is updating and required quantity is not available
	 */
    @isTest
    static void  updateCartTest3() {
       
       Map<Id, ProductWrapper> selectedProductWrapperMap = new Map<Id, ProductWrapper>();
       List<Product2> productList = [SELECT Name, ProductCode , Price__c , Quantity__c , Description 
                                     FROM Product2];
        for(Product2 product :productList) {
            product.Quantity__c += 5;
            selectedProductWrapperMap.put(product.Id, new ProductWrapper(product, TRUE));
        }
        
        CartController cartObj = new CartController();
        cartObj.initializeCart(selectedProductWrapperMap);
        ProductWrapper prod = selectedProductWrapperMap.get(productList[0].id);
        prod.quantity = 18;
        cartObj.updateCart(selectedProductWrapperMap, productList[0].id);
        Test.setCurrentPage(Page.shoppingCart);
        
        System.assert(ApexPages.hasMessages());
        System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR));
        System.assert(ApexPages.getMessages().size() == 1);
        System.assert(ApexPages.getMessages()[0].getSummary().contains('Required Quantity not available'));
 
    }
    
    /*
     * testing method when cart item quantity is updating to 0
	 */
    @isTest
    static void  updateCartTest4() {
       
       Map<Id, ProductWrapper> selectedProductWrapperMap = new Map<Id, ProductWrapper>();
       List<Product2> productList = [SELECT Name, ProductCode , Price__c , Quantity__c , Description 
                                     FROM Product2];
        for(Product2 product :productList) {
            product.Quantity__c += 5;
            selectedProductWrapperMap.put(product.Id, new ProductWrapper(product, TRUE));
        }
        
        CartController cartObj = new CartController();
        cartObj.initializeCart(selectedProductWrapperMap);
        ProductWrapper prod = selectedProductWrapperMap.get(productList[0].id);
        
        prod.quantity = 0;
        
        cartObj.updateCart(selectedProductWrapperMap, productList[0].id);
        Test.setCurrentPage(Page.shoppingCart);
                
        System.assert(ApexPages.hasMessages());
        System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR));
        System.assert(ApexPages.getMessages().size() == 1);
        System.assert(ApexPages.getMessages()[0].getSummary().contains('Quantity cannot be zero or less'));
       
    }
 
    /*
     * testing method when item is removing from cart
	 */
    @isTest
    static void removeProductFromCartTest1() {
        
        Map<Id, ProductWrapper> selectedProductWrapperMap = new Map<Id, ProductWrapper>();
        List<Product2> productList = [SELECT Name, ProductCode , Price__c , Quantity__c , Description 
                                      FROM Product2];
        for(Product2 product :productList) {
            product.Quantity__c += 5;
            selectedProductWrapperMap.put(product.Id, new ProductWrapper(product, TRUE));
        }
        
        CartController cartObj = new CartController();
        cartObj.initializeCart(selectedProductWrapperMap);
        System.assertEquals(5,cartObj.getProductsInCart().size());
        cartObj.removeProductFromCart(productList[0].id);
        
        Integer expectedProductsInCartAfterRemoval = 4;
        System.assertEquals(expectedProductsInCartAfterRemoval,cartObj.getProductsInCart().size());
        System.assert(!cartObj.getProductsInCart().contains(selectedProductWrapperMap.get(productList[0].id)));
        
    }
}