(define (problem fixAndExplode)
   (:domain mainDomain)
   
   (:objects
   
   ; land areas
   a - land ; mountainous area
   b - land ; hilly area
   c - land ; flat area engineeringBay
   d - land ; flat area commandCentre
   e - land ; flat area
   f - land ; hilly area
   g - land ; flat area
   h - land ; flat area
   i - land ; flat area
   j - land ; explosive area
   k - land ; hilly area
   l - land ; mountainous area
   m - land ; flat area
   n - land ; flat area
   o - land ; flat area
   p - land ; hilly area

   ; people
   commander - commander; Christopher ; 
   engineer1 - engineer ; Reece  
   engineer2 - engineer; David 
   pilot1 - pilot; Emily 
   pilot2 - pilot ; Martin ; 
   scienceOfficer1 - scienceOfficer ; Dean 
   scienceOfficer2 - scienceOfficer ; Jack 
   
   ; buildings 
   CommandCentre1 - CommandCentre
   EngineeringBay1 - EngineeringBay
    
   ; mechs
   titanMech1a - titanMech1
   titanMech2a - titanMech2
   
   ; attachment
   driller1 - driller 
   surveyor1 - surveyor  
   manipulation1 - manipulation
)

(:init
   
   ; land adjacency horizontally
   (isAdjacent a b)
   (isAdjacent b a)
   (isAdjacent b c)
   (isAdjacent c b)
   (isAdjacent c d)
   (isAdjacent d c)
   (isAdjacent e f)
   (isAdjacent f e)
   (isAdjacent f g)
   (isAdjacent g f)
   (isAdjacent g h)
   (isAdjacent h g)
   (isAdjacent i j)
   (isAdjacent j i)
   (isAdjacent j k)
   (isAdjacent k j)
   (isAdjacent k l)
   (isAdjacent l k)
   (isAdjacent m n)
   (isAdjacent n m)
   (isAdjacent n o)
   (isAdjacent o n)
   (isAdjacent o p)
   (isAdjacent p o)

   ; land adjacency vertically
   (isAdjacent a e)
   (isAdjacent e a)
   (isAdjacent b f)
   (isAdjacent f b)
   (isAdjacent c g)
   (isAdjacent g c)
   (isAdjacent d h)
   (isAdjacent h d)
   (isAdjacent e i)
   (isAdjacent i e)
   (isAdjacent f j)
   (isAdjacent j f)
   (isAdjacent g k)
   (isAdjacent k g)
   (isAdjacent h l)
   (isAdjacent l h)
   (isAdjacent i m)
   (isAdjacent m i)
   (isAdjacent j n)
   (isAdjacent n j)
   (isAdjacent k o)
   (isAdjacent o k)
   (isAdjacent l p)
   (isAdjacent p l)

   (isMountainous a)
   (isHilly b)
   (isFlat c)
   (isFlat d)
   (isFlat e)
   (isHilly f)
   (isFlat g)
   (isFlat h)
   (isFlat i)
   (isHilly j)
   (isExplosive j)
   (isHilly k)
   (isMountainous l)
   (isFlat m)
   (isFlat n)
   (isFlat o)
   (isHilly p)  
   
   (inRegion CommandCentre1 d)  
   (docked titanMech2a)
   (dockMech titanMech2a EngineeringBay1)
   (inLocation titanMech2a c)
   (personnelLocation commander d)
   (personnelLocation engineer1 d)
   (personnelLocation engineer2 d)
   (personnelLocation scienceOfficer1 d)
   (personnelLocation scienceOfficer2 d)
   (personnelLocation pilot1 d)
   (personnelLocation pilot2 d)
   (inRegion EngineeringBay1 c)
   (hasDriller EngineeringBay1 driller1)
   (hasSurveyor EngineeringBay1 surveyor1)
   (hasManipulation EngineeringBay1 manipulation1)

   ;simulate exploded mech in explosive area
   (inLocation titanMech1a j)
    (exploded titanMech1a)
   
)

(:goal  
   ;survey area m
   (and 
      (not(exploded titanMech1a))
      (exploded titanMech2a)
   )
)

)

