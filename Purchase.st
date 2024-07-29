Object subclass: Purchase [
  | Item Qty Cost |

  Purchase class >> new: Items of: Qtys of: Costs [
    | r |
    r := super new.
    r init: Items of: Qtys of: Costs.
    ^r.
  ]

  init: Items of: Qtys of: Costs  [
    Item := Items.
    Qty  := Qtys.
    Cost := Costs.
  ]

  Item [ ^Item. ]
  Qty  [ ^Qty.  ]
  Cost [ ^Cost. ]
]
