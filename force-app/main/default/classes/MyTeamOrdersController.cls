/**
* @author:		 Frédéric VO
* @date:		 19/10/2020
* @description:	 Controller which calculate commercial's yield
* Link with MyTeamOrders
*
*/
public with sharing class MyTeamOrdersController {
    private Account currentAccount {get; set;}
    public MyTeamOrdersController(ApexPages.StandardController stdController) {
        this.currentAccount = [SELECT Id
                                FROM Account
                                WHERE Id=:stdController.getId()
                                LIMIT 1];
    }

    public Map<String,Decimal> SumOders{
        get{
            Map<String, Decimal> ordersWithOwner = new Map<String,Decimal>();
            Map<Id, Decimal> ordersFromOwnerId = new Map<Id,Decimal>();

            AggregateResult [] groupedResults = [SELECT OwnerId, SUM(TotalAmount) total FROM Order WHERE Status='Activated' GROUP BY OwnerId];
            for(AggregateResult ar: groupedResults) {
                ordersFromOwnerId.put((Id)ar.get('OwnerId'), (decimal)ar.get('total'));
            }
            List<User> ownerOrder = [SELECT Id, Name FROM User WHERE Id IN: ordersFromOwnerId.keySet()];
            for(User u: ownerOrder) {
                ordersWithOwner.put(u.Name, ordersFromOwnerId.get(u.Id));
            }
            return ordersWithOwner;
        }
        set;
    }

}