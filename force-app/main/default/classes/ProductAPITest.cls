@isTest
private class ProductAPITest {
    @isTest 
    static void testGetCallout() {

        Product2 product = new Product2();
        product.name = 'FLANGE LINEAR BUSHING KBMM-30-DD';
        product.StockKeepingUnit = 'R150249063';
        
        insert product;

        Test.startTest();
        // Call Test.startTest before performing callout
        // but after setting test data.

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ProductAPIHttpCalloutMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpResponse response = ProductAPI.productSync();
        // Verify that the response received contains fake values
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json', 'contenType assert');
        String actualValue = response.getBody();

        System.debug(response.getBody());
        String expectedValue = '[{"Name":"BALL NUT FEM-E-B 40X40RX6-3","SKU":"R150249063"},{"Name":"BALL NUT ZEM-E-S 16X5RX3-4","SKU":"R151201022"}]';
        System.assertEquals(expectedValue, actualValue, 'Equal values  control');
        System.assertEquals(200, response.getStatusCode(), 'StatusCode control');
        Test.stopTest();
    } 

    @isTest 
    static void testGetCalloutError() {

        Product2 product = new Product2();
        product.name = 'FLANGE LINEAR BUSHING KBMM-30-DD';
        product.StockKeepingUnit = 'R150249063';
        
        insert product;

        Test.startTest();
        // Call Test.startTest before performing callout
        // but after setting test data.

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ProductAPIHttpCalloutMockError()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpResponse response = ProductAPI.productSync();
        // Verify that the response received contains fake values
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json', 'contenType assert');
        String actualValue = response.getBody();

        System.debug(response.getBody());
        String expectedValue = '[{"Name":"BALL NUT FEM-E-B 40X40RX6-3", "SKU": "5656541"}]';
        System.assertEquals(expectedValue, actualValue, 'Equal values  control');
        System.assertEquals(502, response.getStatusCode(), 'StatusCode control');
        Test.stopTest();
    } 
}