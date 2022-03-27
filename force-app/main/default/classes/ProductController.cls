/** 
* @author: Tomas Bielik
* @date:   20.03.2022
* @description: select from product into List
*/

public with sharing class ProductController {
    @AuraEnabled(cacheable = true)
    public static List<Product2> getProducts(String searchKey) {
        return [SELECT Id, Name, StockKeepingUnit FROM Product2 WHERE StockKeepingUnit=:searchKey WITH SECURITY_ENFORCED];
    }
}