# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.5.2] - 2025-09-22

### Fixed
- Null value check in update_dp method

## [0.5.1] - 2025-09-11

### Added
- Support for null values in DP and DPUDF fields

## [0.5.0] - 2025-09-11

### Update
- Required Ruby version to 3.1
- Dependencies to latest versions

## [0.4.3] - 2025-09-07

### Added
- Find Donors by Email functionality
- Create Donor functionality

## [0.5.0] - 2025-09-08
### Updated
- Rest-client to 2.1
- Nokogiri to 1.18
- Ruby to 3.1

## [0.4.2] - 2025-09-06

### Added
- Support for fetching codes from DonorPerfect

## [0.4.1] - 2025-09-05

### Added
- No Email field to donor object

## [0.4.0] - 2025-09-04

### Added
- Support for custom UDF fields

## [0.3.2] - 2025-08-22

### Added
- Lead field to donor object

## [0.3.1] - 2025-08-15

### Added
- User ID to UDF update functionality

### Fixed
- Removed Modified By field from donor object since it can not be updated in DP

## [0.2.9] - 2025-08-15

### Added
- Modified By, Kinection Modified Date, and Kinection Last Logged fields to donor object

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