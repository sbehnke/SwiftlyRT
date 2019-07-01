Feature: OBJ File Parser

Scenario: Ignoring unrecognized lines
  Given gibberish ← a file containing:
    """
    There was a young lady named Bright
    who traveled much faster than light.
    She set out one day
    in a relative way,
    and came back the previous night.
    """
  When parser ← parse_obj_file(gibberish)
  Then parser should have ignored 5 lines

Scenario: Vertex records
  Given file ← a file containing:
    """
    v -1 1 0
    v -1.0000 0.5000 0.0000
    v 1 0 0
    v 1 1 0
    """
  When parser ← parse_obj_file(file)
  Then parser.vertices[1] = point(-1, 1, 0)
    And parser.vertices[2] = point(-1, 0.5, 0)
    And parser.vertices[3] = point(1, 0, 0)
    And parser.vertices[4] = point(1, 1, 0)

Scenario: Parsing triangle faces
  Given file ← a file containing:
    """
    v -1 1 0
    v -1 0 0
    v 1 0 0
    v 1 1 0

    f 1 2 3
    f 1 3 4
    """
  When parser ← parse_obj_file(file)
    And g ← parser.default_group
    And t1 ← first child of g
    And t2 ← second child of g
  Then t1.p1 = parser.vertices[1]
    And t1.p2 = parser.vertices[2]
    And t1.p3 = parser.vertices[3]
    And t2.p1 = parser.vertices[1]
    And t2.p2 = parser.vertices[3]
    And t2.p3 = parser.vertices[4]

Scenario: Triangulating polygons
  Given file ← a file containing:
    """
    v -1 1 0
    v -1 0 0
    v 1 0 0
    v 1 1 0
    v 0 2 0

    f 1 2 3 4 5
    """
  When parser ← parse_obj_file(file)
    And g ← parser.default_group
    And t1 ← first child of g
    And t2 ← second child of g
    And t3 ← third child of g
  Then t1.p1 = parser.vertices[1]
    And t1.p2 = parser.vertices[2]
    And t1.p3 = parser.vertices[3]
    And t2.p1 = parser.vertices[1]
    And t2.p2 = parser.vertices[3]
    And t2.p3 = parser.vertices[4]
    And t3.p1 = parser.vertices[1]
    And t3.p2 = parser.vertices[4]
    And t3.p3 = parser.vertices[5]

Scenario: Triangles in groups
  Given file ← the file "triangles.obj"
  When parser ← parse_obj_file(file)
    And g1 ← "FirstGroup" from parser
    And g2 ← "SecondGroup" from parser
    And t1 ← first child of g1
    And t2 ← first child of g2
  Then t1.p1 = parser.vertices[1]
    And t1.p2 = parser.vertices[2]
    And t1.p3 = parser.vertices[3]
    And t2.p1 = parser.vertices[1]
    And t2.p2 = parser.vertices[3]
    And t2.p3 = parser.vertices[4]

Scenario: Converting an OBJ file to a group
  Given file ← the file "triangles.obj"
    And parser ← parse_obj_file(file)
  When g ← obj_to_group(parser)
  Then g includes "FirstGroup" from parser
    And g includes "SecondGroup" from parser

Scenario: Vertex normal records
  Given file ← a file containing:
    """
    vn 0 0 1
    vn 0.707 0 -0.707
    vn 1 2 3
    """
  When parser ← parse_obj_file(file)
  Then parser.normals[1] = vector(0, 0, 1)
    And parser.normals[2] = vector(0.707, 0, -0.707)
    And parser.normals[3] = vector(1, 2, 3)

Scenario: Faces with normals
  Given file ← a file containing:
    """
    v 0 1 0
    v -1 0 0
    v 1 0 0

    vn -1 0 0
    vn 1 0 0
    vn 0 1 0

    f 1//3 2//1 3//2
    f 1/0/3 2/102/1 3/14/2
    """
  When parser ← parse_obj_file(file)
    And g ← parser.default_group
    And t1 ← first child of g
    And t2 ← second child of g
  Then t1.p1 = parser.vertices[1]
    And t1.p2 = parser.vertices[2]
    And t1.p3 = parser.vertices[3]
    And t1.n1 = parser.normals[3]
    And t1.n2 = parser.normals[1]
    And t1.n3 = parser.normals[2]
    And t2 = t1
