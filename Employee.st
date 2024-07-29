
Object subclass: Employee [
  | name email phone salary |

  Employee class >> new: names of: emails of: phones of: salarys [
    | r |
    r := super new.
    r init: names of: emails of: phones of: salarys.
    ^r
  ]

  init: names of: emails of: phones of: salarys [ 

     name  := names.
     email := emails.
     phone := phones.
     salary := salarys.
  ]
  name   [ ^name ]
  email  [ ^email ]
  phone  [ ^phone ]
  salary [ ^salary ]
]
