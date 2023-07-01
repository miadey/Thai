import Server "lib";
import Assets "mo:assets";
import Nat "mo:base/Nat";
import List "mo:base/List";
import T "mo:assets/Types";
import Blob "mo:base/Blob";
import Debug "mo:base/Debug";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import HttpParser "mo:http-parser.mo";
import Nat8 "mo:base/Nat8";
import serdeJson "mo:serde/JSON";

import ContactStorage "contact";
import ContactView "Views/Contact/list";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Int "mo:base/Int";
import Time "mo:base/Time";
import Trie "mo:base/Trie";
import AssetCanister "canister:app_frontend";

shared ({ caller = creator }) actor class Main () {
 
  Debug.print("0-***** Initialize application ****");
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

  stable var contactStorage : [ContactType]=[];
  stable var serializedEntries : Server.SerializedEntries = ([], [], [creator]);

  var server = Server.Server({ serializedEntries });
  let assets = server.assets;
  
  let b : {
    content : Blob;
    content_encoding : Text;
    content_type : Text;
    sha256 : ?Blob;
    total_length : Nat;
  } = await AssetCanister.get(["text/html"], "/index.html");

  let c = b.content;

 

  stable var files = Trie.empty<Text, Blob>();
  func key(x : Text) : Trie.Key<Text> { { key = x; hash = Text.hash(x) } };

  func newContact(cont : ContactType) : () {

        let sec : ContactType= {
            name = cont.name;
            email = cont.email;
            imgUrl = cont.imgUrl;                                      
            title = cont.title;
            state = cont.state;
        };
    
        contactStorage := Array.append([sec],contactStorage);
    };  


    func getViewContact(req : Request, res : ResponseClass) : Response  {
        
        // Get data to insert into the template
        // var contactStorage = ContactStorage.getContactStorage(0);



        // Get the template from the file in the  folder
        var template = ContactView.templateContact(contactStorage);    
       

        res.send({
            status_code = 200;
            headers = [("Content-Type", "text/html")];
            body = Text.encodeUtf8(template);
            streaming_strategy = null;
            cache_strategy = #noCache;
        });
    };

    func getContact(req : Request, res : ResponseClass) : Response {

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

    func getViewContactShow(req : Request, res : ResponseClass) : Response {

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

    func postContact(req : Request, res : ResponseClass) : () {
        var name =  getHeaderParam(req, "name");
        var email =  getHeaderParam(req, "email");
        var imgUrl =  getHeaderParam(req, "imgUrl");
        var title =  getHeaderParam(req, "title");
        var state =  getHeaderParam(req, "state");

        let sec : ContactType = {
            name = name;
            email = email;
            imgUrl = "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=512&h=512&q=80";                                      
            title = title;
            state = state;
        };
    
        //let a = ContactModel.Contact.newContact(sec);
        contactStorage := Array.append([sec],contactStorage);
        Debug.print("9.9.9 POST is saved");
    };
       
    func putContact(req : Request, res : ResponseClass) : Response {
        var greeting = "We have PUT CONTACT return 200";
        res.send({
            status_code = 200;
            headers = [("Content-Type", "text/html")];
            body = Text.encodeUtf8(greeting);
            streaming_strategy = null;
            cache_strategy = #noCache;
        });
    };

    func getHeaderParam(req : Request, param : Text) : Text {
      let z = req.body;
      var name = "";
      switch (z) {
        case (null)
          {
            Debug.print("z is null");
            let cName = "null";
          };
        case (?z) {
          switch (z.form.get(param)) {
            case (null)
              {
                Debug.print("cName is null");
              };
            case (?cName) {
              Debug.print(debug_show(cName));
              name := cName[0];
            };
          };

        };

       };
      name
    };



//
// Add route for each controller
//  

        // Views - List of contacts
       
        server.get(  
            "/contact/list", func(req : Request, res : ResponseClass) : Response {  
             
                //let result :[ContactType] = Contact.getContactStorage(0);
                
                var template = ContactView.templateContact(contactStorage);    
              
                return {
                    status_code = 201;
                    headers = [("Content-Type", "text/html")];
                    body = Text.encodeUtf8(template);
                    streaming_strategy = null;
                    cache_strategy = #noCache;
                };
               
            }
        );

        server.get(  
            "/contact", func(req : Request, res : ResponseClass) : Response { 
                 Debug.print("1-GET");
                getContact(req , res)
            }
        );

        server.post(  
            "/contact", func(req : Request, res : ResponseClass) : Response {

                var body = "";
       
                let obj = req.headers;
                let keys = Iter.fromArray(obj.keys);
          
                // NEED TO SAVE THE DATA
                Debug.print("2-POST");
                postContact(req : Request, res : ResponseClass);
                return {
                    status_code = 201;
                    headers = [("Content-Type", "text/html")];
                    body = Text.encodeUtf8("<div hx-get=\"http://localhost:4943/contact/list?canisterId=bd3sg-teaaa-aaaaa-qaaba-cai\" hx-trigger=\"load\" hx-target=\"#outer\" hx-swap=\"innerHTML\"></div>");
                    streaming_strategy = null;
                    cache_strategy = #noCache;
                };
            }
        );

        server.put(  
            "/contact", func(req : Request, res : ResponseClass) : Response {
                 Debug.print("3-PUT");
                var resp = putContact(req, res);
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

                Debug.print("6--- VIEW CONTACT EDIT");
                getViewContact(req, res);
            }
        );

      
      

   
  public shared ({ caller }) func authorize(other : Principal) : async () {
    server.authorize({
      caller;
      other;
    });
  };

  public query func retrieve(path : Assets.Path) : async Assets.Contents {
    assets.retrieve(path);
  };

  public shared ({ caller }) func store(
    arg : {
      key : Assets.Key;
      content_type : Text;
      content_encoding : Text;
      content : Blob;
      sha256 : ?Blob;
    }
  ) : async () {
    server.store({
      caller;
      arg;
    });
  };

  public query func list(arg : {}) : async [T.AssetDetails] {
    assets.list(arg);
  };

  public query func get(
    arg : {
      key : T.Key;
      accept_encodings : [Text];
    }
  ) : async ({
    content : Blob;
    content_type : Text;
    content_encoding : Text;
    total_length : Nat;
    sha256 : ?Blob;
  }) {
    assets.get(arg);
  };

  public shared ({ caller }) func create_batch(arg : {}) : async ({
    batch_id : T.BatchId;
  }) {
    assets.create_batch({
      caller;
      arg;
    });
  };

  public shared ({ caller }) func commit_batch(args : T.CommitBatchArguments) : async () {
    assets.commit_batch({
      caller;
      args;
    });
  };

  public shared ({ caller }) func create_asset(arg : T.CreateAssetArguments) : async () {
    assets.create_asset({
      caller;
      arg;
    });
  };

  public shared ({ caller }) func set_asset_content(arg : T.SetAssetContentArguments) : async () {
    assets.set_asset_content({
      caller;
      arg;
    });
  };

  public shared ({ caller }) func unset_asset_content(args : T.UnsetAssetContentArguments) : async () {
    assets.unset_asset_content({
      caller;
      args;
    });
  };

  public shared ({ caller }) func delete_asset(args : T.DeleteAssetArguments) : async () {
    assets.delete_asset({
      caller;
      args;
    });
  };

  public shared ({ caller }) func clear(args : T.ClearArguments) : async () {
    assets.clear({
      caller;
      args;
    });
  };

  public type StreamingStrategy = {
    #Callback : {
      callback : shared query StreamingCallbackToken -> async StreamingCallbackHttpResponse;
      token : StreamingCallbackToken;
    };
  };

  public type StreamingCallbackToken = {
    key : Text;
    content_encoding : Text;
    index : Nat;
    sha256 : ?Blob;
  };

  public type StreamingCallbackHttpResponse = {
    body : Blob;
    token : ?StreamingCallbackToken;
  };

  public query func http_request_streaming_callback(token : T.StreamingCallbackToken) : async StreamingCallbackHttpResponse {
    assets.http_request_streaming_callback(token);
  };
  
  
  public query func http_request(req : HttpRequest) : async HttpResponse {
    server.http_request(req);
  };



  public func http_request_update(req : HttpRequest) : async HttpResponse {
    server.http_request_update(req);
  };

  /*
     * upgrade hooks
     */
  system func preupgrade() {
    serializedEntries := server.entries();
  };

  system func postupgrade() {
    ignore server.cache.pruneAll();
  };

//======================================================================================================================
/// Custom code : M.Adey 2023-06-23


 public shared func testing(): async Nat32 {
    0
  };


/// TODO - Test code for assets entries
  Debug.print("0- TODO - Assets entries tests");

  // TODO - Test code for assets entries ) ;
  /* for (asset in assets.assets.vals()) {
    Debug.print(" --- " # debug_show(asset.toStableAsset()));
  }; */

  Debug.print(debug_show(assets.assets.size()));

  for (asset in assets.assets.vals()) {
    Debug.print(" --- " # debug_show(asset.toStableAsset()));
  };

  for ((key, asset) in assets.assets.entries()) {
    Debug.print(key # debug_show(asset.contentType));
    for (encEntry in asset.encodingEntries()) {
      Debug.print(" --- " # debug_show(encEntry));
    };
  };
  Debug.print("0- END");
};



