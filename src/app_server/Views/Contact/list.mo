import Server "../../lib";
import Assets "mo:assets";
import Debug "mo:base/Debug";
import List "mo:base/List";

module {

    type ContactType = {
        name : Text;
        email : Text;
        imgUrl : Text;
        title : Text;
        state : Text;
    };
    
    public func templateContact (contactStorage : [ContactType]) : Text {

       // let contactStorage = ContactStorage.getContactStorage(0);

    // we get the template from the assets
    var template = "<div class=\"container p-4 mx-auto mt-2\">" #
        "<button  hx-get=\"/views/contact/formAdd.html\" hx-target=\"#outer\" hx-swap=\"innerHTML\" class=\"bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded\">" #
        "           Add a new contact" #
        "         </button>" #
        "<h2>Contact List</h2>" #
        "<ul role=\"list\" class=\"divide-y divide-gray-100\">" ;

       for (contact in contactStorage.vals()) {
            Debug.print(contact.name);

            template := template # "<li class=\"flex justify-between gap-x-6 py-5 hover:bg-slate-50\">" #
                "<div class=\"flex gap-x-4\">" #
                    "<img class=\"h-12 w-12 flex-none rounded-full bg-gray-50\" src=\"" # contact.imgUrl # "\" alt=\"\">" #
                    "<div class=\"min-w-0 flex-auto\">" #
                        "<p class=\"text-sm font-semibold leading-6 text-gray-900\">" # contact.name # "</p>" #
                        "<p class=\"mt-1 truncate text-xs leading-5 text-gray-500\">" # contact.email # "</p>" #
                    "</div>" #
                "</div>" #
                "<div class=\"hidden sm:flex sm:flex-col sm:items-end\">" #
                    "<p class=\"text-sm leading-6 text-gray-900\">" # contact.title # "</p>" #
                    "<p class=\"mt-1 text-xs leading-5 text-gray-500\">Statut : <time datetime=\"2023-01-23T13:23Z\">" # contact.state # "</time></p>" #
                "</div>" # "</li>" ;
          }; 
        template := template # "</ul>" # "</div>";
        template;
    };
   
    
}


  