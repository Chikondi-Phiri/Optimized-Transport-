import Int "mo:base/Int";
import TrieMap "mo:base/TrieMap";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import _HashMap "mo:base/HashMap";
import Result "mo:base/Result"; // Importing the Result module

actor TransportationSystem {

  type Bus = {
    nrcNumber : Text;
    driversId : Text;
    busPlateNumber : Text;
    route : Text;
    coOperator : Text;
  };

  var buses = TrieMap.TrieMap<Text, Bus>(Text.equal, Text.hash);
  stable var busEntries: [(Text, Bus)] = [];

  system func preupgrade() {
    busEntries := Iter.toArray(buses.entries());
  };

  system func postupgrade() {
    buses := TrieMap.fromEntries(busEntries.vals(), Text.equal, Text.hash);
  };

  public shared func registerBus(args : Bus) : async () {
    buses.put(args.nrcNumber, args);
  };

  public shared query func getBus(nrcNumber : Text) : async Result.Result<Bus, Text> {
    switch (buses.get(nrcNumber)) {
      case (null) {
        return #err("Bus not found");
      };
      case (?bus) {
        return #ok(bus);
      };
    };
  };

  public shared func updateBus(args : Bus) : async () {
    buses.put(args.nrcNumber, args);
  };

  public shared func deleteBus(nrcNumber : Text) : async () {
    buses.delete(nrcNumber);
  };

  public shared query func getAllBuses() : async [Bus] {
    Iter.toArray(buses.vals());
  };

};