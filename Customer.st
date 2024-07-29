FileStream fileIn: 'Purchase.st'.

Object subclass: Customer [
  | name email phone history size max |
  Customer class >> new: names of: emails of: phones  [
    | r |
    r := super new.
    r init: names of: emails of: phones .
    ^r
  ]
  init: names of: emails of: phones  [ 
     name  := names.
     email := emails.
     phone := phones.
     max   := 80.
     size  := 0.
     history := Array new: max.
     
  ]
  grow [
    | nar |
    max := max * 2.
    nar := Array new: max.
    1 to: size do: [ :i | nar at: i put: history at: i. ].
    history := nar.
  ]
  append: purchase [
    size := size + 1.
    size > max ifTrue: [ self grow ].
    history at: size put: purchase.
  ]
  name    [ ^name  ]
  email   [ ^email ]
  phone   [ ^phone ]
  size    [ ^size  ]
  history [ ^history ]
]
