/**
* @author:		 Frédéric VO
* @date:		 19/10/2020
* @description:	 Test batch named BatchUpdateSalesRevenues
*
*/
@isTest
private class BatchUpdateSalesRevenuesTEST {

    /*
    Test when update Orders and ExecuteBatch then Sales Revenues should be update
    */
    @isTest static void testUpdateSalesRevenuesBatchUpdate(){
        Account oldAccount = TestDataFactory.generateAccount('oldAccount');
        insert oldAccount;
        System.debug('oldAccount:' + oldAccount);
        System.assertEquals(null, oldAccount.Chiffre_affaire__c);

        Contract contract1 = TestDataFactory.generateContract(oldAccount.Id);
        insert contract1;
        System.debug('contract1:' + contract1);

        Id pricebookId = Test.getStandardPricebookId();

        Product2 product2 = TestDataFactory.generateProduct('product1');
        insert product2;
        System.debug('product2:' + product2);

        PricebookEntry pbe = TestDataFactory.generatePriceBookEntry(pricebookId, product2.Id);
        pbe.UnitPrice = 1000;
        pbe.IsActive = true;
        pbe.UseStandardPrice = false;
        insert pbe;
        System.debug('pbe:' + pbe);

        List<Order> orderListToUpdate = new List<Order>();

        Order oldOrder1 = TestDataFactory.generateOrder(oldAccount.Id, contract1.Id);
        oldOrder1.Pricebook2Id = pricebookId;
        oldOrder1.ShipmentCost__c = 100;
        insert oldOrder1;
        System.debug('oldOrder1:' + oldOrder1);

        OrderItem orderItem1 = TestDataFactory.generateOrderItem(oldOrder1.Id, pbe.Id);
        orderItem1.Quantity = 10;
        orderItem1.UnitPrice = 150;
        insert orderItem1;
        System.debug('orderItem1:' + orderItem1);

        contract1.Status = 'Activated';
        update contract1;
        oldOrder1.Status = 'Activated';
        orderListToUpdate.add(oldOrder1);

        Order oldOrder2 = TestDataFactory.generateOrder(oldAccount.Id, contract1.Id);
        oldOrder2.Pricebook2Id = pricebookId;
        oldOrder2.ShipmentCost__c = 100;
        insert oldOrder2;
        System.debug('oldOrder2:' + oldOrder2);

        OrderItem orderItem2 = TestDataFactory.generateOrderItem(oldOrder2.Id, pbe.Id);
        orderItem2.Quantity = 10;
        orderItem2.UnitPrice = 150;
        insert orderItem2;
        System.debug('orderItem2:' + orderItem2);

        oldOrder2.Status = 'Activated';
        orderListToUpdate.add(oldOrder2);

        update orderListToUpdate;

        test.startTest();
        Database.executeBatch(new BatchUpdateSalesRevenues());
        Test.stopTest();

        Account newAccount = [SELECT Id, Name, Chiffre_affaire__c FROM Account WHERE Name =: 'oldAccount'];
        System.debug('newAccount.Chiffre_affaire__c: ' + newAccount.Chiffre_affaire__c);
        System.assertEquals(3000, newAccount.Chiffre_affaire__c);
    }

    /*
    Test when delete Orders and ExecuteBatch then Sales Revenues should be update
    */
    @isTest static void testUpdateSalesRevenuesBatchDelete(){
        Account oldAccount = TestDataFactory.generateAccount('oldAccount');
        insert oldAccount;
        System.debug('oldAccount:' + oldAccount);
        System.assertEquals(null, oldAccount.Chiffre_affaire__c);

        Contract contract1 = TestDataFactory.generateContract(oldAccount.Id);
        insert contract1;
        System.debug('contract1:' + contract1);

        Id pricebookId = Test.getStandardPricebookId();

        Product2 product2 = TestDataFactory.generateProduct('product1');
        insert product2;
        System.debug('product2:' + product2);

        PricebookEntry pbe = TestDataFactory.generatePriceBookEntry(pricebookId, product2.Id);
        pbe.UnitPrice = 1000;
        pbe.IsActive = true;
        pbe.UseStandardPrice = false;
        insert pbe;
        System.debug('pbe:' + pbe);

        List<Order> orderListToUpdate = new List<Order>();

        Order oldOrder1 = TestDataFactory.generateOrder(oldAccount.Id, contract1.Id);
        oldOrder1.Pricebook2Id = pricebookId;
        oldOrder1.ShipmentCost__c = 100;
        insert oldOrder1;
        System.debug('oldOrder1:' + oldOrder1);

        OrderItem orderItem1 = TestDataFactory.generateOrderItem(oldOrder1.Id, pbe.Id);
        orderItem1.Quantity = 10;
        orderItem1.UnitPrice = 150;
        insert orderItem1;
        System.debug('orderItem1:' + orderItem1);

        contract1.Status = 'Activated';
        update contract1;
        oldOrder1.Status = 'Activated';
        orderListToUpdate.add(oldOrder1);

        Order oldOrder2 = TestDataFactory.generateOrder(oldAccount.Id, contract1.Id);
        oldOrder2.Pricebook2Id = pricebookId;
        oldOrder2.ShipmentCost__c = 100;
        insert oldOrder2;
        System.debug('oldOrder2:' + oldOrder2);

        OrderItem orderItem2 = TestDataFactory.generateOrderItem(oldOrder2.Id, pbe.Id);
        orderItem2.Quantity = 10;
        orderItem2.UnitPrice = 150;
        insert orderItem2;
        System.debug('orderItem2:' + orderItem2);

        oldOrder2.Status = 'Activated';
        orderListToUpdate.add(oldOrder2);

        update orderListToUpdate;

        test.startTest();

        Database.executeBatch(new BatchUpdateSalesRevenues());

        Account accountDuringTest = [SELECT Id, Name, Chiffre_affaire__c FROM Account WHERE Name =: 'oldAccount'];
        System.debug('accountDuringTest.Chiffre_affaire__c: ' + accountDuringTest.Chiffre_affaire__c);
        System.assertEquals(3000, accountDuringTest.Chiffre_affaire__c);

        oldOrder1.Status = 'Draft';
        oldOrder2.Status = 'Draft';

        update orderListToUpdate;

        delete orderListToUpdate;

        Test.stopTest();

        Account newAccount = [SELECT Id, Name, Chiffre_affaire__c FROM Account WHERE Name =: 'oldAccount'];
        System.debug('newAccount.Chiffre_affaire__c: ' + newAccount.Chiffre_affaire__c);
        System.assertEquals(0, newAccount.Chiffre_affaire__c);
    }
}