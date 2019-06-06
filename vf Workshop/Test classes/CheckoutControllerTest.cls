@isTest
public class CheckoutControllerTest {
    
    /*
     * Generating data for testing
	 */
	@testSetUp 
    static void setupProductsForTesting(){
        List<Product2> productsList = new List<Product2>();
        for(Integer count = 0 ; count < 5 ; count++){															
            productsList.add(new Product2(Name = 'Test Product ' + (count+1) , 										
                                              ProductCode = 'PCode' + (count+1) ,
                                              Description = 'Test product data' ,
                                              Price__c = 20 * (count+1) ,
                                              Quantity__c = count));
        }
        insert productsList;
	} 
    
    
    /*
     * This method total amount of cart item 
     * covering null list scenerio as well i.e. when nothing in cart the total amount will be 0
	 */
    @isTest
    static void calculateTotalAmountTest() {
        
        List<Product2> productsList = [SELECT Name, ProductCode , Price__c , Quantity__c , Description
                                           FROM Product2];
        List<ProductWrapper> productWrapperList = new List<ProductWrapper>();
        for(Product2 product : productsList) {
            ProductWrapper pw = new ProductWrapper(product , FALSE);
            pw.quantity = 1;
            productWrapperList.add(pw);
        }
        
        CheckoutController checkoutObj = new CheckoutController();
        Decimal result = checkoutObj.calculateTotalAmount(productWrapperList);
        System.debug(result);
        Decimal expectedResult = 300.00;
        System.assertEquals(expectedResult, result);
        
        // when list is null
        Decimal result2 = checkoutObj.calculateTotalAmount(null);
        System.assertEquals(0.00, result2);
     }
    
    @isTest 
    static void getTotalAmountTest() {
        CheckoutController checkoutObj = new CheckoutController();
        System.assertEquals(0.0,checkoutObj.getTotalAmount());
    }
    
    /*
     * testig plced order 
	 */
    @isTest
    static void placeOrderTest(){
        List<Product2> productsList = [SELECT Name, ProductCode , Price__c , Quantity__c , Description
                                           FROM Product2];
        List<ProductWrapper> productWrapperList = new List<ProductWrapper>();
        for(Product2 product : productsList) {
            ProductWrapper pw = new ProductWrapper(product , FALSE);
            pw.quantity = 1;
            productWrapperList.add(pw);
        }
         
        CheckoutController checkoutObj = new CheckoutController();
        checkoutObj.placeOrder(productWrapperList);
        
        Purchase_Order__c purchaseOrder = [SELECT id FROM Purchase_Order__c][0];
        System.assert(purchaseOrder != null);
        List<PurchaseOrderLineItems__c> purchaseOrderLineItemList = [SELECT id FROM PurchaseOrderLineItems__c WHERE Purchase_Order__c = :purchaseOrder.id];
        System.assertEquals(5,purchaseOrderLineItemList.size());
        
    }
}