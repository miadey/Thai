import Debug "mo:base/Debug";
import Array "mo:base/Array";

module {

    type ContactType = {
        name : Text;
        email : Text;
        imgUrl : Text;
        title : Text;
        state : Text;
    };
    
    func newContact(cont : ContactType, contactStorage : [ContactType]) : async [ContactType] {
        let ContactToAdd : ContactType = {
            name = cont.name;
            email = cont.email;
            imgUrl = cont.imgUrl;                                      
            title = cont.title;
            state = cont.state;
        };

        //contactStorage := List.push(ContactToAdd, contactStorage);
        Array.append([ContactToAdd],contactStorage);
    };   

    func getContactList(page : Nat8,contactStorage : [ContactType]) : async [ContactType] {
        Debug.print("*** function getContactList");
        contactStorage;
    };
    
    func getContact(search : Text, contactStorage : [ContactType]) : async ContactType {
        Debug.print("*** function getContact");
        contactStorage[0];
    };
};