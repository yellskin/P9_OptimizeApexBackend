/**
* @author:		 Frédéric VO
* @date:		 19/10/2020
* @description:	 Test class named MyTeamOrdersController
*
*/

/*
Test that controller calculate sum of accounts' Sales revenues from a team
*/
@isTest
private class MyTeamOrdersControllerTEST {

    @isTest static void testSumOders(){

        UserRole userRole1 = [SELECT Id FROM UserRole WHERE DeveloperName='ManagerEU'];

        User user1 = TestDataFactory.generateUser('Dupont', 'ManagerEU', userRole1);
        insert user1;
        System.debug('user1:'+user1);

        Map<String, Decimal> ordersWithOwner = new Map<String,Decimal>();
        Map<Id, Decimal> ordersFromOwnerId = new Map<Id,Decimal>();

        System.runAs(user1) {
            Account account1 = TestDataFactory.generateAccount('account1');
            insert account1;
            System.debug('account1.Owner:'+account1.Owner);

            Contract contract1 = TestDataFactory.generateContract(account1.Id);
            insert contract1;
            System.debug('contract1:' + contract1);

            Id pricebookId = Test.getStandardPricebookId();

            Order order1 = TestDataFactory.generateOrder(account1.Id, contract1.Id);
            order1.Pricebook2Id = pricebookId;
            insert order1;
            System.debug('order1:' + order1);

            Product2 product2 = TestDataFactory.generateProduct('product2');
            insert product2;
            System.debug('product2:' + product2);

            PricebookEntry pbe = TestDataFactory.generatePriceBookEntry(pricebookId, product2.Id);
            pbe.UnitPrice = 1000;
            pbe.IsActive = true;
            pbe.UseStandardPrice = false;
            insert pbe;
            System.debug('pbe:' + pbe);

            OrderItem orderItem1 = TestDataFactory.generateOrderItem(order1.Id, pbe.Id);
            orderItem1.Quantity = 10;
            orderItem1.UnitPrice = 150;
            insert orderItem1;
            System.debug('orderItem1:' + orderItem1);

            contract1.Status = 'Activated';
            order1.Status = 'Activated';

            update contract1;
            update order1;
            System.debug('contract1.Status:'+contract1.Status);
            System.debug('order1.Status:'+order1.Status);

            Test.startTest();
            PageReference pageRef = Page.MyTeamOrders;
            pageRef.getParameters().put('id', string.valueOf(account1.id));
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController std1 = new ApexPages.StandardController(account1);
            MyTeamOrdersController controller = new MyTeamOrdersController(std1);
            Map<String,Decimal> totalOrders = controller.SumOders;
            Test.stopTest();

            System.assertEquals(1500, totalOrders.get('Test Dupont'));
            System.debug('totalOrders.get(Test Dupont): ' + totalOrders.get('Test Dupont'));
        }
    }
}