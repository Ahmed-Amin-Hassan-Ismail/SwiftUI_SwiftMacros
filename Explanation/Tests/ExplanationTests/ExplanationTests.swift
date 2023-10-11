import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(ExplanationMacros)
import ExplanationMacros

let testMacros: [String: Macro.Type] = [
    "stringify": StringifyMacro.self,
    "StructInit": StructInitMacro.self,
    "EnumTitle": EnumTitleMacro.self
]
#endif

final class ExplanationTests: XCTestCase {
    func testMacro() throws {
#if canImport(ExplanationMacros)
        assertMacroExpansion(
            """
            #stringify(a + b)
            """,
            expandedSource: """
            (a + b, "a + b")
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    
    func testMacroWithStringLiteral() throws {
#if canImport(ExplanationMacros)
        assertMacroExpansion(
            #"""
            #stringify("Hello, \(name)")
            """#,
            expandedSource: #"""
            ("Hello, \(name)", #""Hello, \(name)""#)
            """#,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
}


// MARK: - Struct Init Test

extension ExplanationTests {
    
    func testStructInit() {
        
        assertMacroExpansion("""
        
        @StructInit
        struct User {
        
            var name: String
            var email: String
            var age: Int
            
            init(name: String, email: String, age: Int) {
                self.name = name
                self.email = email
                self.age = age
            }
        }
        
        
        """, expandedSource: """
        
                @StructInit
                struct User {
        
                    var name: String
                    var email: String
                    var age: Int
        
                }
        
        
        """, macros: testMacros)
    }
}


// MARK: - Enum Title Text

extension ExplanationTests {
    
    func testEnumTitle() {
        
        assertMacroExpansion("""
        
        @EnumTitle
        enum Direction {
            
            case north
            case south
            case east
            case west
            
            var title: String {
                switch self {
                case .north:
                    return "North"
                case .south:
                    return "South"
                case .east:
                    return "East"
                case .west:
                    return "West"
                }
            }
        }

        
        """, expandedSource: """
                @EnumTitle
                enum Direction {
                    
                    case north
                    case south
                    case east
                    case west
                    
                   
                }
        """, macros: testMacros)
        
    }
}
