Object subclass: Person [
  | name email phone |

  Person class >> new: names of: emails of: phones [
    | r |
    r := super new.
    r init: names of: emails of: phones.
    ^r
  ]
  init: names of: emails of: phones [ 
     name  := names.
     email := emails.
     phone := phones.
  ]
  name [ ^name ]
  email [ ^email ]
  phone [ ^phone ]
]
