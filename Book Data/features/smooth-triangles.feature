Feature: Smooth Triangles

Background:
  Given p1 ← point(0, 1, 0)
    And p2 ← point(-1, 0, 0)
    And p3 ← point(1, 0, 0)
    And n1 ← vector(0, 1, 0)
    And n2 ← vector(-1, 0, 0)
    And n3 ← vector(1, 0, 0)
  When tri ← smooth_triangle(p1, p2, p3, n1, n2, n3)

Scenario: Constructing a smooth triangle
  Then tri.p1 = p1
    And tri.p2 = p2
    And tri.p3 = p3
    And tri.n1 = n1
    And tri.n2 = n2
    And tri.n3 = n3

Scenario: An intersection with a smooth triangle stores u/v
  When r ← ray(point(-0.2, 0.3, -2), vector(0, 0, 1))
    And xs ← local_intersect(tri, r)
  Then xs[0].u = 0.45
    And xs[0].v = 0.25

Scenario: A smooth triangle uses u/v to interpolate the normal
  When i ← intersection_with_uv(1, tri, 0.45, 0.25)
    And n ← normal_at(tri, point(0, 0, 0), i)
  Then n = vector(-0.5547, 0.83205, 0)

Scenario: Preparing the normal on a smooth triangle
  When i ← intersection_with_uv(1, tri, 0.45, 0.25)
    And r ← ray(point(-0.2, 0.3, -2), vector(0, 0, 1))
    And xs ← intersections(i)
    And comps ← prepare_computations(i, r, xs)
  Then comps.normalv = vector(-0.5547, 0.83205, 0)
