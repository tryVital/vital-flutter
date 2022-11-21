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
