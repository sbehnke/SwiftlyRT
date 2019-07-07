//
//  ObjLoader.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/7/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

extension String {
    var lines: [String] {
        var result: [String] = []
        enumerateLines { line, _ in result.append(line) }
        return result
    }
}

struct ObjParser {
    
    struct OneBasedArray<T> {
        subscript (_ index: Int) -> T {
            return values[index - 1]
        }
        
        mutating func append(_ value: T) {
            values.append(value)
        }
        
        var count: Int {
            return values.count
        }
        
        var values: [T] = []
    }

    static func parse(objFilePath: URL?) -> ObjParser {
        if let path = objFilePath {
            do {
                let contents: String = try String.init(contentsOf: path, encoding: .ascii)
                return ObjParser.parse(objFileData: contents, withFilename: path.lastPathComponent)
            } catch {}
        }
        
        var parser = ObjParser()
        parser.parseError = true
        return parser
    }
    
    private func trianglePoints(pIndex1: Int, pIndex2: Int, pIndex3: Int) -> (Tuple, Tuple, Tuple) {
        let vCount = vertices.count

        if (pIndex1 > 0 && pIndex2 > 0 && pIndex3 > 0 &&
            pIndex1 <= vCount && pIndex2 <= vCount && pIndex3 <= vCount) {
            
            let p1 = vertices[pIndex1]
            let p2 = vertices[pIndex2]
            let p3 = vertices[pIndex3]
            
            return (p1, p2, p3)
        }
        
        return (Tuple.pointZero, Tuple.pointZero, Tuple.pointZero)
    }
    
    private func normalVectors(nIndex1: Int, nIndex2: Int, nIndex3: Int) -> (Tuple, Tuple, Tuple) {
        let nCount = normals.count
        
        if (nIndex1 > 0 && nIndex2 > 0 && nIndex3 > 0 &&
            nIndex1 <= nCount && nIndex2 <= nCount && nIndex3 <= nCount) {
            
            let n1 = normals[nIndex1]
            let n2 = normals[nIndex2]
            let n3 = normals[nIndex3]
            
            return (n1, n2, n3)
        }
        
        return (Tuple.pointZero, Tuple.pointZero, Tuple.pointZero)
    }
    
    static func parse(objFileData: String, withFilename: String = "") -> ObjParser {
        var objParser = ObjParser()
        objParser.fileName = withFilename
        
        var currentGroup = objParser.defaultGroup
        var currentObjectName = ""
        
        objFileData.enumerateLines(invoking: {(line: String, stop: inout Bool) -> () in
            print(line)
            let components = line.split(separator: " ")
            
            if components.count > 1 {
                if components[0] == "v" {
                    // List of geometric vertices, with (x, y, z [,w]) coordinates, w is optional and defaults to 1.0.
                    
                    if components.count == 4 {
                        let a = Double(components[1]) ?? 0
                        let b = Double(components[2]) ?? 0
                        let c = Double(components[3]) ?? 0
                        
                        let point = Tuple.Point(x: a, y: b, z: c)
                        objParser.vertices.append(point)
                    } else if components.count == 5 {
                        let a = Double(components[1]) ?? 0
                        let b = Double(components[2]) ?? 0
                        let c = Double(components[3]) ?? 0
                        let d = Double(components[4]) ?? 0
                        
                        let point = Tuple.Point(x: a, y: b, z: c, w: d)
                        objParser.vertices.append(point)
                    }
                } else if components[0] == "vn" {
                    // List of vertex normals in (x,y,z) form; normals might not be unit vectors.
                    
                    if components.count == 4 {
                        let a = Double(components[1]) ?? 0
                        let b = Double(components[2]) ?? 0
                        let c = Double(components[3]) ?? 0
                        
                        let normal = Tuple.Vector(x: a, y: b, z: c)
                        objParser.normals.append(normal)
                    }
                    else {
                        objParser.ignoredLineCount += 1
                    }
                } else if components[0] == "g" {
                    if line.count > 2 {
                        let start = line.index(line.startIndex, offsetBy: 2)
                        let groupName = String(line[start...])
                        
                        if objParser.groups.keys.contains(groupName) {
                            currentGroup = objParser.groups[groupName]!
                        } else {
                            let g = Group()
                            g.name = groupName
                            objParser.groups[groupName] = g
                            currentGroup = g
                        }
                    } else {
                        objParser.ignoredLineCount += 1
                    }
                } else if components[0] == "vp" {
                    // Parameter space vertices in ( u [,v] [,w] ) form; free form geometry statement
                    objParser.ignoredLineCount += 1

                } else if components[0] == "o" {
                    let start = line.index(line.startIndex, offsetBy: 2)
                    currentObjectName = String(line[start...])
                    objParser.ignoredLineCount += 1

                } else if components[0] == "mtllib" {
                    // Material defined
                    objParser.ignoredLineCount += 1

                } else if components[0] == "usemtl" {
                    // Use a material
                    objParser.ignoredLineCount += 1

                } else if components[0] == "vt" {
                    // List of texture coordinates, in (u, [v ,w]) coordinates, these will vary between 0 and 1, v and w are optional and default to 0.
                    objParser.ignoredLineCount += 1

                } else if components[0] == "l" {
                  // Line element
                    objParser.ignoredLineCount += 1

                } else if components[0] == "f" {
                    // Polygonal face element
                    
                    if (components.count == 4) {
                        if (line.contains("/")) {
                            let subComponents1 = components[1].split(separator: "/")
                            let subComponents2 = components[2].split(separator: "/")
                            let subComponents3 = components[3].split(separator: "/")
                            
                            if (subComponents1.count != 3 || subComponents2.count != 3 || subComponents3.count != 3) {
                                objParser.ignoredLineCount += 1
                            } else {
                                // Vertex Index
                                let pIndex1 = Int(subComponents1[0]) ?? 0
                                let pIndex2 = Int(subComponents2[0]) ?? 0
                                let pIndex3 = Int(subComponents3[0]) ?? 0
                                
//                                // Vertex Texture Index
//                                let tIndex1 = Int(subComponents1[1]) ?? 0
//                                let tIndex2 = Int(subComponents2[1]) ?? 0
//                                let tIndex3 = Int(subComponents3[1]) ?? 0
                                
                                // Vertex Normal
                                let nIndex1 = Int(subComponents1[2]) ?? 0
                                let nIndex2 = Int(subComponents2[2]) ?? 0
                                let nIndex3 = Int(subComponents3[2]) ?? 0
                                
                                let (p1, p2, p3) = objParser.trianglePoints(pIndex1: pIndex1, pIndex2: pIndex2, pIndex3: pIndex3)
                                let (n1, n2, n3) = objParser.normalVectors(nIndex1: nIndex1, nIndex2: nIndex2, nIndex3: nIndex3)
                                let t = SmoothTriangle(point1: p1, point2: p2, point3: p3, normal1: n1, normal2: n2, normal3: n3)
                                t.name = currentObjectName
                                currentGroup.addChild(t)
                            }
                        } else {
                            let pIndex1 = Int(components[1]) ?? 0
                            let pIndex2 = Int(components[2]) ?? 0
                            let pIndex3 = Int(components[3]) ?? 0
                            
                            let (p1, p2, p3) = objParser.trianglePoints(pIndex1: pIndex1, pIndex2: pIndex2, pIndex3: pIndex3)
                            let t = Triangle(point1: p1, point2: p2, point3: p3)
                            t.name = currentObjectName
                            currentGroup.addChild(t)
                        }
                        
                    } else {
                        let tris = objParser.fanTriangulate(components)
                        for tri in tris {
                            tri.name = currentObjectName
                        }
                        currentGroup.addChildren(tris)
                    }
                } else {
                    objParser.ignoredLineCount += 1
                }
            } else {
                objParser.ignoredLineCount += 1
            }
        })
        
        return objParser
    }
    
    func toGroup() -> Group {
        let g = Group()
        g.name = fileName

        for group in groups.values {
            g.addChild(group)
        }
        
        return g
    }
    
    private func fanTriangulate(_ components: [String.SubSequence]) -> [Triangle] {
        var tris: [Triangle] = []
        
        for index in 2..<components.count - 1 {
            let pIndex1 = 1
            let pIndex2 = Int(components[index]) ?? 0
            let pIndex3 = Int(components[index + 1]) ?? 0
            
            let (p1, p2, p3) = trianglePoints(pIndex1: pIndex1, pIndex2: pIndex2, pIndex3: pIndex3)
            let t = Triangle(point1: p1, point2: p2, point3: p3)
            tris.append(t)
        }
        
        return tris
    }
    
    private(set) var fileName = ""
    private(set) var groups: [String:Group] = [:]
    private(set) var parseError = false
    private(set) var defaultGroup = Group()
    private(set) var vertices = OneBasedArray<Tuple>()
    private(set) var normals = OneBasedArray<Tuple>()
    
    private(set) var ignoredLineCount = 0
}
