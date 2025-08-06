# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.8] - 2025-08-06

### Added
- 5 more Skill fields to donor object

## [0.2.7] - 2025-08-06

### Added
- Emergency Contact, Subscription, and Skill fields to donor object

## [0.2.6] - 2025-08-05

### Added
- Last Served Lead field to donor object

## [0.2.5] - 2025-08-04

### Added
- Kinection ID field to donor object
- UDF update functionality

## [0.2.4] - 2025-08-04

### Added
- Primary Contact & gender fields to donor object

## [0.2.3] - 2025-08-04

### Added
- Citizenship field to donor object

### Fixed
- Fix Gemspec

## [0.2.1] - 2025-08-02

### Added
- Page-based pagination support for `get_all_donors` method

## [0.2.0] - 2025-08-01

### Added
- Initial public release
- Basic DonorPerfect API client functionality
- Support for fetching single and multiple donors
- Donor update functionality

### Features
- Get donor by ID
- Get multiple donors by IDs array  
- Update donor information back to DonorPerfect
- Configurable API key authentication

### Security
- Removed hardcoded sensitive information
- Cleaned up example files for public release