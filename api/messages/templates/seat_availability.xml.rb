SeatAvailabilityRS(namespaces) {
  Document {
    Name name
    MessageVersion version
  }
  Success {}
  cabins.each{ |cabin|
    Flights {
      FlightSegmentReferences cabin.segment_key
      Cabin {
        Code "M"
        Definition cabin.definition
        SeatDisplay {
          cabin.columns.split(",").each{ |col|
            Columns col
          }
          Rows{
            First cabin.rows_first
            Last cabin.rows_last
          }
        }
      }
    }
  }
  #DataLists {
    #FlightSegmentList flight_segment_list
  #}
  ServiceList {
    services.each{ |service|
      Service(ObjectKey: service.service_id){
        ServiceID(Owner: service.airline.code){ text service.id }
        Name service.name
        Encoding ""
        FeeMethod "OC"
        Descriptoins {
          Descriptoin {
            Text service.description_text
            Link service.description_link
            Media {
              ObjectID service.description_object_id
            }
          }
        }
        Settlement {
          Method {
            Code service.settlement_code
            Definition service.settlement_definition
          }
        }
        Price {
          Total service.price_total
          PassengerReferences service.price_passanger_reference
        }

      }
      Asociations {
        Flight{
          SegmentReferences service.segment_key
        }
      }
    }
  }
  SeatList{
    seats.each{|seat|
      Seats(refs: "SV1 SV2 SV3 SV4", ListKey: seat.list_key){
        Location {
          Column seat.column
          Row{
            Number seat.row
          }
          Characteristics{
            seat.characteristic.split(",").each{ |charac|
              Characteristic{
                Code charac
              }
            }
          }
        }
      }
    }
  }
}
