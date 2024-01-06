# Dec 23 Model

Question: What is the delta between options w/in t=(0,120) as stock changes for Near Strike, Near Expiration Options

# TODO 1: As stock value changes, the nearby option value change I want to visualize this behavior.

    X: Time
    Y0: Stock

    Graph 1: Y1...7: Option [avg trade]
    Graph 2: Y1...7: Option [time value]
    Graph 3: Y1...7: Option [intrinsic value]

# TODO 2:  Discover Rubix: Velocity of change formula:
    Input: (stockValueChange, deltaTime, distanceToExpr, nearMoney) -> ExpectedChange 
    This needs to take into account these factors:
        - stock change
        - distance from strike 
        - distance from expiration

# TODO 3: Study category behaviors:

    A: close it out after x+ return
    B: what to do if no movement?
    C: what to do if stock devalues?

# TODO 4: Study compounding behaviors!!

   How does + - + behave?
   How does - - - behave?

Goal:  Can you get to a tracking covered call model that is profitable t=(0,120)?
   

