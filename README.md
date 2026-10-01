# PDDL Autonomous Mission Planning

An automated planning project developed during my university studies using the Planning Domain Definition Language (PDDL).

The project models a mission environment in which personnel and robotic mechs must navigate terrain, use specialised equipment, interact with buildings, collect and analyse scientific samples, survey areas, respond to hazardous conditions and satisfy defined mission objectives.

## Project Overview

The project separates planning into a reusable **domain model** and a collection of individual **planning problems**.

The domain describes the rules governing the environment:

```text
DOMAIN
│
├── World state
├── Personnel
├── Robotic mechs
├── Buildings
├── Terrain
├── Equipment
├── Hazards
└── Available actions
```

Individual problem files then define:

```text
PROBLEM
│
├── Objects
├── Initial state
└── Goal state
```

A compatible automated planner can use these definitions to search for a sequence of valid actions that transforms the initial world state into one satisfying the specified goal.

## Technologies

- PDDL
- Automated Planning
- Artificial Intelligence
- Symbolic State Representation
- Goal-Based Planning

## Repository Structure

```text
pddl-autonomous-mission-planning/
│
├── README.md
├── LICENSE
│
├── domain/
│   └── mainDomain.pddl
│
└── problems/
    ├── analyseSample.pddl
    ├── fixAndExplode.pddl
    └── surveyArea.pddl
```

## Mission Environment

The planning domain models an environment containing several interacting categories of entities.

### Personnel

The environment includes specialised personnel roles such as:

- Commander
- Engineer
- Pilot
- Science officer

Personnel can occupy locations, enter buildings and, depending on their role and current state, participate in mission actions.

### Robotic Mechs

Mechs provide mobile platforms capable of transporting personnel and carrying specialised attachments.

Their state can include:

```text
Mech
│
├── Location
├── Docked / Undocked
├── Pilot
├── Passenger
├── Attachment
├── Collected Sample
└── Operational / Exploded
```

### Buildings

The environment contains facilities including:

- Engineering Bay
- Command Centre

These support activities such as mech configuration and scientific sample analysis.

### Equipment

Specialised attachments include:

- Driller
- Surveyor
- Manipulation equipment

Equipment availability and attachment state affect which actions a mech can perform.

## Terrain Model

The planning environment is represented as interconnected land regions.

Areas can have properties including:

```text
Flat
Hilly
Mountainous
Explosive
```

Adjacency relationships define which regions can be reached from neighbouring regions.

Movement actions use these relationships together with terrain constraints to determine whether a transition is valid.

For example, mech and personnel movement prevent traversal into mountainous areas.

## Planning Actions

The domain contains actions describing how the world state can change.

Each action defines:

```text
Action
│
├── Parameters
├── Preconditions
└── Effects
```

An action can only be selected by the planner when all of its preconditions are satisfied.

Its effects then modify the symbolic state used when considering subsequent actions.

## Personnel Movement

`move_person` allows personnel to move between adjacent land regions.

The action requires:

- The person to occupy the source region
- The destination to be traversable
- The source and destination to be adjacent

The resulting state removes the previous personnel location and assigns the new one.

## Mech Movement

`move_mech` models movement of a piloted mech between adjacent regions.

Movement requires the mech to:

- Be operational
- Have a pilot inside
- Be located at the source region
- Be undocked
- Have a traversable destination

Both the mech and pilot locations are updated when movement occurs.

## Docking and Piloting

The domain includes actions for:

- Docking a mech
- Undocking a mech
- Entering a mech as pilot

This introduces state dependencies into the planning problem.

For example:

```text
Mech Docked
     +
Pilot in Engineering Bay
     |
     v
 Pilot Mech
     |
     v
Mech has Pilot
     |
     v
Undock
     |
     v
Move Mech
```

The planner must therefore establish the required intermediate states before movement becomes possible.

## Equipment Configuration

Different mission objectives require different mech attachments.

The domain contains actions for attaching:

- Drilling equipment
- Survey equipment
- Manipulation equipment

Attachment actions require appropriate equipment to be available within the Engineering Bay and an engineer to be present.

The mech is restricted to a single attachment state at a time through the `hasAttachment` predicate.

## Passenger Transport

A mech can transport another member of personnel as a passenger.

The planning model tracks:

- Whether the mech currently has a passenger
- Which person is the passenger
- Whether that person is busy
- Their transition between external and onboard states

This allows specialist personnel to be transported to locations where their role is required.

## Core Sample Collection

The domain includes a `takeCoreSample` action.

Sample collection requires conditions including:

- A suitable hilly region
- An operational mech
- A pilot
- A science officer travelling as passenger
- An attached drill
- The mech being located within the sampling area

Successful execution adds a sample associated with that land region to the mech state.

## Hazard Modelling

One region of the example environment is designated as explosive.

The domain includes a separate hazardous sampling action:

```text
takeCoreSampleExplode
```

When its preconditions are satisfied within an explosive region, the resulting effect places the mech into an exploded state.

This introduces failure conditions into the planning environment rather than modelling every action as inherently successful.

## Repair

An exploded mech can be repaired using the `fix` action.

Repair requires:

- The mech to be exploded
- An engineer to occupy the same location
- The engineer to be available

The resulting effect removes the mech's exploded state.

This creates planning scenarios in which a failure can become an intermediate state rather than necessarily making the goal unreachable.

## Sample Analysis

Collected core samples can subsequently be analysed.

The `analyseCoreSample` action requires the appropriate personnel, mech, location and collected-sample state.

Successful analysis consumes the stored sample and records the corresponding area as analysed.

Conceptually:

```text
Travel to Sample Area
        |
        v
Collect Core Sample
        |
        v
Transport Sample
        |
        v
Reach Command Centre
        |
        v
Analyse Sample
        |
        v
Goal State
```

## Surveying

A mech fitted with survey equipment can perform the `surveyLand` action.

The action requires:

- Survey equipment attached
- Pilot inside the mech
- Mech located in the target area
- Operational mech
- Non-mountainous terrain

Successful execution marks the target region as surveyed.

## Example Planning Problems

The repository contains several problem definitions designed to exercise different parts of the domain.

### Survey Area

The survey scenario defines the terrain network, available personnel, mechs, buildings and equipment and establishes a goal requiring a specified area to become surveyed.

Satisfying this goal requires the planner to reason about prerequisites such as equipment configuration, piloting, mech movement and terrain accessibility.

### Fix and Explode

Another scenario introduces an already exploded mech in the hazardous region.

The goal combines state changes involving repair and an exploded state, exercising the domain's failure and recovery behaviour.

### Analyse Sample

The project also contains a problem scenario intended to exercise the scientific mission workflow involving sample collection and analysis.

## Planning Model

The overall concept can be represented as:

```text
                    INITIAL STATE
                         |
                         v
              +---------------------+
              |   Available Actions |
              +---------------------+
                         |
                 Check Preconditions
                         |
                         v
                  Execute Action
                         |
                         v
                   Update State
                         |
                         v
                  Goal Satisfied?
                    /        \
                  No          Yes
                  |            |
                  +----<-------+
                               |
                               v
                          PLAN FOUND
```

Rather than explicitly programming the required mission sequence, the domain defines **what actions are possible and under what conditions**.

The planner is responsible for determining the sequence required to achieve the goal.

## Concepts Demonstrated

This project provided practical experience with:

- Automated planning
- PDDL
- Symbolic AI
- State-space search
- Goal-based reasoning
- Predicates
- Typed objects
- Preconditions
- Action effects
- Negative preconditions
- Resource/state constraints
- Terrain modelling
- Agent and robot state
- Failure-state modelling
- Recovery actions
- Mission decomposition

## Original Implementation

The PDDL files in this repository preserve the original university implementation.

They have not been rewritten to make the project appear more polished than it was at the time.

The files therefore also contain commented-out experimental predicates and actions representing functionality considered during development but not incorporated into the final model.

## Retrospective

This project was an important introduction to automated planning because the programming model differs substantially from conventional imperative control software.

Instead of explicitly writing:

```text
Do A
then B
then C
then D
```

the domain describes:

```text
A is possible when...
B is possible when...
C changes...
D requires...
```

and allows a planning algorithm to determine an appropriate action sequence.

This distinction became particularly relevant to my later work with robotics and autonomous systems, where behaviour frequently involves reasoning about state, constraints, available actions and objectives.

### Domain Modelling

The original domain contains a large number of predicates representing personnel, equipment, terrain and mech state.

With my current experience I would separate these concerns more systematically and use consistent naming conventions throughout the domain.

### Action Design

Some actions contain parameters that are not directly used within their preconditions or effects.

A cleaner implementation would remove unnecessary parameters and ensure that every action expresses only the state required for its behaviour.

### Repeated World Definition

The problem files repeat the same underlying terrain, personnel and equipment configuration.

For a larger planning project I would generate scenario definitions programmatically or use tooling around the PDDL model to reduce duplication and make scenario maintenance easier.

### Validation and Testing

Today I would maintain a structured collection of planning scenarios designed to test individual domain behaviours such as:

- Navigation
- Docking
- Equipment attachment
- Passenger transport
- Surveying
- Sample collection
- Hazard triggering
- Repair
- Sample analysis
- Impossible goals

Planner output could then be retained alongside each scenario to demonstrate that the expected plans are generated.

## Portfolio Context

This project demonstrates an early application of artificial-intelligence techniques to a robotics-style mission domain.

It complements my conventional programming projects by showing a different approach to autonomous behaviour:

```text
Traditional Control Software
        |
        | explicitly defines actions
        v
   Execution Sequence


Automated Planning
        |
        | defines states, constraints
        | actions and objectives
        v
 Planner Determines Sequence
```

The project is particularly relevant to my later robotics and autonomous-systems work because it introduced the concepts of modelling agents, environments, resources, hazards and mission goals in a form that an automated planner can reason about.
