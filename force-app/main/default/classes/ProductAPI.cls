/** 
* @author: Tomas Bielik
* @date:   21.03.2022
* @description: API Callout, Upsert
*/

public with sharing class ProductAPI {

    public static boolean flagEqual = false;
    public static List<Product2> upsertList = new List<Product2>();
    public static Map<ID, Product2> mapProduct = new Map<ID, Product2>([SELECT StockKeepingUnit, Name FROM Product2 WITH SECURITY_ENFORCED]);

    class InnerClass {
        public String name;
        public String sku;
    }

    public static HttpResponse productSync() {
        Http http = new Http(); 
        HttpRequest request = new HttpRequest(); 
        request.setMethod('GET');
        request.setEndpoint('callout:NubesTechApi');
        HttpResponse response = http.send(request);
        JSONParser parser = JSON.createParser(response.getbody());
        
        if (response.getStatusCode() == 200) {
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                    while (parser.nextToken() != null) {
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            InnerClass innClass = (InnerClass)parser.readValueAs(InnerClass.class);
                            flagEqual = false;
                            helpMethodSetList(innClass);
                        }
                    }
                }
            }
            helpMethodUpsert();
        }else{
            System.debug('StatusCode error: ' + response.getStatusCode());
        }  
        return response;  
    }
    
    private static void helpMethodSetList(InnerClass innClass){
        
        for (Product2 product : mapProduct.values()) {
            if(product.StockKeepingUnit == innClass.SKU){
                product.Name = innClass.Name;
                product.IsActive = true;
                upsertList.add(product);
                
                System.debug('update: Name: ' + product.Name + ' SKU: ' + product.StockKeepingUnit + ' Active: ' + product.IsActive);
                flagEqual = true;
                break;
            }
        }

        if(!flagEqual){
            Product2 productInsert = new Product2();
            productInsert.Name = innClass.Name;
            productInsert.StockKeepingUnit = innClass.SKU;
            productInsert.IsActive = true;
            upsertList.add(productInsert);
            System.debug('insert: Name: ' + productInsert.Name + ' SKU: ' + productInsert.StockKeepingUnit + ' Active: ' + productInsert.IsActive);

        }
    }

    private static void helpMethodUpsert(){
        System.debug('UpserList: ' + upsertList);
        if(upsertList.size()> 0){
            if (Schema.sObjectType.Product2.isCreateable() && Schema.sObjectType.Product2.isUpdateable()) {
                upsert upsertList;
             } else {
                 System.debug('You dont have permissions');
             }
        } else {
            System.debug('Nothings to upsert');
        }
    }
}