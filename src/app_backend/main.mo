import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Random "mo:base/Random";
import Array "mo:base/Array";



actor RealEstateOwner {
  type Owner = {
    id: Principal;
    name: Text;
    email: Text;
    address: Text;
    phone: Text;
  };

  type Property = {
    id: Nat;
    title: Text;
    address: Text;
    description: Text;
    price: Float;
    images: [Text];
  };

  type Business = {
    id: Principal;
    name: Text;
    email: Text;
    address: Text;
    phone: Text;
    owners: [Owner];
    properties: [Property];
  };
  
  var owners = HashMap.HashMap<Principal, Owner>(1, Principal.equal, Principal.hash);

  public func createOwner(name: Text, email: Text, address: Text, phone: Text) : async Principal {
    var num = Principal.fromBlob(await Random.blob());
    let newOwner: Owner = {  
      id = num;  
      name = name;
      email = email;
      address = address;
      phone = phone;
      properties = [];
    };
    owners.put(newOwner.id, newOwner);
    return newOwner.id;
  };

  public func getOwner(ownerId: Principal) : async ?Owner {
    return owners.get(ownerId);
  };

  public func updateOwner(ownerId: Principal, name: Text, email: Text, address: Text, phone: Text) : async Bool {
    switch (owners.get(ownerId)) {
      case (null) { return false; };
      case (?owner) {
        let updatedOwner: Owner = {
          id = ownerId;
          name = name;
          email = email;
          address = address;
          phone = phone;
          properties = owner.id;
        };
        owners.put(ownerId, updatedOwner);
        return true;
      };
    };
  };


  public func addProperty(ownerId: Principal, owner: Owner) : async Bool {
  switch (owners.get(ownerId)) {
    case (null) { return false; };
    case (?owner) {
      let updatedOwner: Owner = {
        id = owner.id;
        name = owner.name;
        email = owner.email;
        address = owner.address;
        phone = owner.phone;
        properties = [];
      };
      owners.put(ownerId, updatedOwner);
      return true;
    };
  };
};

  public func updateProperty(ownerId: Principal, property: Property) : async Bool {
    switch (owners.get(ownerId)) {
      case (null) { return false; };
      case (?owner) {
         /* let updatedProperties = Array.filter<Property>(owner.properties, func (p: Property) : Bool {
          return p.id != propertyId;
        });
        owner.properties := updatedProperties; */
        owners.put(ownerId, owner);
        return true;
      };
    };
  };
};
