import Server "../lib";
import Assets "mo:assets";
import T "mo:assets/Types";
import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Trie "mo:base/Trie";
import Debug "mo:base/Debug";
import Blob "mo:base/Blob";
import serdeJson "mo:serde/JSON";
import Buffer "mo:base/Buffer";
import List "mo:base/List";
import HttpParser "mo:http-parser.mo";
import Iter "mo:base/Iter";
import Type "mo:candid/Type";

import ContactView "../Views/Contact/list";
import ContactModel "../contact";

module {
    type Request = Server.Request;
    type Response = Server.Response;
    type HttpRequest = Server.HttpRequest;
    type HttpResponse = Server.HttpResponse;
    type ResponseClass = Server.ResponseClass;
 
    type ContactType = {
        name : Text;
        email : Text;
        imgUrl : Text;
        title : Text;
        state : Text;
    };


    // Returns an error

    let Contact = actor "../Contact" : actor {
        newContact : (Text, Text, Text, Text, Text ) -> async (Text);
        getContactList: () -> async ([ContactType]);
    }; 


    public func route(server : Server.Server) {
        // Views - List of contacts
       
        server.get(  
            "/contact/list", func(req : Request, res : ResponseClass) : Response {  

                
                let a = Contact.getContactList;

                //let result :[ContactType] = Contact.getContactStorage(0);

                Debug.print("4- VIEW CONTACT INDEX");
                let zz = getViewContact(req, res, []);
            }
        );

        server.get(  
            "/contact", func(req : Request, res : ResponseClass) : Response { 
                 Debug.print("1-GET");
                getContact(req : Request, res : ResponseClass)
            }
        );


        server.post(  
            "/contact", func(req : Request, res : ResponseClass) : Response {


                // NEED TO SAVE THE DATA
                Debug.print("2-POST");
                postContact(req : Request, res : ResponseClass);
                return {
                    status_code = 201;
                    headers = [("Content-Type", "text/html")];
                    body = Text.encodeUtf8("<div hx-get=\"http://localhost:4943/contact/list?canisterId=be2us-64aaa-aaaaa-qaabq-cai\" hx-trigger=\"load\" hx-target=\"#outer\" hx-swap=\"innerHTML\"></div>");
                    streaming_strategy = null;
                    cache_strategy = #noCache;
                };
            }
        );

        server.put(  
            "/contact", func(req : Request, res : ResponseClass) : Response {
                 Debug.print("3-PUT");
                var resp = putContact(req : Request, res : ResponseClass);
                return {
                    status_code = 201;
                    headers = [("Content-Type", "text/html")];
                    body = Text.encodeUtf8("<div hx-get=\"http://localhost:4943/contact?canisterId=be2us-64aaa-aaaaa-qaabq-cai\"></div>");
                    streaming_strategy = null;
                    cache_strategy = #noCache;
                };
            },
        );

       

        // Views - Consult a contact
        server.get(  
            "/view/contact/show", func(req : Request, res : ResponseClass) : Response {
                Debug.print("5--- VIEW CONTACT SHOW");
                getViewContactShow(req : Request, res : ResponseClass)
            }
        );

        // Views - Edit a contact
        server.get(  
            "/view/contact/edit", func(req : Request, res : ResponseClass) : Response { 
                let Contact = actor "Contact": actor {
                    newContact : (Text, Text, Text, Text, Text ) -> async (Text);
                    getContactList: (Nat) -> async (List.List<ContactType>);
                };

                var contact = Contact.getContactStorage;


                Debug.print("6--- VIEW CONTACT EDIT");
                getViewContact(req, res, [] );
            }
        );


    };

    public func getViewContact(req : Request, res : ResponseClass, contact : [ContactType]) : Response {
        
        // Get data to insert into the template
        // var contactStorage = ContactStorage.getContactStorage(0);



        // Get the template from the file in the  folder
        var template = ContactView.templateContact(contact);    
       

        res.send({
            status_code = 200;
            headers = [("Content-Type", "text/html")];
            body = Text.encodeUtf8(template);
            streaming_strategy = null;
            cache_strategy = #noCache;
        });
    };



    public func getContact(req : Request, res : ResponseClass) : Response {

        // Get data to insert into the template


        // Insert the view into the template
        var template = "";

        res.send({
            status_code = 200;
            headers = [("Content-Type", "text/html")];
            body = Text.encodeUtf8(template);
            streaming_strategy = null;
            cache_strategy = #noCache;
        });
    };


    public func getViewContactShow(req : Request, res : ResponseClass) : Response {
        Debug.print("We have GET VIEW FORM");

        var template = ""; // We need to get the formShow.html template
        res.send({
            status_code = 200;
            headers = [("Content-Type", "text/html")];
            body = Text.encodeUtf8(template);
            streaming_strategy = null;
            cache_strategy = #noCache;
        });
    };


    func processContact(data : Text) : ?ContactType {
        let blob = serdeJson.fromText(data);
        from_candid (blob);
    };

    public func postContact(req : Request, res : ResponseClass) : () {
        var body = "";
       
        let obj = req.headers;
        let keys = Iter.fromArray(obj.keys);
  
        let sec : ContactType= {
            name = "John Wood";
            email = "john.wood@example.com";
            imgUrl = "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80";                                      
            title = "Ceo";
            state = "online";
        };
    
        //let a = ContactModel.Contact.newContact(sec);
        
        Debug.print("9.9.9 POST is saved");
    };
       
    public func putContact(req : Request, res : ResponseClass) : Response {
        var greeting = "We have PUT CONTACT return 200";
        res.send({
            status_code = 200;
            headers = [("Content-Type", "text/html")];
            body = Text.encodeUtf8(greeting);
            streaming_strategy = null;
            cache_strategy = #noCache;
        });
    };
};






 /* 
    // search for params in the body

            switch (req.body) {
                case (?body) {
                    var form = body.form;


                     for (key in form.keys()) {
                                let value = obj.get(key);
                                
                                switch value {
                                case null {};
                                    case (?value) {
                                        Debug.print("Key: " # key);
                                        let value2 = Iter.fromArray(value);
                                        for (val in value2) {
                                            Debug.print("Value: " # val);
                                        };
                                    
                                    };
                                };
                    }; 


                    Debug.print("Name: "  # "");
                };
                case null {};
            };



 */