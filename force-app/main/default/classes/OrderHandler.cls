/**
* @author:		 Frédéric VO
* @date:		 19/10/2020
* @description:	 OrderHandler Handler trigger by OrderTrigger on Order Object.
*
*/
public with sharing class OrderHandler {

    public static void calcSalesRevenuesAccount(List<Order> newOrders, Map<Id,Order> oldMapOrders){
        Decimal SalesRevenue = 0;
        Set<Id> accountSetIds = new Set<Id>();

        for(Order newOrder : newOrders){
            if(Trigger.isInsert || Trigger.isDelete){
                if(newOrder.AccountId != null) {
                    accountSetIds.add(newOrder.AccountId);
                }
            } else if(Trigger.isUpdate){
                if(newOrder.Status != oldMapOrders.get(newOrder.Id).Status){
                    if(newOrder.AccountId != null){
                        accountSetIds.add(newOrder.AccountId);
                    }
                }
            }
        }

        List<Account> accountListToUpdate = new List<Account>([SELECT Id,Name,Chiffre_affaire__c,
                                                                (SELECT Id,TotalAmount FROM Orders WHERE Status = 'Activated')
                                                                FROM Account
                                                                WHERE Id IN : accountSetIds]);
        if(accountListToUpdate.size() > 0){
            for(Account account : accountListToUpdate){
                List<Order> orderListWithAccountIds = new List<Order>();
                orderListWithAccountIds = account.Orders;

                if(orderListWithAccountIds.size() > 0){
                    for(Order order : orderListWithAccountIds){
                        SalesRevenue += order.TotalAmount;
                    }
                    account.Chiffre_affaire__c = SalesRevenue;
                } else {
                    account.Chiffre_affaire__c = 0;
                }
            }
            update accountListToUpdate;
        }
    }
}