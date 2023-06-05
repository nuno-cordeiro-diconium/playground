//
//  DurationFormatter.swift
//  playground
//
//  Created by Nuno Cordeiro on 29/05/2023.
//
import Foundation


//ISO8601DurationFormatter codebase imported from https://github.com/cyrilchandelier/ISO8601DurationFormatter/tree/main

public class ISO8601DurationFormatter {
    /// Preferred initializer for ISO8601DurationFormatter
    public init() {
        // Empty initializer is let public for it to be used across modules
    }

    /// Converts an ISO8601 duration into a duration in seconds
    /// - Parameter durationString: a string representing formatted in the ISO8601 format
    /// - Throws: when the Regex can not be generated or if the input format is invalid
    /// - Returns: a duration in seconds
    public func duration(from durationString: String, representedIn: DurationComponent) throws -> TimeInterval {
        guard let regex = try? NSRegularExpression(pattern: Constants.capturePattern, options: []) else {
            throw Exception.failedToGeneratePattern
        }

        // Apply the regular expression onto the given duration string
        let range = NSRange(durationString.startIndex ..< durationString.endIndex, in: durationString)
        let matches = regex.matches(in: durationString, options: [], range: range)
        guard let match = matches.first, match.range == range else {
            throw Exception.invalidFormat
        }

        // Convert all extracted components into seconds
        var duration: TimeInterval = 0
        for durationComponent in DurationComponent.allCases {
            let matchRange = match.range(withName: durationComponent.rawValue)
            if let substringRange = Range(matchRange, in: durationString) {
                let capture = String(durationString[substringRange])
                let number = TimeInterval(capture) ?? 0
                duration += number * durationComponent.multiplier
            }
        }

        return duration / representedIn.multiplier
    }

    /// Format a duration from a number of seconds to an ISO8601 duration string
    /// - Parameter duration: a number of seconds
    /// - Throws: when input duration is negative
    /// - Returns: an ISO8601 duration string
    public func string(from duration: TimeInterval) throws -> String {
        guard duration >= 0 else {
            throw Exception.unsupportedNegativeDuration
        }

        // Empty durations are represented with P0D
        if duration == 0 {
            return "P0D"
        }

        var remainingSeconds = duration
        var result: String = "P"

        // Years
        let years = Int(remainingSeconds / Constants.oneYearInSeconds)
        if years > 0 {
            result += "\(years)Y"
            remainingSeconds = remainingSeconds.truncatingRemainder(
                dividingBy: Constants.oneYearInSeconds
            )
        }


        // Months
        let months = Int(remainingSeconds / Constants.oneMonthInSeconds)
        if months > 0 {
            result += "\(months)M"
            remainingSeconds = remainingSeconds.truncatingRemainder(
                dividingBy: Constants.oneMonthInSeconds
            )
        }

        // Days
        let days = Int(remainingSeconds / Constants.oneDayInSeconds)
        if days > 0 {
            result += "\(days)D"
            remainingSeconds = remainingSeconds.truncatingRemainder(
                dividingBy: Constants.oneDayInSeconds
            )
        }

        // Time start
        if remainingSeconds > 0 {
            result += "T"
        }

        // Hours
        let hours = Int(remainingSeconds / Constants.oneHourInSeconds)
        if hours > 0 {
            result += "\(hours)H"
            remainingSeconds = remainingSeconds.truncatingRemainder(
                dividingBy: Constants.oneHourInSeconds
            )
        }

        // Minutes
        let minutes = Int(remainingSeconds / Constants.oneMinuteInSeconds)
        if minutes > 0 {
            result += "\(minutes)M"
            remainingSeconds = remainingSeconds.truncatingRemainder(
                dividingBy: Constants.oneMinuteInSeconds
            )
        }

        // Seconds
        if remainingSeconds > 0 {
            if remainingSeconds.truncatingRemainder(dividingBy: 1) == 0 {
                result += "\(String(format: "%.0f", remainingSeconds))S"
            } else {
                result += "\(String(format: "%.3f", remainingSeconds))S"
            }
        }

        return result
    }

    public enum Exception: Error {
        case failedToGeneratePattern
        case invalidFormat
        case unsupportedNegativeDuration
    }

    public enum DurationComponent: String, CaseIterable {
        case years
        case months
        case weeks
        case days
        case hours
        case minutes
        case seconds

        var multiplier: TimeInterval {
            switch self {
            case .years: return Constants.oneYearInSeconds
            case .months: return Constants.oneMonthInSeconds
            case .weeks: return Constants.oneWeekInSeconds
            case .days: return Constants.oneDayInSeconds
            case .hours: return Constants.oneHourInSeconds
            case .minutes: return Constants.oneMinuteInSeconds
            case .seconds: return 1
            }
        }
    }

    private struct Constants {
        static let capturePattern: String = #"P((?<years>\d+(\.\d+)?)Y)?"# +
            #"((?<months>\d+(\.\d+)?)M)?"# +
            #"((?<weeks>\d+(\.\d+)?)W)?"# +
            #"((?<days>\d+(\.\d+)?)D)?"# +
            #"(T"# +
            #"((?<hours>\d+(\.\d+)?)H)?"# +
            #"((?<minutes>\d+(\.\d+)?)M)?"# +
            #"((?<seconds>\d+(\.\d+)?)S)?"# +
            #")?"#
        static let oneMinuteInSeconds: TimeInterval = 60
        static let oneHourInSeconds: TimeInterval = 60 * oneMinuteInSeconds
        static let oneDayInSeconds: TimeInterval = 24 * oneHourInSeconds
        static let oneWeekInSeconds: TimeInterval = 7 * oneDayInSeconds
        static let oneMonthInSeconds: TimeInterval = 30 * oneDayInSeconds
        static let oneYearInSeconds: TimeInterval = 365 * oneDayInSeconds
    }
    
    
}

extension TimeInterval {
    func inDays() -> Double {
        return self / (24 * 3600)
    }
}
