### TEMPLATES

details:
  sleep:
    start: 23:00
    end: 07:00
    energy at lights out:

meta:
  sleep:
    start:
      $type: datetime
      $required: true
    end:
      $type: datetime
      $required: true
    energy at lights out:
      $type: range
      $range start: 0
      $range end: 10
      $path: sleep.energy_at_lights_out
  meals:
    [
      dinner:
        $type: bool
        $path: meals.@each.dinner
      lunch:
        $type: bool
        $path: meals.@each.lunch
      breakfast:
        $type: bool
        $path: meals.@each.breakfast
    ]
  meals:
    [
      $type: meal
      $path: meals.@each
    ]
  list of numbers:
    [
      $type: integer
      $path: list_of_numbers.@each
    ]

#### ALGORITHM
  if an object has a key that starts with $
  THEN it is a metavalue, which DESCRIBES the sets of values that can fit in its path

# IDEA
=======
  typedefed values can contain other values. e.g.,
  TimeRange:
    Start:
    d
      $type: time with zone
    End:
      $type: time with zone







### MVP

* MixPanel een tracking for happiness, productivity, sleepiness

* link up with twilio / email GoogleVoice

* Deploy on EC2


### USE EPICS

* For tracking arbitrary DATUM about your life

    * I want to know how sleepy I am throughout the entire day.

    * I want to keep track of what I’m eating for each meal

    * I want the tracking to be SEAMLESS and FAST

        * I don’t want to spend more than 15 minutes a day tracking TOTAL, and that’s tracking a LOT of stuff

* For analyzing the things you tracked

    * I want to know how my sleep hygiene affects my productivity, as measured by the following properties

    * I want to know how many apples I ate in June

* For figuring out how I spend my time (cross RescueTime)

    * how productive am I?

    * How much time and

* For documenting what I do

    * I want journal my best part of day

        * worst part of day

        * funny stories

        * big ideas

* For automatically importing your data from other sources

    * Music -- what songs am I listening to?

        * How has my music listening changed over time?

    * Location

    * Evernotes -- notes created

    * Email

    * Github

    * RescueTime

* For serving as a motivating force -- think of gamifying it via [https://github.com/samsquire/ideas/tree/1c62a7115e63c4b2fc3380e138bf3dac2a81d979#71-gaming-interfaces-for-work](https://github.com/samsquire/ideas/tree/1c62a7115e63c4b2fc3380e138bf3dac2a81d979#71-gaming-interfaces-for-work)

    * Your producitvity right now

    * Your "focus"

    * Number of distractions

* For providing an "at-a-glance" view of my life / one-stop dashboard for all things that matter to my life

**FEATURES**

* sends you a text every 30 minutes asking you to track

* lets you reply to the text with a simple format to be parsed

* **REMINDERS**

* Templates -- auto insert the template for whatever you’re supposed to be tracking

    * df

* "grab" paths e.g. meals.breakfast.ate?, moods.happiness,

* Notifies me when

* Timeline view

    * like facebook

    * show gaps between SP acts

        * "4 hours untracked" -- click to track an act

    * by default, zoom to the current day

    * can scroll to see previous.

**Architecture / data model / processes**

* **Reminders**

    * A "response" to a reminder is a specific recording to a requested tracking

        * aka, system that I set up requests me to track property P

        * When I get the reminder, I "respond" by tracking property P

    * instantaneous (timestamped) or duration?

    * integrated to sherwin points data?

* **Templates**

    * Goal is to **keep the data as normalized as possible**

        * Use case:

            * Month 1, I track "ate_breakfast: bool"

            * Later on, I namespace these under

                * meals.breakfast:meal_object

* ‘Event’ architecture

    * Are we going to support generic event tracking? MixPanel style?

**PHILOSOPHY**

* time-stamped (instantaneous tracking) vs duration

    * timestamp: at 2pm today, I felt 10 happy

    * duration: between 2 and 2:30 today, I felt 10 happy

### Goals

* clean up humon node editor  to the point that:

    * streamline event architecture for humon node

    * reliable editing

        * tests

        * humon node parses correctly (no more invisible errors becaus HUMON parser fails)

    * in place ‘large’ edit

    * multiple data types

        * good date editing

    * sane defaults for new node

    * for this week: only track at the day level

* then

    * think about how to propagate templates from server to client

    * how to reliably include meta information

    * how to make the humon node editor a plug and play json editor

* then

    * hour to hour tracking

* api

    * **temporary finalize backend structure**

        * **how are activities / days stored?**

        * **nesting**

        * **aggregation and bubbling **

    * allow posting both from the dashboard and from the chrome extension

* chrome extension

    * track detailed site usage

* dashboard

    * allower arbitrary tracking

    * reminder via a chrome extension

    * prominently display active goals

        * tag activities to goals

Support for goals

* inputting weekly goals

* inputting longer goals

* **inputting daily plans**

    * **want style of**

    * **2-4pm: do x y z**

    * **4-5pm: do x y z**

        * **and do x yz **

        * **comments**

* **but want it to be stored in HUMON NODE format.**

    * data modeling. one of :

        * stand alone plans (each entity has its own barries, no relation to each other)

        * nested under a ‘day’

        * nested under the ‘plan’ field of the SPday object

            * coerced to a ‘template’ ?

            * or a ‘type’?

        * a whole other object by itself

    * approaches

        * time boundaries stored natively against metadata

* HNV / act extensions via ```partial```

ACT can have many child entities

	some entities are plans

	some entities are other acts

think about client / server communications -- embedding vs not embedded

data modeling is independent of UI display

	Figure out data model first. don’t be lazy.

Entity

	start time

	end time

	description

	details





Plan < Entity

Goal < Plan

Habit < Plan



Act < Entity



Day < Act

Do we even need an explicit details object?.... probably not?

PRM
