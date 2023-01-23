## 1.0.0

- Bump version to 1.0.0

## 0.6.0

> Note: This release has breaking changes.

- **FEAT**: expose all the resource types.
- **BREAKING** **FEAT**: VIT-2127 add health connect ([#26](https://github.com/tryVital/vital-flutter/issues/26)).

## 0.5.0

- Graduate package to a stable release. See pre-releases prior to this version for changelog entries.

## 0.5.0-alpha.3

* Fix `BloodPressureMeasurement` type
*

## 0.5.0-alpha.2

* Expose all the available resources in `VitalService` class.

## 0.5.0-alpha.1

* Federate the vital offering. There are now 3 packages: `vital_core`, `vital_devices` and `vital_health`.

## 0.4.0-alpha.7

* Modified the sample to show how to listen continuously for incoming data

## 0.4.0-alpha.6

* Fix the issue when the blood pressure sample type was null

## 0.4.0-alpha.5

* All errors should now be properly handled and reported to the user

## 0.4.0-alpha.4

* Add the android implementation `DeviceManger` to manage the supported glucose and blood pressure devices.

## 0.4.0-alpha.3

* Update iOS SDK to use StatisticalQuery

## 0.4.0-alpha.2

* Added pairing
* Only request permission when the it is required

## 0.4.0-alpha.1

* Add the `DeviceManger` to manage the supported glucose and blood pressure devices.

## 0.3.5

* Update iOS SDK to use StatisticalQuery

## 0.3.4

* Correctly dispose the ios health kit plugin when the app is in the background

## 0.3.0

* **Breaking** - `UserService.getAll` return type change from
  `List<User>` to `GetAllUsersResponse`

## 0.2.1

* HealthKit - split configure method into configureClient and configureHealthkit with auto sync, logging and background
  delivery options

## 0.2.0

* Support for HealthKit

## 0.1.0

* REST Client for https://tryvital.io/
