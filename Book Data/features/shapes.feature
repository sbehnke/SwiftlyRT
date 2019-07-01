Feature: Abstract Shapes

Scenario: The default transformation
  Given s ← test_shape()
  Then s.transform = identity_matrix

Scenario: Assigning a transformation
  Given s ← test_shape()
  When set_transform(s, translation(2, 3, 4))
  Then s.transform = translation(2, 3, 4)

Scenario: The default material
  Given s ← test_shape()
  When m ← s.material
  Then m = material()

Scenario: Assigning a material
  Given s ← test_shape()
    And m ← material()
    And m.ambient ← 1
  When s.material ← m
  Then s.material = m

Scenario: Intersecting a scaled shape with a ray
  Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
    And s ← test_shape()
  When set_transform(s, scaling(2, 2, 2))
    And xs ← intersect(s, r)
  Then s.saved_ray.origin = point(0, 0, -2.5)
    And s.saved_ray.direction = vector(0, 0, 0.5)

Scenario: Intersecting a translated shape with a ray
  Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
    And s ← test_shape()
  When set_transform(s, translation(5, 0, 0))
    And xs ← intersect(s, r)
  Then s.saved_ray.origin = point(-5, 0, -5)
    And s.saved_ray.direction = vector(0, 0, 1)

Scenario: Computing the normal on a translated shape
  Given s ← test_shape()
  When set_transform(s, translation(0, 1, 0))
    And n ← normal_at(s, point(0, 1.70711, -0.70711))
  Then n = vector(0, 0.70711, -0.70711)

Scenario: Computing the normal on a transformed shape
  Given s ← test_shape()
    And m ← scaling(1, 0.5, 1) * rotation_z(π/5)
  When set_transform(s, m)
    And n ← normal_at(s, point(0, √2/2, -√2/2))
  Then n = vector(0, 0.97014, -0.24254)

Scenario: A shape has a parent attribute
  Given s ← test_shape()
  Then s.parent is nothing

Scenario: Converting a point from world to object space
  Given g1 ← group()
    And set_transform(g1, rotation_y(π/2))
    And g2 ← group()
    And set_transform(g2, scaling(2, 2, 2))
    And add_child(g1, g2)
    And s ← sphere()
    And set_transform(s, translation(5, 0, 0))
    And add_child(g2, s)
  When p ← world_to_object(s, point(-2, 0, -10))
  Then p = point(0, 0, -1)

Scenario: Converting a normal from object to world space
  Given g1 ← group()
    And set_transform(g1, rotation_y(π/2))
    And g2 ← group()
    And set_transform(g2, scaling(1, 2, 3))
    And add_child(g1, g2)
    And s ← sphere()
    And set_transform(s, translation(5, 0, 0))
    And add_child(g2, s)
  When n ← normal_to_world(s, vector(√3/3, √3/3, √3/3))
  Then n = vector(0.2857, 0.4286, -0.8571)

Scenario: Finding the normal on a child object
  Given g1 ← group()
    And set_transform(g1, rotation_y(π/2))
    And g2 ← group()
    And set_transform(g2, scaling(1, 2, 3))
    And add_child(g1, g2)
    And s ← sphere()
    And set_transform(s, translation(5, 0, 0))
    And add_child(g2, s)
  When n ← normal_at(s, point(1.7321, 1.1547, -5.5774))
  Then n = vector(0.2857, 0.4286, -0.8571)
