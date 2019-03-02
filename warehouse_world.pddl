(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
   )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   (:action robotMove
      :parameters (?r - robot ?l - location ?l2 - location)
      :precondition (and (free ?r) (no-robot ?l2) (at ?r ?l) (connected ?l2 ?l))
      :effect (and (not (no-robot ?l2)) (not (at ?r ?l)) (no-robot ?l) (at ?r ?l2))
   )
   (:action robotMoveWithPallette
      :parameters (?r - robot ?p - pallette ?l - location ?l2 - location)
      :precondition (and (no-robot ?l2) (no-pallette ?l2) (at ?r ?l) (at ?p ?l) (connected ?l2 ?l))
      :effect (and (not (no-robot ?l2)) (not (no-pallette ?l2))(not (at ?r ?l))(not (at ?p ?l)) (no-robot ?l) (no-pallette ?l) (at ?r ?l2)(at ?p ?l2))
   )
   (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?s - shipment ?si - saleitem ?p - pallette ?o - order)
      :precondition (and (packing-location ?l) (at ?p ?l) (contains ?p ?si)(packing-at ?s ?l)(started ?s)(not (complete ?s))(not(includes ?s ?si))(orders ?o ?si)(ships ?s ?o))
      :effect (and (not(contains ?p ?si))(includes ?s ?si))
   )
    (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (packing-at ?s ?l)(started ?s)(not (complete ?s))(ships ?s ?o))
      :effect (and (complete ?s) (available ?l))
   )
)
