@testable import SwiftlyRT

import XCTest

class SwiftlyRTTests: XCTestCase {
    func testMathUpdate() async throws {
        let yaml = """
            - add: camera
              width: 10
              height: 10
              field-of-view: 0.524
              from: [ 40, 0, -70 ]
              to: [ 0, 0, -5 ]
              up: [ 0, 1, 0 ]

            - add: light
              at: [ 0, 0, -100 ]
              intensity: [ 1, 1, 1 ]

            - add: sphere
              material:
                color: [ 1, 1, 1 ]
                ambient: 0
                diffuse: 0.5
                specular: 0
              transform:
                - [ scale, 200, 200, 0.01 ]
                - [ translate, 0, 0, 20 ]
            """
        var loader = WorldLoader()
        let world = try loader.loadWorld(contents: yaml)
        let camera = world.camera!
        let canvas = camera.render(world: world)
        let ppm = canvas.getPPM()
        if let convertedString = String(data: ppm, encoding: .utf8) {
            print(convertedString)

            let expected = """
            P3
            10 10
            255
            115 115 115 117 117 117 120 120 120 122 122 122 123 123 123 124 124
            124 125 125 125 125 125 125 125 125 125 125 125 125
            116 116 116 119 119 119 121 121 121 123 123 123 124 124 124 125 125
            125 126 126 126 126 126 126 126 126 126 126 126 126
            117 117 117 119 119 119 122 122 122 124 124 124 125 125 125 126 126
            126 127 127 127 127 127 127 127 127 127 126 126 126
            117 117 117 120 120 120 122 122 122 124 124 124 126 126 126 127 127
            127 127 127 127 127 127 127 127 127 127 127 127 127
            117 117 117 120 120 120 123 123 123 125 125 125 126 126 126 127 127
            127 127 127 127 127 127 127 127 127 127 127 127 127
            117 117 117 120 120 120 123 123 123 125 125 125 126 126 126 127 127
            127 127 127 127 127 127 127 127 127 127 127 127 127
            117 117 117 120 120 120 122 122 122 124 124 124 126 126 126 127 127
            127 127 127 127 127 127 127 127 127 127 127 127 127
            117 117 117 119 119 119 122 122 122 124 124 124 125 125 125 126 126
            126 127 127 127 127 127 127 127 127 127 126 126 126
            116 116 116 119 119 119 121 121 121 123 123 123 124 124 124 125 125
            125 126 126 126 126 126 126 126 126 126 126 126 126
            115 115 115 117 117 117 120 120 120 122 122 122 123 123 123 124 124
            124 125 125 125 125 125 125 125 125 125 125 125 125
            
            """

            XCTAssertEqual(expected, convertedString)
        } else {
            XCTFail()
        }
    }
}
