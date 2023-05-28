# SwiftlyRT

[![Build Status](https://app.bitrise.io/app/1477f450-ea5a-41b2-be5c-f61ca747bc82/status.svg?token=v9_ZskgX9STRqurxWqBjQg&branch=master)](https://app.bitrise.io/app/1477f450-ea5a-41b2-be5c-f61ca747bc82)

An implementation of the Ray Tracer Challenge by Jamis Buck, written in Swift 5.0.

Primitives Supported:
* Sphere
* Cube
* Cone
* Triangle
* Cylinder
* CSG (Constructive Solid Geometry)
  * Union
  * Intersection
  * Difference
* Group
* Waveform OBJ Files

Lights:
* Point Light
* Area Light

Texture Mapping:
* Spherical
* Planar
* Cylindrical
* Cube

Image Formats:
* PPM

Scene Description Format:
* Yaml

Bounding Boxes:
* Dividing Scene based on largest dimension

All existing tests from the book's 17 chapters have been implemented and currently pass. In addition the 3 available bonus chapters have also been implemented along wifh multiple light support and material inheritance. This was a project for me to learn Swift while doing something enjoyable like tranforming mathematics into pretty pictures.
