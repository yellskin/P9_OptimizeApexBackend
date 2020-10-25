/**
* @author:		 Frédéric VO
* @date:		 19/10/2020
* @description:	 Test of OrderHandler
*
*/
@isTest
private class OrderHandlerTEST {

    /*
    Test calculating CA when update
    */
    @isTest static void testcalcSalesRevenuesAccountUpdate(){
        Account oldAccount = TestDataFactory.generateAccount('oldAccount');
        insert oldAccount;
        System.debug('oldAccount:' + oldAccount);
        System.assertEquals(null, oldAccount.Chiffre_affaire__c);

        Contract contract1 = TestDataFactory.generateContract(oldAccount.Id);
        insert contract1;
        System.debug('contract1:' + contract1);

        Id pricebookId = Test.getStandardPricebookId();

        Order oldOrder = TestDataFactory.generateOrder(oldAccount.Id, contract1.Id);
        oldOrder.Pricebook2Id = pricebookId;
        oldOrder.ShipmentCost__c = 100;
        insert oldOrder;
        System.debug('oldOrder:' + oldOrder);

        Product2 product2 = TestDataFactory.generateProduct('product1');
        insert product2;
        System.debug('product2:' + product2);

        PricebookEntry pbe = TestDataFactory.generatePriceBookEntry(pricebookId, product2.Id);
        pbe.UnitPrice = 1000;
        pbe.IsActive = true;
        pbe.UseStandardPrice = false;
        insert pbe;
        System.debug('pbe:' + pbe);

        OrderItem orderItem1 = TestDataFactory.generateOrderItem(oldOrder.Id, pbe.Id);
        orderItem1.Quantity = 10;
        orderItem1.UnitPrice = 150;
        insert orderItem1;
        System.debug('orderItem1:' + orderItem1);

        contract1.Status = 'Activated';
        oldOrder.Status = 'Activated';

        test.startTest();
        update contract1;
        update oldOrder;
        test.stopTest();

        Order newOrder = [SELECT Id, AccountId, NetAmount__c FROM Order WHERE AccountId =: oldAccount.Id];
        System.debug('newOrder.NetAmount__c: ' + newOrder.NetAmount__c);
        System.assertEquals(1400, newOrder.NetAmount__c);

        Account newAccount = [SELECT Id, Name, Chiffre_affaire__c FROM Account WHERE Name =: 'oldAccount'];
        System.debug('newAccount.Chiffre_affaire__c: ' + newAccount.Chiffre_affaire__c);
        System.assertEquals(1500, newAccount.Chiffre_affaire__c);
        }

    /*
    Test calculating CA when delete
    */
    @isTest static void testcalcSalesRevenuesAccountDelete(){
        Account oldAccount = TestDataFactory.generateAccount('oldAccount');
        insert oldAccount;
        System.debug('oldAccount:' + oldAccount);
        System.assertEquals(null, oldAccount.Chiffre_affaire__c);

        Contract contract1 = TestDataFactory.generateContract(oldAccount.Id);
        insert contract1;
        contract1.Status = 'Activated';
        update contract1;
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
        Order oldOrder = TestDataFactory.generateOrder(oldAccount.Id, contract1.Id);
        oldOrder.Pricebook2Id = pricebookId;
        oldOrder.ShipmentCost__c = 100;
        insert oldOrder;
        System.debug('oldOrder:' + oldOrder);

        OrderItem orderItem1 = TestDataFactory.generateOrderItem(oldOrder.Id, pbe.Id);
        orderItem1.Quantity = 10;
        orderItem1.UnitPrice = 150;
        insert orderItem1;
        System.debug('orderItem1:' + orderItem1);

        OrderItem orderItem2 = TestDataFactory.generateOrderItem(oldOrder.Id, pbe.Id);
        orderItem2.Quantity = 20;
        orderItem2.UnitPrice = 1000;
        insert orderItem2;
        System.debug('orderItem2:' + orderItem2);

        orderListToUpdate.add(oldOrder);

        contract1.Status = 'Activated';
        oldOrder.Status = 'Activated';
        Test.startTest();
        update contract1;
        update oldOrder;
        Account accountDuringTest = [SELECT Id, Name, Chiffre_affaire__c FROM Account WHERE Name =: 'oldAccount'];
        System.debug('accountDuringTest.Chiffre_affaire__c: ' + accountDuringTest.Chiffre_affaire__c);
        System.assertEquals(21500, accountDuringTest.Chiffre_affaire__c);
        oldOrder.Status = 'Draft';
        update oldOrder;
        delete orderListToUpdate;

        Test.stopTest();

        Account newAccount = [SELECT Id, Name, Chiffre_affaire__c FROM Account WHERE Name =: 'oldAccount'];
        System.debug('newAccount.Chiffre_affaire__c: ' + newAccount.Chiffre_affaire__c);
        System.assertEquals(0, newAccount.Chiffre_affaire__c);
    }
}