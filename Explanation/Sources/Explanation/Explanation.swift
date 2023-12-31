
import Foundation

// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that produces both a value and a string containing the
/// source code that generated the value. For example,
///
///     #stringify(x + y)
///
/// produces a tuple `(x + y, "x + y")`.
@freestanding(expression)
public macro stringify<T>(_ value: T) -> (T, String) = #externalMacro(module: "ExplanationMacros", type: "StringifyMacro")

@attached(member, names: named(init))
public macro StructInit() = #externalMacro(module: "ExplanationMacros", type: "StructInitMacro")

@attached(member, names: named(title))
public macro EnumTitle() = #externalMacro(module: "ExplanationMacros", type: "EnumTitleMacro")

@freestanding(expression)
public macro URL(_ string: String) -> URL = #externalMacro(module: "ExplanationMacros", type: "URLMacro")
