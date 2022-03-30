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

    /** 
    * @description: Method create a new http object to send the request object.
    * The response object is generated as a result of the request, if the result is correct,
    * the data is processed using a parser, otherwise an error occurs.
    */
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
                            handleUpsert(innClass);
                        }
                    }
                }
            }
            upsertList();
        }else{
            System.debug('StatusCode error: ' + response.getStatusCode());
        }  

        /*
        try {
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                    while (parser.nextToken() != null) {
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            InnerClass innClass = (InnerClass)parser.readValueAs(InnerClass.class);
                            flagEqual = false;
                            handleUpsert(innClass);
                        }
                    }
                }
            }
            upsertList();
        } catch (Exception e ) {
            System.debug('Error: ' + e.getMessage());
            System.debug('StatusCode error: ' + response.getStatusCode());
        } 
        */
        return response;  
    }
    
     /** 
    * @description: Method separates the data from the response for insert and update and put them together in one list.
    * Input paramerer is InnerClass which represent the data from reponse.
    * @param: InnerClass innClass
    */
    private static void handleUpsert(InnerClass innClass){
        
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

     /** 
    * @description: Method upserts data if all permissions are valid.
    */
    private static void upsertList(){
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