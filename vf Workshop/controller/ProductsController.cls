public class ProductsController {
    
    public String productToBeSearched { get; set;}
    
    List<ProductWrapper> productWrapperList = new List<ProductWrapper>();
    Map<Id,ProductWrapper> selectedProductWrapperMap = new  Map<Id,ProductWrapper>();
    List<Product2> productList = new List<Product2>();
    
    public ApexPages.StandardSetController setCon{
        get{
            if(String.isNotBlank(this.productToBeSearched)){
                productList = [SELECT Name , ProductCode , Description , Price__c , Quantity__c FROM Product2 WHERE Name LIKE :(this.productTobeSearched+'%')];
            }
            else 
            {
                productList = [SELECT Name , ProductCode , Description , Price__c , Quantity__c FROM Product2];
            }
            setCon = new ApexPages.StandardSetController(productList);
            setCon.setPageSize(10);
         return setCon;   
        }
        set;
    }

   
    public List<Product2> getProducts(){
        return (List<Product2>) setCon.getRecords();
    }
    
    public void search()
    {
        setCon = null;
    }
    
    
    /*
     * @return All Product to show on vf page
	 */
    public List<ProductWrapper> getProductWrapperList()
    {
        productWrapperList = new List<ProductWrapper>();
        initProductWrapper();
        return productWrapperList;
    }
    
    
    /*
     * This method initializig productWrapperList to show on vf page
	 */
    public void initProductWrapper()
    {
        for(Product2 product : getProducts())
        {
            if(selectedProductWrapperMap.containsKey(product.Id)){
                productWrapperList.add(selectedProductWrapperMap.get(product.Id));
            }else{
                productWrapperList.add(new ProductWrapper(product,false));
            }
        }
    }
    
    
    /*
     * This method updating selected item from list in map
	 */
    public void updateProductWrapperMap()
    {
        for(ProductWrapper productWrp : productWrapperList){
            if(productWrp.checked && !selectedProductWrapperMap.containsKey(productWrp.product.Id)){
                selectedProductWrapperMap.put(productWrp.product.Id,productWrp);
            }else if(! productWrp.checked && selectedProductWrapperMap.containsKey(productWrp.product.Id)){
                selectedProductWrapperMap.remove(productWrp.product.Id);
            }
        }
    }
    
    /*
     * @return selectedProductWrapperMap , selected item map 
	 */
    public Map<Id,ProductWrapper> getSelectedProductWrapperMap(){
        return this.selectedProductWrapperMap;
    }
    
    /*
     * @return productToBeSearched, the product which is searchign in search box 
	 */
    public String getProductToBeSearched()
    {
        return this.productToBeSearched;
    }
    
    public void setProductToBeSearched( String productToBeSearched)
    {
        this.productToBeSearched = productToBeSearched;
    }
    
    /******pagination********/
    public Integer getPageSize(){ return setCon.getPageSize(); }
    public Integer getPageNumber(){ return setCon.getPageNumber(); }
    public Integer getResultSize(){ return setCon.getResultSize(); }
    
    public void next()
    { 
        updateProductWrapperMap();
        setCon.next();         
    }
    public void previous()
    { 
		updateProductWrapperMap();
        setCon.previous();
    }
    public void first()
    {
       
        updateProductWrapperMap();
        setCon.first(); 
    }
    public void last()
    { 
        
        updateProductWrapperMap();
        setCon.last();
    }
    public Boolean getHasNext(){ return setCon.getHasNext(); }
    public Boolean getHasPrevious(){ return setCon.getHasPrevious(); }
}