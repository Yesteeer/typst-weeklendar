#import "/src/func.typ": subdivide

// assertions on starting/ending numbers and subdivisions
#assert-panic(() => subdivide(0, 0, 5))
#assert-panic(() => subdivide(1, 2, 0))
#assert-panic(() => subdivide(2, 1, 5))
#assert-panic(() => subdivide(2, 1, 3.5))

// the following should work
#subdivide(1, 5, 100)
#subdivide(0, 100, 1)
#subdivide(3.86, 3.87, 100)

// compare with expected output
#assert.eq(subdivide(0, 9, 9), (0, 1, 2, 3, 4, 5, 6, 7, 8, 9).map(it => float(it)))
