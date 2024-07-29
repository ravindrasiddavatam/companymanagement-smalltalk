FileStream fileIn: 'Purchase.st'.
FileStream fileIn: 'Employee.st'.
FileStream fileIn: 'Customer.st'.
Object subclass: Company [
    | filename message file employees customers maxEmployees maxCustomers numEmployees numCustomers numPurchases |
    Company class >> new [
      | newCompany |
      newCompany := super new.
      newCompany initialize.
      ^newCompany
    ]
    initialize [
      'Company Name: ' display.
      filename   :=  1.
      message :=  2.
      filename := stdin nextLine.
      filename := filename ,'.dat'.
      ( File exists: filename ) ifFalse: [
        file := FileStream open: filename mode: FileStream readWrite.
        file nextPutAll: '0'; cr.
        file nextPutAll: '0'; cr.
        file close.
      ].
      maxEmployees := 100.
      maxCustomers := 100.
      numEmployees := 0.
      numCustomers  := 0.
      numPurchases := 0.
      employees := Array new: maxEmployees.
      customers := Array new: maxCustomers.
      self readData.
    ]
    growEmployees [
      | newArray |
      maxEmployees := maxEmployees * 2.
      newArray := Array new: maxEmployees.
      1 to: numEmployees do: [ :i | newArray at: i put: employees at: i. ].
      employees := newArray.
    ]
    growCustomers [
      | newArray |
      maxCustomers := maxCustomers * 2.
      newArray := Array new: maxCustomers.
      1 to: numCustomers do: [ :i | newArray at: i put: customers at: i. ].
      customers := newArray.
    ]

    getCustomers [ ^customers ]
    getEmployees [ ^employees ]
    
    addEmployee: anEmployee [
      numEmployees := numEmployees + 1.
      numEmployees > maxEmployees ifTrue: [ self growEmployees ].
      employees at: numEmployees put: anEmployee.
    ]
    addCustomer: aCustomer [
      numCustomers := numCustomers + 1.
      numCustomers > maxCustomers ifTrue: [ self growCustomers ].
      customers at: numCustomers put: aCustomer.
    ]
    readData [
    | name email phone salary item qty cost employee customer purchase numEmployees1 numCustomers1 numPurchases1 |
      file := FileStream open: filename mode: FileStream readWrite.
      numEmployees1 := file nextLine asInteger.
      1 to: numEmployees1 do: [ :i |
          name   := file nextLine.
          email  := file nextLine.
          phone  := file nextLine.
          salary := file nextLine asNumber.
          employee := Employee new: name of: email of: phone of: salary.
          self addEmployee: employee.
          ].
      numCustomers1   := file nextLine asInteger.
      1 to: numCustomers1 do: [ :i |
          name   := file nextLine.
          email  := file nextLine.
          phone  := file nextLine.
          customer := Customer new: name of: email of: phone.
          numPurchases1 := file nextLine asInteger.
          
          1 to: numPurchases1 do: [
              : j |
              item := file nextLine.
              qty  := file nextLine asInteger.
              cost := file nextLine asNumber.
              purchase := Purchase new: item of: qty of: cost.
              customer append: purchase.
              ].
          self addCustomer: customer.
          ]. 
      file close.
      ]
      writeData [
      | anEmployee aCustomer aPurchase name email phone salary history item qty cost |
        file := FileStream open: filename mode: FileStream readWrite.
        file nextPutAll: numEmployees asString; cr.
        1 to: numEmployees do: [ :i |
            anEmployee   := employees at: i.
            name  := anEmployee name.
            email := anEmployee email.
            phone := anEmployee phone.
            salary:= anEmployee salary asString.
            file nextPutAll: name; cr.
            file nextPutAll: email; cr.
            file nextPutAll: phone; cr.
            file nextPutAll: salary; cr.
            ].
        file nextPutAll: numCustomers asString; cr.
        1 to: numCustomers do: [ :i |
            aCustomer := customers at: i.
            name  := aCustomer name.
            email := aCustomer email.
            phone := aCustomer phone.
            numPurchases:= aCustomer size.
            file nextPutAll: name; cr.
            file nextPutAll: email; cr.
            file nextPutAll: phone; cr.
            file nextPutAll: numPurchases asString; cr.
            1 to: numPurchases do: [
                : j |
                aPurchase := customers at: i.
                aPurchase := aPurchase history at: j.
                item := aPurchase Item.
                qty  := aPurchase Qty asString.
                cost := aPurchase Cost asString.
                file nextPutAll: item; cr.
                file nextPutAll: qty; cr.
                file nextPutAll: cost; cr.
                ].
            ]. 
        file close.
        ]
      showError [
        'Error: No Customers.' displayNl.
      ]
      customerMenu [
        '(A)dd Customer, Enter a (S)ale, (V)iew Customer, or (M)ain Menu? ' display.
      ]
      employeeMenu [
        '(A)dd Employee or (M)ain Menu? ' display.
      ]
      addNewEmployee [
        | name email phone salary newEmployee |
        'Name: ' display.
        name := stdin nextLine.
        'Email: ' display.
        email := stdin nextLine.
        'Phone: ' display.
        phone := stdin nextLine.
        'Salary: ' display.
        salary := stdin nextLine asNumber.
        newEmployee := Employee new: name of: email of: phone of: salary.
        self addEmployee: newEmployee.
      ]

      addNewCustomer [
        | name email phone newCustomer |
        'Name: ' display.
        name := stdin nextLine.
        'Email: ' display.
        email := stdin nextLine.
        'Phone: ' display.
        phone := stdin nextLine.
        newCustomer := Customer new: name of: email of: phone.
        self addCustomer: newCustomer.
      ]
      addNewPurchase: index [
        | item qty price newPurchase customer |
        (index > 0) ifTrue: [
          'Item: ' display.
          item := stdin nextLine.
          'Quantity: ' display.
          qty := stdin nextLine asInteger.
          'Cost: ' display.
          price := stdin nextLine asNumber.
          customer := customers at: index.
          newPurchase := Purchase new: item of: qty of: price.
          customer append: newPurchase.
        ].
        (numCustomers > 0) ifFalse: [
          self showError.
        ].
      ]
      
      
      displayEmployees [
        | done name email phone salary anEmployee choice |
        done := false.
        [done] whileFalse: [
          1 to: numEmployees do: [ :i |
            anEmployee  := employees at: i.
            name      := anEmployee name.
            email     := anEmployee email.
            phone     := anEmployee phone.
            salary    := anEmployee salary asString.
            message   := name , ' <' , email , '>' , ' Phone: ' , phone , ' Salary: $' , salary.
            message displayNl.
          ].
          self employeeMenu.
          choice := stdin nextLine.
          choice = 'A' ifTrue: [
              self addNewEmployee.
          ].
          choice = 'M' ifTrue: [
            done := true.
          ].
        ].
      ]
      sales [
        | done choice index customer  |
        done := false.
        [done] whileFalse: [
          self customerMenu.
          choice := stdin nextLine.
          choice = 'A' ifTrue: [
             self addNewCustomer.
          ].
          choice = 'S' ifTrue: [
              (numCustomers <= 0 ) ifTrue: [
                 self showError. 
              ].
              (numCustomers <= 0 ) ifFalse: [
                  1 to: numCustomers do: [ :i |
                      customer:= customers at: i. 
                      message := i asString , '.) ', (customer name).
                      message displayNl.
                  ].
                  'Choice? '        display.
                index := stdin nextLine asInteger.
                self addNewPurchase: index.
              ].
          ].
          choice = 'V' ifTrue: [
              (numCustomers <= 0 ) ifTrue: [
                 self showError. 
              ].
              (numCustomers <= 0 ) ifFalse: [
                  1 to: numCustomers do: [ :i |
                      customer:= customers at: i. 
                      message := i asString , '.) ', (customer name).
                      message displayNl.
                  ].
                'Choice? '        display.
                index := stdin nextLine asInteger.
                self displayCustomer: index.
              ].
          ].
          choice = 'M' ifTrue: [
            done := true.
          ].
        ].
      ]
      displayCustomer: i [
        | done name email phone customer item price qty purchase |
        done := false.
        (done) ifFalse: [
            customer  := customers at: i.
            name      := customer name.
            email     := customer email.
            phone     := customer phone.
            message   := name , ' <' , email , ' >' , ' Phone: ' , phone.
            message displayNl.
            'Order History' displayNl.
            'Item                   Price  Quantity   Total' displayNl.
            1 to: (customer size) do: [ :j |
              purchase := customer history at: j.
              item     := purchase Item.
              qty      := purchase Qty.
              price    := purchase Cost.
              message  := item ,'        ', price asString ,'         ', qty asString, '        ' , ( price asFloatD * qty asFloatD ) asString.
              message displayNl.
            ].
          ].
      ]
      
      
      
      run [
      | choice done |
        done := false.
        [done] whileFalse: [
            '      MAIN MENU' displayNl.
            '1.) Employees'   displayNl.
            '2.) Sales'       displayNl.
            '3.) Quit'        displayNl.
            'Choice? '        display.
            choice := stdin nextLine asInteger.
            choice = 1 ifTrue: [
                self displayEmployees
            ].
            choice = 2 ifTrue: [
                self sales.
            ].
            choice = 3 ifTrue: [
                self writeData.
                done := true. 
            ].
        ].
      ]
]. 