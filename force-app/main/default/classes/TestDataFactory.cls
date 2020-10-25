/**
* @author:		 Frédéric VO
* @date:		 19/10/2020
* @description:	 Create data for test class
*
*/
public with sharing class TestDataFactory {
    public static Account generateAccount(String name){
        Account account = new Account();
        account.Name = name;

        return account;
    }

    public static Contract generateContract(Id accountId){
        Contract contract = new Contract();
        contract.AccountId = accountId;
        contract.Status = 'Draft';
        contract.StartDate = Date.newInstance(2020, 10, 05);
        contract.ContractTerm = 5;

        return contract;
    }

    public static Order generateOrder(Id accountId, Id contractId){
        Order order = new Order();
        order.AccountId = accountId;
        order.contractId = ContractId;
        order.Status = 'Draft';
        order.EffectiveDate = Date.newInstance(2020, 10, 06);

        return order;
    }

    public static Product2 generateProduct(String name){
        Product2 product2 = new Product2();
        product2.Name = name;
        product2.Family = 'Phone';

        return product2;
    }

    public static PricebookEntry generatePriceBookEntry(Id pricebook2Id, Id product2Id){
        PricebookEntry priceBookEntry = new PricebookEntry();
        priceBookEntry.Pricebook2Id = pricebook2Id;
        priceBookEntry.Product2Id = product2Id;

        return priceBookEntry;
    }

    public static OrderItem generateOrderItem(Id orderId, Id pricebookEntryId){
        OrderItem orderItem = new OrderItem();
        orderItem.OrderId = orderId;
        orderItem.PricebookEntryId = pricebookEntryId;

        return orderItem;
    }

    public static User generateUser(String lastName, String profile, UserRole role){
        Profile userProfile = [SELECT Id FROM Profile WHERE Name =: profile];

        User user = new User();
        user.LastName = lastName;
        user.FirstName = 'Test';
        user.Alias = 'A-'+lastName;
        user.Email = lastName + User.Alias + '@test.com';
        user.Username = lastName + '@test.com';
        user.CommunityNickname = 'nickName'+lastName;
        user.ProfileId = userProfile.Id;
		user.UserRoleId  = role.Id;
		user.isActive = true;
		user.TimeZoneSidKey = 'GMT';
		user.LanguageLocaleKey = 'en_US';
		user.LocaleSidKey = 'en_US';
        user.EmailEncodingKey = 'UTF-8';

        return user;
    }
}