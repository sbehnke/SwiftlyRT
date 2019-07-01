Feature: Cylinders

Scenario Outline: A ray misses a cylinder
  Given cyl ← cylinder()
    And direction ← normalize(<direction>)
    And r ← ray(<origin>, direction)
  When xs ← local_intersect(cyl, r)
  Then xs.count = 0

  Examples:
    | origin          | direction       |
    | point(1, 0, 0)  | vector(0, 1, 0) |
    | point(0, 0, 0)  | vector(0, 1, 0) |
    | point(0, 0, -5) | vector(1, 1, 1) |

Scenario Outline: A ray strikes a cylinder
  Given cyl ← cylinder()
    And direction ← normalize(<direction>)
    And r ← ray(<origin>, direction)
  When xs ← local_intersect(cyl, r)
  Then xs.count = 2
    And xs[0].t = <t0>
    And xs[1].t = <t1>

  Examples:
    | origin            | direction         | t0      | t1      |
    | point(1, 0, -5)   | vector(0, 0, 1)   | 5       | 5       |
    | point(0, 0, -5)   | vector(0, 0, 1)   | 4       | 6       |
    | point(0.5, 0, -5) | vector(0.1, 1, 1) | 6.80798 | 7.08872 |

Scenario Outline: Normal vector on a cylinder
  Given cyl ← cylinder()
  When n ← local_normal_at(cyl, <point>)
  Then n = <normal>

  Examples:
    | point           | normal           |
    | point(1, 0, 0)  | vector(1, 0, 0)  |
    | point(0, 5, -1) | vector(0, 0, -1) |
    | point(0, -2, 1) | vector(0, 0, 1)  |
    | point(-1, 1, 0) | vector(-1, 0, 0) |

Scenario: The default minimum and maximum for a cylinder
  Given cyl ← cylinder()
  Then cyl.minimum = -infinity
    And cyl.maximum = infinity

Scenario Outline: Intersecting a constrained cylinder
  Given cyl ← cylinder()
    And cyl.minimum ← 1
    And cyl.maximum ← 2
    And direction ← normalize(<direction>)
    And r ← ray(<point>, direction)
  When xs ← local_intersect(cyl, r)
  Then xs.count = <count>

  Examples:
    |   | point             | direction         | count |
    | 1 | point(0, 1.5, 0)  | vector(0.1, 1, 0) | 0     |
    | 2 | point(0, 3, -5)   | vector(0, 0, 1)   | 0     |
    | 3 | point(0, 0, -5)   | vector(0, 0, 1)   | 0     |
    | 4 | point(0, 2, -5)   | vector(0, 0, 1)   | 0     |
    | 5 | point(0, 1, -5)   | vector(0, 0, 1)   | 0     |
    | 6 | point(0, 1.5, -2) | vector(0, 0, 1)   | 2     |

Scenario: The default closed value for a cylinder
  Given cyl ← cylinder()
  Then cyl.closed = false

Scenario Outline: Intersecting the caps of a closed cylinder
  Given cyl ← cylinder()
    And cyl.minimum ← 1
    And cyl.maximum ← 2
    And cyl.closed ← true
    And direction ← normalize(<direction>)
    And r ← ray(<point>, direction)
  When xs ← local_intersect(cyl, r)
  Then xs.count = <count>

  Examples:
    |   | point            | direction        | count |
    | 1 | point(0, 3, 0)   | vector(0, -1, 0) | 2     |
    | 2 | point(0, 3, -2)  | vector(0, -1, 2) | 2     |
    | 3 | point(0, 4, -2)  | vector(0, -1, 1) | 2     | # corner case
    | 4 | point(0, 0, -2)  | vector(0, 1, 2)  | 2     |
    | 5 | point(0, -1, -2) | vector(0, 1, 1)  | 2     | # corner case

Scenario Outline: The normal vector on a cylinder's end caps
  Given cyl ← cylinder()
    And cyl.minimum ← 1
    And cyl.maximum ← 2
    And cyl.closed ← true
  When n ← local_normal_at(cyl, <point>)
  Then n = <normal>

  Examples:
    | point            | normal           |
    | point(0, 1, 0)   | vector(0, -1, 0) |
    | point(0.5, 1, 0) | vector(0, -1, 0) |
    | point(0, 1, 0.5) | vector(0, -1, 0) |
    | point(0, 2, 0)   | vector(0, 1, 0)  |
    | point(0.5, 2, 0) | vector(0, 1, 0)  |
    | point(0, 2, 0.5) | vector(0, 1, 0)  |
