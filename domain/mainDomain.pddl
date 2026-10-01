;Header and description

(define (domain mainDomain)

;remove requirements that are not needed
(:requirements :universal-preconditions :existential-preconditions :strips :disjunctive-preconditions :typing :conditional-effects :negative-preconditions)

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
    ; land areas
    land 
    ; land types
    flat hilly mountainous explosive - areas
   ; personnel types
    commander engineer scienceOfficer pilot - personnel
   ; building types
    CommandCentre EngineeringBay - building
   ; mech types
    titanMech1 titanMech2 - mech
   ; attachment types
    driller surveyor manipulation - attachment
   ; kit types
     solarDeployment1 solarDeployment2 solarDeployment3 - kit
     habitatDeployment1 habitatDeployment2 habitatDeployment3 - kit
   ; core sample types
    ;coreSample1 coreSample2 - sample
)

; un-comment following line if constants are needed
;(:constants )

(:predicates ;todo: define predicates here
    
    ; land predicates
    (surveyedArea ?land - land)
    (hasDriller ?engineeringBay - EngineeringBay ?driller - driller)
    (isAdjacent ?lf - land ?lt - land)
    (isFlat ?f - land) 
    (isHilly ?h - land)
    (isMountainous ?lt - land)
    (isExplosive ?lt - land)
    (isLocation ?lf - land)
    (inLocation ?mech - mech ?area - land)
    (inRegion ?building - building ?area - land)

    ; mech and attachment predicates
    
    (isInside ?mech - mech ?p - pilot)
    (dockMech ?mech - mech  ?building - building)
    (isAttachedDriller ?attachment - attachment ?mech - mech)
    (mech1Attachment ?attachment - attachment ?mech - mech)
    (hasAttachment ?mech - mech)
    (docked ?mech - mech)
    ;(mech2Attachment ?attachment - attachment ?mech - mech)
    (hasPassenger ?mech - mech)
    (isAttachedSurveyor ?attachment - attachment ?mech - mech)
    (isAttachedManipulation ?attachment - manipulation ?mech - mech)
    (hasSample ?mech - mech ?land - land)
    (exploded ?mech - mech)
    ; building predicates
    (sampleAnalysed ?building - commandCentre ?landSample - land)
    (engineeringDoorEnter ?area - land ?building - building)
    (engineeringDoorLeave ?building - building ?area - land)
    (inBuilding ?person - personnel ?building - building)
    (inWorkshop ?person - engineer ?building - building)
    (isPassenger ?passenger - personnel ?mech - mech); building predicates
    ;(isCommandCentre ?building - building ?cc - land)
    ;(isEngineeringBay ?building - building ?eb - land)
    (hasSurveyor ?building - building ?surveyor - surveyor)
    (hasManipulation ?building - building ?manipulation - manipulation)
    ; people predicates
    (isCommander ?cmdr - commander)
    (isEngineer ?eng - engineer)
    (isScienceOfficer ?so - scienceOfficer)
    (isPilot ?p - pilot)
    (isBusy ?person - personnel)
    ; personnel location predicates
    (personnelLocation ?personnel - personnel ?lf - land)

)

; move person action
(:action move_person
    :parameters (
        ?lf  - land
        ?lt - land
        ?person - personnel
    )
    :precondition (and 
        (personnelLocation ?person ?lf)
        ;(not (isExplosive ?lt))
        (not (isMountainous ?lt))
        (or
            (isAdjacent ?lf ?lt)
            (isAdjacent ?lt ?lf)
            )
    ) 
    :effect (and 
        (personnelLocation ?person ?lt) 
        (not (personnelLocation ?person ?lf))
        )   
)

; entering a building
(:action enter_building
    :parameters (
        ?building - building
        ?person - personnel
        ?lf - land
    )
    :precondition (and
        (inRegion ?building ?lf)
        (personnelLocation ?person ?lf)
    )
    :effect (inBuilding ?person ?building)
    
)
(:action exit_building
    :parameters (
        ?building - building
        ?person - personnel
        ?lf - land
    )
    :precondition (and
        (inRegion ?building ?lf)
        (personnelLocation ?person ?lf)
    )
    :effect (not(inBuilding ?person ?building))
    
)
; docking mech action
(:action dock_mech
    :parameters (
        ?building - building
        ?mech - mech 
        ?lf - land 
        ?p - pilot
    )
    :precondition (and 
        ;(dockMech ?mech ?building)
        (not( exploded ?mech))
        (isInside ?mech ?p)
        (inRegion ?building ?lf)
        ;(inLocation ?mech ?lf)
        (inLocation ?mech ?lf)
        ;(engineeringDoorEnter ?lf ?building)
    )
    :effect(and
        ;(not (inLocation ?mech ?lf))
        (dockMech ?mech ?building)
        (docked ?mech)
    )
    )
       


; un-docking mech
(:action undockingMech
    :parameters (
        ?building - EngineeringBay
        ?mech - mech 
        ?lf - land 
        ?p - pilot
    )
    :precondition (and 
         (not( exploded ?mech))
        (isInside ?mech ?p)
        (dockMech ?mech ?building)
        (docked ?mech)
    )
    :effect (and
        (not (dockMech ?mech ?building))
        (not (docked ?mech))
    )
)

; move mech action 
(:action move_mech
    :parameters (
        ?lf - land 
        ?lt - land 
        ?p - pilot
        ?mech - mech
    )
    :precondition (and 
         (not( exploded ?mech))
        (isInside ?mech ?p) 
        (inLocation ?mech ?lf) 
        (not(docked ?mech))
        (not (isMountainous ?lt))
        (or
            (isAdjacent ?lf ?lt)
            (isAdjacent ?lt ?lf)
            )  
    )
    :effect (and 
        (personnelLocation ?p ?lt) 
        (inLocation ?mech ?lt) 
        (not (personnelLocation ?p ?lf)) 
        (not (inLocation ?mech ?lf)))
)

; pilot mech action
(:action pilot_mech
    :parameters (
        ?lf - land
        ?p - pilot
        ?mech - mech
        ?building - EngineeringBay
        ;?area - land
        ;?personnel - personnel
    )
    :precondition (and
         (not( exploded ?mech))
        (docked ?mech)
        (inBuilding ?p ?building)
        
    )
    :effect (and
        (isInside ?mech ?p)
        (not (inBuilding ?p ?building))
    )   
)

; add a passenger action
(:action EnterPassenger
    :parameters (
        ?lf - land
        ?p - pilot
        ?mech - mech
        ?passenger - personnel
    )
    :precondition (and
         (not( exploded ?mech))
        (not(hasPassenger ?mech))
        (not(isBusy ?passenger))
        (isInside ?mech ?p)
        (inLocation ?mech ?lf)
        (personnelLocation ?passenger ?lf)
        )
    
    :effect (and 
        (hasPassenger ?mech)
        (isPassenger ?passenger ?mech)
        (isBusy ?passenger)
        (not (personnelLocation ?passenger ?lf))
    )
)

; driller attached
(:action isAttachedDriller
    :parameters (
        ?engineer - engineer
        ?building - EngineeringBay
        ?driller - driller
        ;?attachment - attachment
        ?mech - mech
    )
    :precondition (and
         (not( exploded ?mech))
        (inBuilding ?engineer ?building)
        (dockMech ?mech ?building)
        (hasDriller ?building ?driller)
        (not (hasAttachment ?mech))

        ;(not (isAttachedDriller ?driller ?mech))
    )
    :effect (and
        (isAttachedDriller ?driller ?mech)        
        (not (hasDriller ?building ?driller))
        (hasAttachment ?mech)
    )
)

;surveyor attached
(:action isAttachedSurveyor
    :parameters (
        ?engineer - engineer
        ?building - EngineeringBay
        ?mech - mech
        ?surveyor - surveyor
    )
    :precondition (and
         (not( exploded ?mech))
        (inBuilding ?engineer ?building)
        (dockMech ?mech ?building)
        (hasSurveyor ?building ?surveyor)
        (not (hasAttachment ?mech))
    )
    :effect (and
        (isAttachedSurveyor ?surveyor ?mech) 
        (hasAttachment ?mech)
        
    )
)

; manipulation1 attached
(:action isAttachedManipulation1
    :parameters (
        ?engineer - engineer
        ?building - EngineeringBay
        ?mech - mech
      
        ?manipulation - manipulation
    )
    :precondition (and
         (not( exploded ?mech))
         (inBuilding ?engineer ?building)
        (dockMech ?mech ?building)
        (hasManipulation ?building ?manipulation)
        (not (hasAttachment ?mech))
       
     )
    :effect (and
        (isAttachedManipulation ?manipulation ?mech) 
        (hasAttachment ?mech)
        (not( hasManipulation ?building ?manipulation))
    )
)

(:action takeCoreSample
    :parameters (
        ?engineer - engineer
        ?scienceOfficer - scienceOfficer
        ?building - EngineeringBay
        ?mech - mech
        ?driller - driller
        ?drillArea - land
        ?p - pilot
    )
    :precondition (and
        (isHilly ?drillArea)
         (not( exploded ?mech))
        (isInside ?mech ?p)
        (isPassenger ?scienceOfficer ?mech)
        (isAttachedDriller ?driller ?mech)
        (inLocation ?mech ?drillArea)
        (not(isMountainous ?drillArea))
        
        )
    :effect 
       (hasSample ?mech ?drillArea)
        
    
)

(:action takeCoreSampleExplode
    :parameters (
        ?engineer - engineer
        ?scienceOfficer - scienceOfficer
        ?building - EngineeringBay
        ?mech - mech
        ?driller - driller
        ?drillArea - land
        ?p - pilot
    )
    :precondition (and
        (not( exploded ?mech))
        (isHilly ?drillArea)
        (isInside ?mech ?p)
        (isPassenger ?scienceOfficer ?mech)
        (isAttachedDriller ?driller ?mech)
        (inLocation ?mech ?drillArea)
        (not(isMountainous ?drillArea))
        (isExplosive ?drillArea)
        
        )
    :effect (exploded ?mech)
        

)


(:action exitPassenger
    :parameters (
        ?lc - land
        ?p - pilot
        ?mech - mech
        ?passenger - personnel
    )
    :precondition (and
        (isInside ?mech ?p)
        (hasPassenger ?mech)
        (isPassenger ?passenger ?mech)
        (isBusy ?passenger)
        (inLocation ?mech ?lc)
        )
    
    :effect (and 
        (not( isBusy ?passenger))
        (not (isPassenger ?passenger ?mech))
        (not (hasPassenger ?mech))
        (personnelLocation ?passenger ?lc)
    ))

(:action fix
    :parameters (
        ?engineer - engineer
        ?mech - mech
        ?lc - land
 
    )
    :precondition (and
        (exploded ?mech)
        (inLocation ?mech ?lc)
        (personnelLocation ?engineer ?lc)
        (not (isBusy ?engineer))

        
        )
    :effect (not(exploded ?mech))
        

)

(:action analyseCoreSample
    :parameters (
        ?scienceOfficer - scienceOfficer
        ?building - commandCentre
        ?mech - mech
        ?sampleArea - land
        ?p - pilot
        ?lc - land
    )
    :precondition (and
        (isInside ?mech ?p)
        (inBuilding ?scienceOfficer ?building)
        (personnelLocation ?scienceOfficer ?lc)
        (inLocation ?mech ?lc)
        (hasSample ?mech ?sampleArea)
        (not(exploded ?mech))
        
        )
    :effect (and
        (not(hasSample ?mech ?sampleArea))
        (sampleAnalysed ?building ?sampleArea)
        )
        

)


(:action surveyLand
    :parameters (

        ?mech - mech
        ?surveyLand - land
        ?p - pilot
        ?surveyor - surveyor
        
    )
    :precondition (and
        
        (isAttachedSurveyor ?surveyor ?mech)
        (isInside ?mech ?p)
        (inLocation ?mech ?surveyLand)
        (not(exploded ?mech))
        (not (isMountainous ?surveyLand))
        
        )
    :effect
        (surveyedArea ?surveyLand)
        
        

)



; (:action installSolar
;     :parameters (

;         ?mech - mech
;         ?p - pilot
;         ?surveyor - surveyor
;         ?manipulation - manipulation
;         ?engineer - engineer
;         ?kit - solarDeployment1

        
;     )
;     :precondition (and
        
;         (isPassenger ?engineer ?mech)
;         (isAttachedManipulation ?manipulation ?mech)
;         (isInside ?mech ?p)
;         (inLocation ?mech ?surveyLand)
;         (not(exploded ?mech))
;         (not (isMountainous ?surveyLand))
        
;         )
;     :effect
;         (surveyedArea ?surveyLand)
        
        

; )



)
