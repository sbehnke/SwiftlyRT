# SwiftlyRT

[![Build Status](https://app.bitrise.io/app/fd706400a4da9218/status.svg?token=ywmySMISPsO_1I0YW3lFmA&branch=master)](https://app.bitrise.io/app/fd706400a4da9218)

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
