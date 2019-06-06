@isTest
public class ProductControllerTest {
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
    * This method is testing initialization of product list 
	*/
    @isTest
    public static void initProductWrapperTest1(){
        ProductsController productObj = new ProductsController();
        productObj.initProductWrapper();
        System.assertEquals(5,productObj.getProductWrapperList().size());
    }
    
    /*
     * Test selected product in map from product list
	 */
    @isTest
    static void initProductWrapperTest2() {
        ProductsController productObj = new ProductsController();
        productObj.initProductWrapper();
        ProductWrapper pw = productObj.getProductWrapperList()[0];
        pw.checked = TRUE; 
   
        productObj.updateProductWrapperMap();
        System.assertEquals(5,productObj.getProductWrapperList().size());
        System.assertEquals(1,productObj.getSelectedProductWrapperMap().size());
    
        pw.checked = False; 
        productObj.updateProductWrapperMap();
        System.assertEquals(0,productObj.getSelectedProductWrapperMap().size());
    }
    
    
    /*
     * Test method for searching item in product list
	 */
    @isTest
    static void initProductWrapperTest3() {
		
		String searchProduct = 'TestProduct 1';
        
		ProductsController productObj = new ProductsController();  
        productObj.setProductTobeSearched(searchProduct);
        productObj.initProductWrapper();
        
        System.assertEquals(1,productObj.getProductWrapperList().size());
        System.assertEquals(searchProduct,productObj.getProductTobeSearched());
    }
  
}